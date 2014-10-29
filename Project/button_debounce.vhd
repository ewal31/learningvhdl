----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:25 10/01/2014 
-- Design Name: 
-- Module Name:    button_debounce - Behavioral 
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

entity button_debounce is port (
	clk : in std_logic; --clock
	pushButtons : in std_logic_vector(4 downto 0); --hardware buttons
	button : out std_logic_vector(4 downto 0) --debounced buttons
	);
end button_debounce;

architecture Behavioral of button_debounce is

	signal counter : std_logic_vector(15 downto 0) := (others => '0'); --counter used to limit how often button goes high
	signal cnt : std_logic_vector(6 downto 0) := (others => '0'); --counter used to control how long a button will stay high for after pressed
	
begin

	process(clk) begin
		if clk = '1' and clk'event then --on clock tick check button state
		
			--buttons can't be pressed until counter reaches zero
			if (pushButtons(4) = '1' or pushButtons(3) = '1' or pushButtons(2) = '1' or pushButtons(1) = '1' or pushButtons(0) = '1') and counter = "0000000000000000" then
				counter <= "1111111111111111";
				cnt <= "1111111";
			end if;
			
			--Show the Button as 1 for only a small time
			if counter /= 0 and pushButtons = 0 then
				counter <= counter - 1;
			end if;
			
			--decrement time the button stays high
			if cnt /= 0 then
				cnt <= cnt - 1;
			end if;
			
		end if;
	end process; 

	button <= pushButtons when cnt /= 0 else (others => '0'); --set debounced button

end Behavioral;