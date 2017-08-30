----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:58:12 08/30/2017 
-- Design Name: 
-- Module Name:    fifo_iface - fifo_iface_arch 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_iface is
 port (
	data_in  : in std_logic_vector(7 downto 0);
	valid_in : in std_logic;
	clk,rst  : in std_logic;
	data_out : out std_logic_vector(7 downto 0);
	start_out: out std_logic );
end fifo_iface;

architecture fifo_iface_arch of fifo_iface is

COMPONENT fifo8x64
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    valid : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC
  );
END COMPONENT;

--Maquina de estados
type fsmState_t IS (IDLE,SENDING);
signal fsmState,fsmState_next : fsmState_t :=IDLE;
	
-- señales

signal rd_en_s, full_s, empty_s: std_logic;

begin

fifo : fifo8x64
  PORT MAP (
    clk => clk,
    rst => rst,
    din => data_in,
    wr_en => valid_in,
    rd_en => rd_en_s,
    dout => data_out,
    full => open,
    empty => empty_s,
    valid => open,
	 prog_full => full_s
  );

--Definicion de la maquina de estados

--Descripciòn de la actualizacion de la maquina
	process(clk,rst)
		begin
			if (rst='1') then
				fsmState<=IDLE;				
			elsif (clk'event and clk='1') then
				fsmState<=fsmState_next;
			end if;
	end process;

--Descripcion de la logica de conmutacion de estados
	process(fsmState,rst,full_s,empty_s)
		begin
		fsmState_next<=fsmState;
		
		case fsmState is
					
			when IDLE =>
			
			start_out <= '0';
			rd_en_s <= '0';
			
			if (full_s='1') then
				start_out <= '1';
				fsmState_next<=SENDING;
	    	end if;
			
			when SENDING =>
			
			start_out <= '0';
			rd_en_s <= '1';
			
			if (empty_s='1') then
				fsmState_next<=IDLE;
	    	end if;
		end case;
	end process;
end fifo_iface_arch;
