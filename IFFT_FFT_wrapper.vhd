----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:40:24 08/17/2017 
-- Design Name: 
-- Module Name:    IFFT_FFT_wrapper - IFFT_FFT_wrapper_arch 
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

entity IFFT_FFT_wrapper is
port(
	--General control signals
	clk,start,rst: in std_logic;
	
	--Data inputs
	i_i,q_i: in std_logic_vector (7 downto 0);
	
	--Data outputs
	i_o,q_o: out std_logic_vector(14 downto 0);
	xo_index: out std_logic_vector(5 downto 0);
	
	--State outputs
	dv_o: out std_logic
);
end IFFT_FFT_wrapper;

architecture IFFT_FFT_wrapper_arch of IFFT_FFT_wrapper is

COMPONENT FFT_mod
  PORT (
    clk : IN STD_LOGIC;
    ce : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    start : IN STD_LOGIC;
    unload : IN STD_LOGIC;
    xn_re : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    xn_im : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;
    fwd_inv_we : IN STD_LOGIC;
    rfd : OUT STD_LOGIC;
    xn_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    dv : OUT STD_LOGIC;
    xk_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    xk_re : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
  );
END COMPONENT;

--Internal signals
signal done_s_ifft,done_s_fft,dv_s_ifft,start_o: std_logic;
signal xk_re_ifft,xk_im_ifft: std_logic_vector (14 downto 0);
signal xk_re_o,xk_im_o: std_logic_vector (14 downto 0);

--State machine signals
type fsmState_t IS (IDLE,UNLOAD);
	signal fsmState,fsmState_next : fsmState_t :=IDLE;

begin

ifft0 : FFT_mod
  PORT MAP (
    clk => clk,
    ce => '1',
    sclr => rst,
    start => start,
    unload => done_s_ifft,
    xn_re => i_i,
    xn_im => q_i,
    fwd_inv => '0',
    fwd_inv_we => '1',
    rfd => open,
    xn_index => open,
    busy => open,
    edone => open,
    done => done_s_ifft,
    dv => dv_s_ifft,
    xk_index => open,
    xk_re => xk_re_ifft,
    xk_im => xk_im_ifft
  );
  
  fft0 : FFT_mod
  PORT MAP (
    clk => clk,
    ce => '1',
    sclr => rst,
    start => start_o,
	 unload => done_s_fft,
    xn_re => xk_re_o(14 downto 7),
    xn_im => xk_im_o(14 downto 7),
    fwd_inv => '1',
    fwd_inv_we => '1',
    rfd => open,
    xn_index => open,
    busy => open,
    edone => open,
    done => done_s_fft,
    dv => dv_o,
    xk_index => xo_index,
    xk_re => i_o,
    xk_im => q_o
  );
  
  --Registros internos para canal I y Q
  process(clk)
  begin
		if (clk'event and clk='1') then
			xk_re_o<=xk_re_ifft;
			xk_im_o<=xk_im_ifft;
		end if;
  end process;
  
  --Maquina de estados para START
  
  process(clk,rst)
		begin

			if (rst='1') then
				fsmState<=IDLE;
					
			elsif (clk'event and clk='1') then
				fsmState<=fsmState_next;
			end if;
	end process;
	
	--Descripcion de la logica de conmutacion de estados
	process(fsmState,dv_s_ifft)
		begin
		fsmState_next<=fsmState;
		
		case fsmState is
		
			when IDLE=>
			
			start_o<='0';
							
			if (dv_s_ifft='1') then
				fsmState_next<=UNLOAD;
				start_o<='1';
			end if;
			
        when UNLOAD=>
			
			start_o<='0';
							
			if (dv_s_ifft='0') then
				fsmState_next<=IDLE;
			end if;
			
		end case;
		
	end process;
end IFFT_FFT_wrapper_arch;

