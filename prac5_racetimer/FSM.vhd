----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:54:45 08/31/2014 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
	port ( clk : in std_logic;
			 button : in std_logic_vector (1 downto 0);
			 count : out std_logic;
			 reseter : out std_logic;
			 firstplace : out std_logic
			);
end FSM;

architecture Behavioral of FSM is

	type state_type is (reset, timing, stop1, stop2);
	signal state : state_type;
	signal debounce : std_logic_vector (13 downto 0) := "00000000000000";

begin

	--state machine
	process (button, clk) begin
	
		if button(0) = '1' then
			state <= reset;
			count <= '0';
			reseter <= '1';
			firstplace <= '0';
			debounce <= "00000000000000";

			
		elsif (clk'event and clk = '1') then
		
			if debounce /= "00000000000000" and button(1) = '0' then
				debounce <= debounce - 1;
			end if;
		
			case state is
				
				when reset =>
					if (button(1) = '1' and debounce = "00000000000000") then
						debounce <= "11111111111111";
						state <= timing;
						count <= '1';
						reseter <= '0';
					else
						state <= reset;
					end if;
					
				when timing =>					
					if (button(1) = '1' and debounce = "00000000000000") then                         
						debounce <= "11111111111111";
						state <= stop1;
						firstplace <= '1';
					else
						state <= timing;
					end if;
					
				when stop1 =>			
					if (button(1) = '1' and debounce = "00000000000000") then
						debounce <= "11111111111111";
						state <= stop2;
						count <= '0';
					else
						state <= stop1;
					end if;
					
				when stop2 =>
					state <= stop2;
					
			end case;		
		
		end if;
	
	end process;

end Behavioral;