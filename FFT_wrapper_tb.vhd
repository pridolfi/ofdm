--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:12:17 08/16/2017
-- Design Name:   
-- Module Name:   /home/fsl/MSE/PdS3/ofdm/FFT_wrapper_tb.vhd
-- Project Name:  ofdm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FFT_wrapper
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
 
ENTITY FFT_wrapper_tb IS
END FFT_wrapper_tb;
 
ARCHITECTURE behavior OF FFT_wrapper_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FFT_wrapper
    PORT(
         clk : IN  std_logic;
         ce : IN  std_logic;
         sclr : IN  std_logic;
         start : IN  std_logic;
         unload : IN  std_logic;
         xn_re : IN  std_logic_vector(7 downto 0);
         xn_im : IN  std_logic_vector(7 downto 0);
         fwd_inv : IN  std_logic;
         fwd_inv_we : IN  std_logic;
         rfd : OUT  std_logic;
         xn_index : OUT  std_logic_vector(5 downto 0);
         busy : OUT  std_logic;
         edone : OUT  std_logic;
         done : OUT  std_logic;
         dv : OUT  std_logic;
         xk_index : OUT  std_logic_vector(5 downto 0);
         xk_re : OUT  std_logic_vector(14 downto 0);
         xk_im : OUT  std_logic_vector(14 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ce : std_logic := '1';
   signal sclr : std_logic := '0';
   signal start : std_logic := '0';
   signal unload : std_logic := '0';
   signal xn_re : std_logic_vector(7 downto 0) := (others => '0');
   signal xn_im : std_logic_vector(7 downto 0) := (others => '0');
   signal fwd_inv : std_logic := '1';
   signal fwd_inv_we : std_logic := '1';

 	--Outputs
   signal rfd : std_logic;
   signal xn_index : std_logic_vector(5 downto 0);
   signal busy : std_logic;
   signal edone : std_logic;
   signal done : std_logic;
   signal dv : std_logic;
   signal xk_index : std_logic_vector(5 downto 0);
   signal xk_re : std_logic_vector(14 downto 0);
   signal xk_im : std_logic_vector(14 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FFT_wrapper PORT MAP (
          clk => clk,
          ce => ce,
          sclr => sclr,
          start => start,
          unload => unload,
          xn_re => xn_re,
          xn_im => xn_im,
          fwd_inv => fwd_inv,
          fwd_inv_we => fwd_inv_we,
          rfd => rfd,
          xn_index => xn_index,
          busy => busy,
          edone => edone,
          done => done,
          dv => dv,
          xk_index => xk_index,
          xk_re => xk_re,
          xk_im => xk_im
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
		sclr<='1';
		wait for clk_period*5;
		sclr<='0';
		wait for clk_period*10;

		--Load data
		start<='1';
		wait for clk_period;
		start<='0';
		
		for I in 0 to 63 loop
			
			if (I=31) then
				xn_re<="01111111";
				xn_im<="00000000";
			elsif (I=32) then
				xn_re<="01111111";
				xn_im<="00000000";
			else
				xn_re<="00000000";
				xn_im<="00000000";
			end if;
			
		wait for clk_period;
		end loop;
	
		wait until done='1';
		
		unload<='1';
		wait for clk_period;
		unload<='0';

      wait;
   end process;

END;
