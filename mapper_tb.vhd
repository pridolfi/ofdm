--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:53:47 07/30/2017
-- Design Name:   
-- Module Name:   /home/fsl/MSE/PdS3/ofdm/mapper_tb.vhd
-- Project Name:  ofdm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mapper
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
 
ENTITY mapper_tb IS
END mapper_tb;
 
ARCHITECTURE behavior OF mapper_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mapper
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         data_in : IN  std_logic_vector(1 downto 0);
         valid_in : IN  std_logic;
         valid_out : OUT  std_logic;
         i_channel : OUT  std_logic_vector(7 downto 0);
         q_channel : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal data_in : std_logic_vector(1 downto 0) := (others => '0');
   signal valid_in : std_logic := '0';

 	--Outputs
   signal valid_out : std_logic;
   signal i_channel : std_logic_vector(7 downto 0);
   signal q_channel : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mapper PORT MAP (
          clk => clk,
          rst => rst,
          data_in => data_in,
          valid_in => valid_in,
          valid_out => valid_out,
          i_channel => i_channel,
          q_channel => q_channel
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
      rst<='1';
		valid_in<='0';
		
		wait for 100 ns;	
		rst<='0';

      wait for clk_period*10;

		valid_in<='1';
		for I in 0 to 15 loop
			data_in<=std_logic_vector(to_unsigned(I / 4,data_in'length));
			wait for clk_period*1;
			data_in<=std_logic_vector(to_unsigned(I rem 4,data_in'length));
			wait for clk_period*1;
		end loop;

		valid_in<='0';
      wait;
   end process;

END;
