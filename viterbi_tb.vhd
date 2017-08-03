-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY viterbi_tb IS
  END viterbi_tb;

  ARCHITECTURE behavior OF viterbi_tb IS 

   -- Component Declaration
   component viterbi_decoder
	port (
		data_in0: in std_logic_vector(0 downto 0);
		data_in1: in std_logic_vector(0 downto 0);
		data_out: out std_logic;
		rdy: out std_logic;
		ce: in std_logic;
		sclr: in std_logic;
		clk: in std_logic);
	end component;

   -- Input Signals
	
	signal clk, ce, sclr : std_logic := '0';
   signal data_in0 : std_logic_vector(0 downto 0);
	signal data_in1 : std_logic_vector(0 downto 0);
	signal data_in : std_logic_vector(1 downto 0);
	
		-- Output signals
	signal data_out : std_logic := '0';
   signal rdy : std_logic;
		
	-- Clock period definitions
   constant clk_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
      uut: viterbi_decoder
		port map (
			data_in0 => data_in0,
			data_in1 => data_in1,
			data_out => data_out,
			rdy => rdy,
			ce => ce,
			sclr => sclr,
			clk => clk);
		
		data_in0(0) <= data_in(0);
		data_in1(0) <= data_in(1);
		
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
  --  Test Bench Statements
     tb : PROCESS
     BEGIN
			data_in <= "00";
			sclr <= '1';
			ce <= '0';
			wait for 100 ns; -- wait until global set/reset completes
			sclr <= '0';
			
			wait for 100 ns;
			
			ce <= '1';
			data_in <= "11";
			wait for clk_period;
			data_in <= "01";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "10";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "11";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "10";
			wait for clk_period;
			data_in <= "10";
			wait for clk_period;
			data_in <= "10";
			wait for clk_period;
			data_in <= "01";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "00";
			wait for clk_period;
			data_in <= "11";
			wait for clk_period;
			data_in <= "11";
			wait for clk_period;
			data_in <= "01";
			wait for clk_period;
			data_in <= "01";
			wait for clk_period;
			data_in <= "01";
			wait for clk_period;
			data_in <= "10";
			wait for clk_period;
			data_in <= "11";
			wait for clk_period;
			data_in <= "11";
			wait for clk_period;

			wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
