----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:39:28 09/15/2014 
-- Design Name: 
-- Module Name:    sixteen_led - Behavioral 
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

entity sixteen_led is port (
	slideSwitches : in std_logic_vector(2 downto 0);
	digit : in std_logic_vector(7 downto 0);
	LED : out std_logic_vector(15 downto 0));
end sixteen_led;

architecture Behavioral of sixteen_led is

begin

	process(slideSwitches, digit) begin
	
		if slideSwitches(0) = '1' then --x axis
			
			
			
		elsif slideSwitches(1) = '1' then --y axis
			LED <= (others => '0');
		elsif slideSwitches(2) = '1' then --z axis
			LED <= (others => '0');
		else
			LED <= (others => '0');
		end if;
	end process;

end Behavioral;

