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
	clk,rst: in std_logic;
	valid_in: in std_logic;
	valid_out: out std_logic;
	data_in: in std_logic_vector (3 downto 0);
	data_out: out std_logic_vector (1 downto 0)

);
end serializer;

architecture serializer_arch of serializer is

--Señales de control
signal sel: std_logic;

--Señales de datos

--Definición de estados y señales fsmSearch
type fsmState_t IS (IDLE_S,DATA_L_S,DATA_H_S);
signal fsmState,fsmState_next : fsmState_t :=IDLE_S;

begin

--Definicion del MUX

	data_out <= data_in(1 downto 0) when sel='0' else
					data_in(3 downto 2) when sel='1';
	
	valid_out <= valid_in;

	process (clk, rst, valid_in)
	begin
		if (rst ='1' or valid_in='0') then
			sel <= '0';
		elsif (clk'event and clk='0' and valid_in='1') then
			sel <= not sel;
		end if;
	end process;


--Descripciòn de la actualizacion de la maquina
--process(clk,rst)
--	begin
--
--		if (rst='1') then
--			fsmState<=IDLE_S;
--				
--		elsif (clk'event and clk='1') then
--			fsmState<=fsmState_next;
--		end if;
--end process;				
--		
--process(fsmState,valid_in)
--begin
--fsmState_next<=fsmState;
--
--case fsmState is
--
--	when IDLE_S=>
--	
--	valid_out<='0';
--	sel<='0';
--				
--	if (valid_in='1') then
--		valid_out<='1';
--		fsmState_next<=DATA_L_S;
--	end if;
--	
--  when DATA_L_S=>
--		
--	sel<='0';
--				
--	if (valid_in='1') then
--		fsmState_next<=DATA_H_S;
--	else
--		fsmState_next<=IDLE_S;
--	end if;
--
--	when DATA_H_S=>
--	
----	valid_out<='1';
--	sel<='1';
--				
--	if (valid_in='1') then
--		fsmState_next<=DATA_L_S;
--	else
--		valid_out<='0';
--		fsmState_next<=IDLE_S;
--	end if;
--	
--end case;
--	
--end process;		

end serializer_arch;

