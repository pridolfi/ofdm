--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:59:52 08/17/2017
-- Design Name:   
-- Module Name:   /home/fsl/MSE/PdS3/ofdm/IFFT_FFT_wrapper_tb.vhd
-- Project Name:  ofdm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IFFT_FFT_wrapper
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY IFFT_FFT_wrapper_tb IS
END IFFT_FFT_wrapper_tb;
 
ARCHITECTURE behavior OF IFFT_FFT_wrapper_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFFT_FFT_wrapper
    PORT(
         clk : IN  std_logic;
         start : IN  std_logic;
         rst : IN  std_logic;
         i_i : IN  std_logic_vector(7 downto 0);
         q_i : IN  std_logic_vector(7 downto 0);
         i_o : OUT  std_logic_vector(14 downto 0);
         q_o : OUT  std_logic_vector(14 downto 0);
         xo_index : OUT  std_logic_vector(5 downto 0);
         dv_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal rst : std_logic := '0';
   signal i_i : std_logic_vector(7 downto 0) := (others => '0');
   signal q_i : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal i_o : std_logic_vector(14 downto 0);
   signal q_o : std_logic_vector(14 downto 0);
   signal xo_index : std_logic_vector(5 downto 0);
   signal dv_o : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFFT_FFT_wrapper PORT MAP (
          clk => clk,
          start => start,
          rst => rst,
          i_i => i_i,
          q_i => q_i,
          i_o => i_o,
          q_o => q_o,
          xo_index => xo_index,
          dv_o => dv_o
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	begin		
      -- hold reset state for 100 ns.
      wait for clk_period*50;	
		-- Reset module
		rst<='1';
		wait for clk_period*5;
		rst<='0';
		wait for clk_period*10;

		--Load data
		start<='1';
		wait for clk_period;
		start<='0';
		
		for I in 0 to 63 loop
			
			if (I=31) then
				i_i<="00010000";
				q_i<="00000000";
			elsif (I=32) then
				i_i<="00010000";
				q_i<="00000000";
			else
				i_i<="00000000";
				q_i<="00000000";
			end if;
			
		wait for clk_period;
		end loop;
	
		wait until dv_o='1';
		wait until dv_o='0';
		

      wait;
   end process;



END;
