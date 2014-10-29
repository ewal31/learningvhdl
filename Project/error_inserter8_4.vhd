----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:00:30 10/08/2014 
-- Design Name: 
-- Module Name:    error_inserter8_4 - Behavioral 
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

entity error_inserter8_4 is port
	(
	clk : in std_logic;
	btn : in std_logic_vector(3 downto 0);
	smsg : in std_logic_vector(3 downto 0);
	slideSwitches : in std_logic_vector(7 downto 0);
	coded_witherrors : out std_logic_vector(7 downto 0);
	decdsp : in std_logic_vector(3 downto 0);
	coded : in std_logic_vector(7 downto 0);
	display : out std_logic_vector(7 downto 0)
	);
end error_inserter8_4;

architecture Behavioral of error_inserter8_4 is

	signal errors : std_logic_vector(7 downto 0); --encoded value with slideSwitch errors added
	
	--state machine for adjusting the display
	type state_type is (input, encoded, output);
	signal state : state_type := (input);

begin

	process(clk) begin
	
		if (btn(0) = '1') then --button zero advances to next message so change display to that
			state <= input;
	
	
		elsif clk = '1' and clk'event then
		
			case state is
				
				when input => --state shows current message
					display <= "0000" & smsg;
					if (btn(2) = '1') then
						state <= encoded;
					elsif (btn(3) = '1') then
						state <= output;
					end if;
					
				when encoded => --state shows the current encoded value
					display <= errors;
					if (btn(1) = '1') then
						state <= input;
					elsif (btn(3) = '1') then
						state <= output;
					end if;
					
				when output => --state shows the current decoded value
					display <= "0000" & decdsp;
					if (btn(1) = '1') then
						state <= input;
					elsif (btn(2) = '1') then
						state <= encoded;
					end if;
					
			end case;
--			if btn(1) = '1' or btn(0) = '1' then
--				display <= "0000" & smsg;
--			elsif btn(2) = '1' then
--				display <= errors;
--			elsif btn(3) = '1' then
--				display <= "0000" & decdsp;
--			end if;
	
		end if;
	end process;
	
	--add errors to the encoded input message
	errors <= coded xor slideSwitches;
	coded_witherrors <= errors;

end Behavioral;

