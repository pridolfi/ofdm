----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:19:40 07/24/2017 
-- Design Name: 
-- Module Name:    top_module - top_module_arch 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
	port(
		fx2_clk, fx2_rst, clk_system,clk2x_system : in  std_logic;
		-- Host >> FPGA pipe:
		h2fData_out                  : in  std_logic_vector(7 downto 0); -- data lines used when the host writes to a channel
		h2fValid_out                 : in  std_logic; -- '1' means "on the next clock rising edge, please accept the data on h2fData_out"
		h2fReady_in                  : out std_logic; -- channel logic can drive this low to say "I'm not ready for more data yet"

		-- Host << FPGA pipe:
		f2hData_in                   : out std_logic_vector(7 downto 0); -- data lines used when the host reads from a channel
		f2hValid_in                  : out std_logic; -- channel logic can drive this low to say "I don't have data ready for you"
		f2hReady_out                 : in  std_logic -- '1' means "on the next clock rising edge, put your next byte of data on f2hData_in"
	);
end top_module;

architecture top_module_arch of top_module is

	--DECLARACION DE COMPONENTES

	--COMPONENTE 0: FIFO 16 BYTES 8 A 1

	COMPONENT fifo_16_2clk
		PORT(
			rst    : IN  STD_LOGIC;
			wr_clk : IN  STD_LOGIC;
			rd_clk : IN  STD_LOGIC;
			din    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			wr_en  : IN  STD_LOGIC;
			rd_en  : IN  STD_LOGIC;
			dout   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			full   : OUT STD_LOGIC;
			empty  : OUT STD_LOGIC;
			valid  : OUT STD_LOGIC
		);
	END COMPONENT;

	--COMPONENTE 1: FIFO 16 BYTES 1 A 8

	COMPONENT fifo_16_2clk_1a8
		PORT(
			rst    : IN  STD_LOGIC;
			wr_clk : IN  STD_LOGIC;
			rd_clk : IN  STD_LOGIC;
			din    : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			wr_en  : IN  STD_LOGIC;
			rd_en  : IN  STD_LOGIC;
			dout   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			full   : OUT STD_LOGIC;
			empty  : OUT STD_LOGIC;
			valid  : OUT STD_LOGIC
		);
	END COMPONENT;

	--COMPONENTE 2: CODIFICADOR CONVOLUCIONAL

	component conv_encoder
		port(
			data_in    : in  std_logic;
			data_out_v : out std_logic_vector(1 downto 0);
			rdy        : out std_logic;
			nd			  : in std_logic;
			ce         : in  std_logic;
			sclr       : in  std_logic;
			clk        : in  std_logic);
	end component;

	--COMPONENTE 3: DECODIFICADOR VITERBI

	component viterbi_decoder
		port(
			data_in0 : in  std_logic_vector(0 downto 0);
			data_in1 : in  std_logic_vector(0 downto 0);
			data_out : out std_logic;
			rdy      : out std_logic;
			ce       : in  std_logic;
			sclr     : in  std_logic;
			clk      : in  std_logic);
	end component;
	
	--COMPONENTE 4: MAPPER
	component mapper
	port(
		clk,rst: in std_logic;
		data_in: in std_logic_vector (1 downto 0);
		valid_in: in std_logic;
		valid_out: out std_logic;
		i_channel,q_channel: out std_logic_vector(7 downto 0)
	);
	end component;
	
	--COMPONENTE 5: CORDIC
	
	component cordic
	port (clk : in std_logic;
		rst,valid_in : in std_logic;
		valid_out : out std_logic;
		x0  : in std_logic_vector (7 downto 0);
		y0  : in std_logic_vector (7 downto 0);
		zn  : out std_logic_vector (3 downto 0));
	end component;
	
	--COMPONENTE 6: SERIALIZER
	component serializer
	port(
		rd_clk,wr_clk,rst: in std_logic;
		valid_in: in std_logic;
		valid_out: out std_logic;
		data_in: in std_logic_vector (3 downto 0);
		data_out: out std_logic_vector (1 downto 0)
	);
	end component;
	
	--COMPONENTE 7: FIFO_IFACE I PARA MAPPER>IFFT
	component  fifo_iface
	port (
	data_in  : in std_logic_vector(7 downto 0);
	valid_in : in std_logic;
	clk,rst  : in std_logic;
	data_out : out std_logic_vector(7 downto 0);
	start_out: out std_logic );
	end component;
	
	--COMPONENTE 8: IFFT-FFT
	COMPONENT IFFT_FFT_wrapper
    PORT(
         clk : IN  std_logic;
         start : IN  std_logic;
         rst : IN  std_logic;
         i_i : IN  std_logic_vector(7 downto 0);
         q_i : IN  std_logic_vector(7 downto 0);
         i_o : OUT  std_logic_vector(21 downto 0);
         q_o : OUT  std_logic_vector(21 downto 0);
         xo_index : OUT  std_logic_vector(5 downto 0);
         dv_o : OUT  std_logic
        );
    END COMPONENT;
		
	--DECLARACION DE SEÑALES

	--GENERALES
	signal clk_s,clk2x_s, rst_s : std_logic;

	--FIFO ENTRADA -> CONVOLUCIONADOR
	signal fifo_in_rd_en_s,fifo_in_empty_s, conv_ce_s : std_logic;
	signal conv_in_s: std_logic_vector(0 downto 0);

	--CONVOLUCIONADOR -> VITERBI
--	signal conv_data_out_s : std_logic_vector(1 downto 0);
--	signal viterbi_data_in0: std_logic_vector(0 downto 0);
--	signal viterbi_data_in1: std_logic_vector(0 downto 0);
	
	--CONVOLUCIONADOR -> MAPPER
	signal rdy_conv_s: std_logic;
	signal data_out_conv_s: std_logic_vector (1 downto 0);
	
	--MAPPER->FIFO_IFACE->IFFT->FFT
	signal mapper_i_s, mapper_q_s : std_logic_vector(7 downto 0);
	signal start_ifft_s : std_logic;
	
	--FFT -> CORDIC
	signal i_channel_s,q_channel_s: std_logic_vector (7 downto 0);
	signal valid_out_mapper_s: std_logic;
	signal fft_i_s, fft_q_s : std_logic_vector(21 downto 0);
	signal fft_valid_out_s : std_logic;	
	
	--CORDIC->SERIALIZER
	signal data_out_cordic_s: std_logic_vector (3 downto 0);
	signal valid_out_cordic_s: std_logic;
	
	--SERIALIZER-> VITERBI
	signal data_out_serial_s: std_logic_vector (1 downto 0);
	signal viterbi_ce,valid_out_serial_s: std_logic;
	signal viterbi_data_in0: std_logic_vector(0 downto 0);
   signal viterbi_data_in1: std_logic_vector(0 downto 0);
	
 --VITERBI -> FIFO SALIDA
	signal decoder_out_s: std_logic_vector(0 downto 0);
	signal decoder_ready_s, fifo_out_empty_s, fifo_out_rd_en_s : std_logic;
	signal out_s : std_logic;
	
begin

	clk_s<=clk_system;
	clk2x_s<=clk2x_system;
	rst_s<=fx2_rst;
	-- INSTANCIACION DE COMPONENTES

	--FIFO DE ENTRADA

	fifo_in0 : fifo_16_2clk
		PORT MAP(
			rst    => fx2_rst,
			wr_clk => fx2_clk,
			rd_clk => clk_s,
			din    => h2fData_out,
			wr_en  => h2fValid_out,
			rd_en  => fifo_in_rd_en_s,
			dout   => conv_in_s,
			full   => open,
			empty  => fifo_in_empty_s,
			valid  => conv_ce_s
		);
		
		fifo_in_rd_en_s<=not fifo_in_empty_s;

		--CODIFICADOR CONVOLUCIONAL

	encoder0 : conv_encoder
		port map(
			data_in    => conv_in_s(0),
			data_out_v => data_out_conv_s,
			rdy        => rdy_conv_s,
			nd => conv_ce_s,
			ce         => '1',
			sclr       => rst_s,
			clk        => clk_s
		);

		--MAPPER
			
			mapper0 : mapper
			port map (
				clk=>clk_s,
				rst=>fx2_rst,
				data_in=>data_out_conv_s,
				valid_in=>rdy_conv_s,
				valid_out=>valid_out_mapper_s,
				i_channel=>i_channel_s,
				q_channel=>q_channel_s
			);
			
			fifo_iface_ifft_i : fifo_iface
			port map(
				data_in  => i_channel_s,
				valid_in => valid_out_mapper_s,
				clk => clk_s,
				rst => fx2_rst,  
				data_out => mapper_i_s,
				start_out => start_ifft_s
			);
				
			fifo_iface_ifft_q : fifo_iface
			port map(
				data_in  => q_channel_s,
				valid_in => valid_out_mapper_s,
				clk => clk_s,
				rst => fx2_rst,  
				data_out => mapper_q_s,
				start_out => start_ifft_s
			);
			
			fft_ifft : IFFT_FFT_wrapper
			PORT map (
         clk => clk_s,
         start => start_ifft_s,
         rst => fx2_rst,
         i_i => mapper_i_s,
         q_i => mapper_q_s,
         i_o => fft_i_s,
         q_o => fft_q_s,
         xo_index => open,
         dv_o => fft_valid_out_s
         );
			
			cordic0: cordic
			port map(
				clk=>clk_s,
				rst=>fx2_rst,
				valid_in=>fft_valid_out_s,
				valid_out =>valid_out_cordic_s,
				x0=>fft_i_s(13 downto 6),
				y0=>fft_q_s(13 downto 6),
				zn=> data_out_cordic_s
			);
			
			serializer0: serializer
			port map(
				wr_clk=>clk_s,
				rd_clk=>clk2x_s,
				rst=>fx2_rst,
				valid_in=>valid_out_cordic_s,
				valid_out=>valid_out_serial_s,
				data_in=> data_out_cordic_s,
				data_out=> data_out_serial_s
			);


		--DECODIFICADOR VITERBI
	viterbi0 : viterbi_decoder
		port map(
			data_in0 => viterbi_data_in0,
			data_in1 => viterbi_data_in1,
			data_out => decoder_out_s(0),
			rdy      => decoder_ready_s,
			ce       => viterbi_ce,
			sclr     => rst_s,
			clk      => clk2x_s
		);

	viterbi_ce <= '1' when valid_out_serial_s = '1' or decoder_ready_s = '1' else
					  '0';
	
	viterbi_data_in0(0) <= data_out_serial_s(0) when valid_out_serial_s = '1' else
								 '0'; -- padding
	viterbi_data_in1(0) <= data_out_serial_s(1) when valid_out_serial_s = '1' else
								 '0'; -- padding
	
	h2fReady_in<='1';
	
	out_s <= valid_out_serial_s and decoder_ready_s and decoder_out_s(0);

		--FIFO DE SALIDA
	fifo_out0 : fifo_16_2clk_1a8
		PORT MAP(
			rst    => rst_s,
			wr_clk => clk2x_s,
			rd_clk => fx2_clk,
			din    => decoder_out_s,
			wr_en  => decoder_ready_s,
			rd_en  => fifo_out_rd_en_s,
			dout   => f2hData_in,
			full   => open,
			empty  => fifo_out_empty_s,
			valid  => f2hValid_in
		);

		fifo_out_rd_en_s<=(not fifo_out_empty_s) and f2hReady_out;

end top_module_arch;

