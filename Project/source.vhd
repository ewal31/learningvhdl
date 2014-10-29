----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:15:16 10/01/2014 
-- Design Name: 
-- Module Name:    source - Behavioral 
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

entity source is port (
	LEDs : out std_logic_vector(5 downto 0); --the leds light up to indicate position in the source
	btn : in std_logic; --used to increment display position
	dig1 : out std_logic_vector(3 downto 0); --the digits show 4 values from the source at a time
	dig2 : out std_logic_vector(3 downto 0);
	dig3 : out std_logic_vector(3 downto 0);
	dig4 : out std_logic_vector(3 downto 0);
	rst : in std_logic; --returns the counter to 0
	enb : in std_logic; --clocks the next value in the source
	msg : out std_logic_vector(7 downto 0) --two hex symbols that can be read at a time
	);
end source;

architecture Behavioral of source is

	type ram_t is array(0 to 63) of std_logic_vector(3 downto 0); --so an array of 4 bit messages
	--instantiate the source to default sent values
	signal ram : ram_t := (
								  --x"0", x"1", x"2", x"3", x"4", x"5", x"6", x"7", x"8", x"9", x"A", x"B", x"C", x"D", x"E", x"F", --16
								  x"D", x"E", x"C", x"0", x"D", x"E", x"D", x"C", x"5", x"5", x"E", x"4", x"0", x"1", x"0", x"F",
								  x"F", x"E", x"D", x"C", x"B", x"A", x"9", x"8", x"7", x"6", x"5", x"4", x"3", x"2", x"1", x"0", --32
								  x"F", x"E", x"D", x"C", x"B", x"A", x"9", x"8", x"7", x"6", x"5", x"4", x"3", x"2", x"1", x"0", --48
								  x"0", x"1", x"2", x"3", x"4", x"5", x"6", x"7", x"8", x"9", x"A", x"B", x"C", x"D", x"E", x"F"); --64
	--Force the data to be stored in ram
	attribute ram_style : string;
	attribute ram_style of ram : signal is "block";
	
	signal counter : std_logic_vector(5 downto 0) := (others => '0'); --current position in array being read
	signal digits : std_logic_vector(15 downto 0) := (others => '0'); --values being shown on 7-seg
	signal clock : std_logic := '0'; --increment counter (either enb or btn)

begin

	--needs to be clocked synchronously
	clock <= enb or btn;

	--allows register to be cycled through and displayed on 7-seg as well as be send
	process(clock) begin
		if rst = '1' then --reset position
			counter <= (others => '0');
			digits <= (others => '0');
		elsif clock = '1' and clock'event then --increment counter
			if enb = '1' then --this is used by transmitter
				counter <= counter + 2;
			else --this is used by btn to incement display
				digits <= digits(11 downto 0) & ram(conv_integer(counter));
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	msg <= ram(conv_integer(counter+1)) & ram(conv_integer(counter)); --output data
	
	--display ram array
	dig1 <= digits(3 downto 0);
	dig2 <= digits(7 downto 4);
	dig3 <= digits(11 downto 8);
	dig4 <= digits(15 downto 12);
	
	LEDs <= counter; --display position in array
	
end Behavioral;

