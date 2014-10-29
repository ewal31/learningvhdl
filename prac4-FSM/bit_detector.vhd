----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:57:16 08/21/2014 
-- Design Name: 
-- Module Name:    bit_detector - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bit_detector is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           inputX : in  STD_LOGIC;
           outputZ : out  STD_LOGIC;
			  stateID : out STD_LOGIC_VECTOR (3 downto 0));
end bit_detector;

architecture Behavioral of bit_detector is
	
	type state_type is (Start, B0, B01, B011, B0110, B01101);
	signal y : state_type;
	
	type state_type2 is (Waiting, Flag);
	signal z : state_type2;

begin

	process(reset, clk) begin

		if reset = '1' then
			y <= Start;
			stateID(2 downto 0) <= "000";
		
		elsif (clk'event and clk = '1') then
		
			case y is
			
				when Start 
					=> if inputX = '0' then
							y <= B0;
							stateID(2 downto 0) <= "001";
						else
							y <= Start;
							stateID(2 downto 0) <= "000";
						end if;
				
				when B0
					=> if inputX = '0' then
							y <= B0;
							stateID(2 downto 0) <= "001";
						else
							y <= B01;
							stateID(2 downto 0) <= "010";
						end if;
				
				when B01
					=> if inputX = '0' then
							y <= B0;
							stateID(2 downto 0) <= "001";
						else
							y <= B011;
							stateID(2 downto 0) <= "011";
						end if;
				
				when B011
					=> if inputX = '0' then
							y <= B0110;
							stateID(2 downto 0) <= "100";
						else
							y <= Start;
							stateID(2 downto 0) <= "000";
						end if;
						
				when B0110
					=> if inputX = '0' then
							y <= B0;
							stateID(2 downto 0) <= "001";
						else
							y <= B01101;
							stateID(2 downto 0) <= "101";
						end if;
						
				when B01101
					=> if inputX = '0' then
							y <= B0;
							stateID(2 downto 0) <= "001";
						else
							y <= B011;
							stateID(2 downto 0) <= "011";
						end if;
		
			end case;
		
		end if;
	
	end process;
	
	z <= Flag when y = B01101 else
		  Waiting when (clk'event and clk = '1');
	outputZ <= '1' when z = Flag else '0';

end Behavioral;

