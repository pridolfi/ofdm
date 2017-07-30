--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:48:40 07/17/2017
-- Design Name:   
-- Module Name:   /home/pablo/work/sdc/cordic/cordic_tb.vhd
-- Project Name:  cordic
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cordic
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
 
ENTITY cordic_tb IS
END cordic_tb;
 
ARCHITECTURE behavior OF cordic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cordic
    port (clk : in std_logic;
		rst,valid_in : in std_logic;
		valid_out : out std_logic;
		x0  : in std_logic_vector (7 downto 0);
		y0  : in std_logic_vector (7 downto 0);
		zn  : out std_logic_vector (3 downto 0));
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal x0 : std_logic_vector(7 downto 0) := (others => '0');
   signal y0 : std_logic_vector(7 downto 0) := (others => '0');
   signal valid_in : std_logic := '0';
   signal valid_out : std_logic := '0';

 	--Outputs
   signal zn : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: cordic PORT MAP (
          clk => clk,
          rst => rst,
          x0 => x0,
          y0 => y0,
          zn => zn,
			 valid_in => valid_in,
			 valid_out => valid_out
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
		rst <= '1';
		valid_in <= '0';
		wait for 100 ns;
		rst <= '0';
		wait for 100 ns;
		wait until clk = '1';
		
		-- 1st quad
      
		x0 <= std_logic_vector(to_signed(126,x0'length));
		y0 <= std_logic_vector(to_signed(25,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
			
		x0 <= std_logic_vector(to_signed(106,x0'length));
		y0 <= std_logic_vector(to_signed(71,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(71,x0'length));
		y0 <= std_logic_vector(to_signed(106,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(25,x0'length));
		y0 <= std_logic_vector(to_signed(126,y0'length)); 
		valid_in <= '1';
		wait for clk_period;
		
		-- 2nd quad
		x0 <= std_logic_vector(to_signed(-25,x0'length));
		y0 <= std_logic_vector(to_signed(126,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(-71,x0'length));
		y0 <= std_logic_vector(to_signed(106,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(-106,x0'length));
		y0 <= std_logic_vector(to_signed(71,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(-126,x0'length));
		y0 <= std_logic_vector(to_signed(25,y0'length)); 
		valid_in <= '1';
		wait for clk_period;
		
		-- 3rd quad
		x0 <= std_logic_vector(to_signed(-126,x0'length));
		y0 <= std_logic_vector(to_signed(-25,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(-106,x0'length));
		y0 <= std_logic_vector(to_signed(-71,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(-71,x0'length));
		y0 <= std_logic_vector(to_signed(-106,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(-25,x0'length));
		y0 <= std_logic_vector(to_signed(-126,y0'length)); 
		valid_in <= '1';
		wait for clk_period;
		
		-- 4th quad
		x0 <= std_logic_vector(to_signed(25,x0'length));
		y0 <= std_logic_vector(to_signed(-126,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(71,x0'length));
		y0 <= std_logic_vector(to_signed(-106,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(106,x0'length));
		y0 <= std_logic_vector(to_signed(-71,y0'length)); 
      valid_in <= '1';
		wait for clk_period;
		
		x0 <= std_logic_vector(to_signed(126,x0'length));
		y0 <= std_logic_vector(to_signed(-25,y0'length)); 
		valid_in <= '1';
		wait for clk_period;
		
		valid_in <= '0';
      wait;
   end process;

END;
