----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:30:55 10/01/2014 
-- Design Name: 
-- Module Name:    hamming_display - Behavioral 
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

entity hamming_display is port (
	btn : in std_logic; --clock in digit from source or sink
	msg : in std_logic_vector(3 downto 0); --message from source
	msg1 : in std_logic_vector(3 downto 0); --message from sink
	switch : in std_logic; --switch between source and sink display
	digit1 : out std_logic_vector(3 downto 0);
	digit2 : out std_logic_vector(3 downto 0);
	digit3 : out std_logic_vector(3 downto 0);
	digit4 : out std_logic_vector(3 downto 0);
	digit5 : out std_logic_vector(3 downto 0);
	digit6 : out std_logic_vector(3 downto 0);
	digit7 : out std_logic_vector(3 downto 0);
	digit8 : out std_logic_vector(3 downto 0)
	);
end hamming_display;

architecture Behavioral of hamming_display is


begin

	--Just used to adjust between sink and source display.
	--Both are currently displayed in binary
	process(btn) 
	
		type display is array(0 to 3) of std_logic_vector(3 downto 0);
		variable disp : display := (others => (others => '0'));
	
	begin
		if btn = '1' and btn'event then
			disp(3) := disp(2);
			disp(2) := disp(1);
			disp(1) := disp(0);
			disp(0) := msg;
			
			digit4 <= disp(3);
			digit3 <= disp(2);
			digit2 <= disp(1);
			digit1 <= disp(0);
		end if;
	end process;
	
--	process(btn) 
--		
--		type display2 is array(0 to 3) of std_logic_vector(3 downto 0);
--		variable disp2 : display2 := (others => (others => '0'));
--	
--	begin
--		if btn = '1' and btn'event then			
--			disp2(3) := disp2(2);
--			disp2(2) := disp2(1);
--			disp2(1) := disp2(0);
--			disp2(0) := msg1;
--			
--			digit8 <= disp2(3);
--			digit7 <= disp2(2);
--			digit6 <= disp2(1);
--			digit5 <= disp2(0);
--		end if;
--	end process;

end Behavioral;

