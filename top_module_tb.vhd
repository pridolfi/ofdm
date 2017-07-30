--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:36:39 07/30/2017
-- Design Name:   
-- Module Name:   /home/fsl/MSE/PdS3/ofdm/top_module_tb.vhd
-- Project Name:  ofdm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_module
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
 
ENTITY top_module_tb IS
END top_module_tb;
 
ARCHITECTURE behavior OF top_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_module
    PORT(
         fx2_clk : IN  std_logic;
         fx2_rst : IN  std_logic;
         clk_system : IN  std_logic;
         h2fData_out : IN  std_logic_vector(7 downto 0);
         h2fValid_out : IN  std_logic;
         h2fReady_in : OUT  std_logic;
         f2hData_in : OUT  std_logic_vector(7 downto 0);
         f2hValid_in : OUT  std_logic;
         f2hReady_out : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal fx2_clk : std_logic := '0';
   signal fx2_rst : std_logic := '0';
   signal clk_system : std_logic := '0';
   signal h2fData_out : std_logic_vector(7 downto 0) := (others => '0');
   signal h2fValid_out : std_logic := '0';
   signal f2hReady_out : std_logic := '0';

 	--Outputs
   signal h2fReady_in : std_logic;
   signal f2hData_in : std_logic_vector(7 downto 0);
   signal f2hValid_in : std_logic;

   -- Clock period definitions
   constant fx2_clk_period : time := 10 ns;
   constant clk_system_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_module PORT MAP (
          fx2_clk => fx2_clk,
          fx2_rst => fx2_rst,
          clk_system => clk_system,
          h2fData_out => h2fData_out,
          h2fValid_out => h2fValid_out,
          h2fReady_in => h2fReady_in,
          f2hData_in => f2hData_in,
          f2hValid_in => f2hValid_in,
          f2hReady_out => f2hReady_out
        );

   -- Clock process definitions
   fx2_clk_process :process
   begin
		fx2_clk <= '0';
		wait for fx2_clk_period/2;
		fx2_clk <= '1';
		wait for fx2_clk_period/2;
   end process;
 
   clk_system_process :process
   begin
		clk_system <= '0';
		wait for clk_system_period/2;
		clk_system <= '1';
		wait for clk_system_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for fx2_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
