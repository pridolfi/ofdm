----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:58 07/30/2017 
-- Design Name: 
-- Module Name:    mapper - mapper_arch 
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

entity mapper is

port(
	clk,rst: in std_logic;
	data_in: in std_logic_vector (1 downto 0);
	valid_in: in std_logic;
	valid_out: out std_logic;
	i_channel,q_channel: out std_logic_vector(7 downto 0)
);

end mapper;

architecture mapper_arch of mapper is

	--Declaracion de señales internas

 signal ena_l,ena_h,rst_reg: std_logic;
 signal phase_l,phase_h: std_logic_vector (1 downto 0);
 signal phase_reg: std_logic_vector (3 downto 0);

	--Maquina de estados
	type fsmState_t IS (RESET_S,READY_S, PACKING1_S,PACKING2_S);
	signal fsmState,fsmState_next : fsmState_t :=RESET_S;

begin

	--Definicion del mux de entrada
	
--	with sel select 
--	phase_l <= data_in when '0',
--              "00" when '1';
--	with sel select 
--	phase_h <= "00" when '0',
--              data_in when '1';

	--Definicion del registro de entrada
	
	process(clk,rst_reg,ena_l,ena_h)
	begin
	
		if(clk'event and clk='1')
		then		
			if (rst_reg='1')
			then
				phase_reg<="0000";
			elsif (ena_l='1')
			then
				phase_reg(1 downto 0)<=data_in;
			elsif (ena_h='1')
			then
				phase_reg(3 downto 2)<=data_in;
			end if;
		
		end if;
	
	end process;

-- Definicion de la LUT

	process(phase_reg)
	begin
		 case phase_reg is
			  when "0000" => i_channel <= std_logic_vector(to_signed(+126,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+025,q_channel'length));
			  when "0001" => i_channel <= std_logic_vector(to_signed(+106,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+071,q_channel'length));
			  when "0010" => i_channel <= std_logic_vector(to_signed(+071,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+106,q_channel'length));
			  when "0011" => i_channel <= std_logic_vector(to_signed(+025,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+126,q_channel'length));
			 
			 
			  when "0100" => i_channel <= std_logic_vector(to_signed(-025,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+126,q_channel'length));
			  when "0101" => i_channel <= std_logic_vector(to_signed(-071,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+106,q_channel'length));
			  when "0110" => i_channel <= std_logic_vector(to_signed(-106,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+071,q_channel'length));
			  when "0111" => i_channel <= std_logic_vector(to_signed(-126,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(+025,q_channel'length));
			  
			  when "1000" => i_channel <= std_logic_vector(to_signed(-126,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-025,q_channel'length));
			  when "1001" => i_channel <= std_logic_vector(to_signed(-106,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-071,q_channel'length));
			  when "1010" => i_channel <= std_logic_vector(to_signed(-071,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-106,q_channel'length));
			  when "1011" => i_channel <= std_logic_vector(to_signed(-025,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-126,q_channel'length));
			 
			 
			  when "1100" => i_channel <= std_logic_vector(to_signed(+025,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-126,q_channel'length));
			  when "1101" => i_channel <= std_logic_vector(to_signed(+071,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-106,q_channel'length));
			  when "1110" => i_channel <= std_logic_vector(to_signed(+106,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-071,q_channel'length));
			  when "1111" => i_channel <= std_logic_vector(to_signed(+126,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-025,q_channel'length));
								  
		     when others => i_channel <= std_logic_vector(to_signed(+126,i_channel'length));
								  q_channel <= std_logic_vector(to_signed(-025,q_channel'length));
		 end case;
	end process;

--Definicion de la maquina de estados

--Descripciòn de la actualizacion de la maquina
	process(clk,rst)
		begin

			if (rst='1') then
				fsmState<=RESET_S;
					
			elsif (clk'event and clk='1') then
				fsmState<=fsmState_next;
			end if;
	end process;

--Descripcion de la logica de conmutacion de estados
	process(fsmState,rst,valid_in)
		begin
		fsmState_next<=fsmState;
		
		case fsmState is
		
			when RESET_S =>
			
			ena_l<='0';
			ena_h<='0';
			rst_reg<='1';
			valid_out<='0';
			
			if (rst='0') then
				fsmState_next<=READY_S;
			end if;
			
			when READY_S =>
			
			ena_l<='0';
			ena_h<='0';
			rst_reg<='0';
			valid_out<='0';
			
			if (valid_in='1') then
				fsmState_next<=PACKING1_S;
			end if;
			
			when PACKING1_S =>
			
			ena_l<='1';
			ena_h<='0';
			rst_reg<='0';
			valid_out<='0';
			
			if (valid_in='1') then
				fsmState_next<=PACKING2_S;
		   else
				fsmState_next<=READY_S;
			end if;
			
			when PACKING2_S =>
			
			ena_l<='0';
			ena_h<='1';
			rst_reg<='0';
			valid_out<='1';
			
			if (valid_in='1') then
				fsmState_next<=PACKING1_S;
		   else
				fsmState_next<=READY_S;
			end if;
      		
		end case;
		
	end process;

end mapper_arch;

