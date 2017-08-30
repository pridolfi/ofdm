--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:15:32 08/30/2017
-- Design Name:   
-- Module Name:   /home/pablo/work/sdc/tp_final/ofdm/fifo_iface_tb.vhd
-- Project Name:  ofdm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fifo_iface
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
USE ieee.numeric_std.ALL;
 
ENTITY fifo_iface_tb IS
END fifo_iface_tb;
 
ARCHITECTURE behavior OF fifo_iface_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo_iface
    PORT(
         data_in : IN  std_logic_vector(7 downto 0);
         valid_in : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         data_out : OUT  std_logic_vector(7 downto 0);
         start_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal valid_in : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);
   signal start_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo_iface PORT MAP (
          data_in => data_in,
          valid_in => valid_in,
          clk => clk,
          rst => rst,
          data_out => data_out,
          start_out => start_out
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
		rst <= '1';
		valid_in <= '0';
      wait for 100 ns;	
		rst <= '0';
      
		wait for clk_period*10;

		wait until clk = '1';

		for i_loop in 0 to 63 loop
			data_in <= std_logic_vector(to_unsigned(i_loop, data_in'length));
			valid_in <= '1';
			wait for clk_period;
		end loop;
		
		valid_in <= '0';
		
      wait;
   end process;

END;
