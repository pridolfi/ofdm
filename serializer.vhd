----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:24:54 07/31/2017 
-- Design Name: 
-- Module Name:    serializer - serializer_arch 
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

entity serializer is
port(
	wr_clk, rd_clk,rst: in std_logic;
	valid_in: in std_logic;
	valid_out: out std_logic;
	data_in: in std_logic_vector (3 downto 0);
	data_out: out std_logic_vector (1 downto 0)

);
end serializer;

architecture serializer_arch of serializer is

-- FIFO interna del serializer
COMPONENT fifo4_to_2
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    valid : OUT STD_LOGIC
  );
END COMPONENT;

begin

serializer_fifo : fifo4_to_2
  PORT MAP (
    rst => rst,
    wr_clk => wr_clk,
    rd_clk => rd_clk,
    din(3 downto 2) => data_in(1 downto 0),
	 din(1 downto 0) => data_in(3 downto 2),
    wr_en => valid_in,
    rd_en => '1',
    dout => data_out,
    full => open,
    empty => open,
    valid => valid_out
  );

end serializer_arch;

