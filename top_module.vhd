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
		fx2_clk, fx2_rst, clk_system : in  std_logic;
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

	--DECLARACION DE SEÑALES

	--GENERALES
	signal clk_s, rst_s : std_logic;

	--FIFO ENTRADA -> CONVOLUCIONADOR
	signal fifo_in_rd_en_s,fifo_in_empty_s, conv_ce_s : std_logic;
	signal conv_in_s: std_logic_vector(0 downto 0);

	--CONVOLUCIONADOR -> VITERBI
	signal rdy_conv_s      : std_logic;
	signal conv_data_out_s : std_logic_vector(1 downto 0);
	signal viterbi_data_in0: std_logic_vector(0 downto 0);
	signal viterbi_data_in1: std_logic_vector(0 downto 0);

	--VITERBI -> FIFO SALIDA
	signal decoder_out_s: std_logic_vector(0 downto 0);
	signal decoder_ready_s, fifo_out_empty_s, fifo_out_rd_en_s : std_logic;

begin

	clk_s<=clk_system;

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

		--FIFO DE SALIDA
	fifo_out0 : fifo_16_2clk_1a8
		PORT MAP(
			rst    => rst_s,
			wr_clk => clk_s,
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

		--CODIFICADOR CONVOLUCIONAL

	encoder0 : conv_encoder
		port map(
			data_in    => conv_in_s(0),
			data_out_v => conv_data_out_s,
			rdy        => rdy_conv_s,
			ce         => conv_ce_s,
			sclr       => rst_s,
			clk        => clk_s
		);

		--DECODIFICADOR VITERBI
	viterbi0 : viterbi_decoder
		port map(
			data_in0 => viterbi_data_in0,
			data_in1 => viterbi_data_in1,
			data_out => decoder_out_s(0),
			rdy      => decoder_ready_s,
			ce       => rdy_conv_s,
			sclr     => rst_s,
			clk      => clk_s
		);

	viterbi_data_in0(0)<=conv_data_out_s(0);
	viterbi_data_in1(0)<=conv_data_out_s(1);

end top_module_arch;

