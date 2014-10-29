----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:25:11 10/08/2014 
-- Design Name: 
-- Module Name:    sink - Behavioral 
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

entity sink is port (
	LEDs : out std_logic_vector(5 downto 0); --shows the current position in the array
	btn : in std_logic; --used to increment the values that are shown on the 7-SEG
	dig1 : out std_logic_vector(3 downto 0); --4 values are shown from the source at a time
	dig2 : out std_logic_vector(3 downto 0);
	dig3 : out std_logic_vector(3 downto 0);
	dig4 : out std_logic_vector(3 downto 0);
	rst : in std_logic; --reset the counter
	enb : in std_logic; --clock the next value to be stored to the sink
	msg_in : in std_logic_vector(7 downto 0) --the message to be stored in the sink
	);
end sink;

architecture Behavioral of sink is

	type ram_t is array(0 to 63) of std_logic_vector(3 downto 0); --so an array of 4 bit messages
	--instantiate the source to default sent values
	signal ram : ram_t := (others => (others => '0'));
	--Force the data to be stored in ram
	attribute ram_style : string;
	attribute ram_style of ram : signal is "block";
	
	signal counter : std_logic_vector(5 downto 0) := (others => '0'); --counter for which value is stored
--	signal counter2 : std_logic_vector(5 downto 0) := (others => '0'); --counter for which values are displayed

	signal clock : std_logic := '0';
	signal digits : std_logic_vector(15 downto 0) := (others => '0'); --values being shown on 7-seg

begin

	clock <= enb or btn;

	process(clock, rst) begin
		if rst = '1' then
			counter <= (others => '0');
			digits <= (others => '0');
		elsif clock = '1' and clock'event then
			if enb = '1' then
				ram(conv_integer(counter)) <= msg_in(3 downto 0);
				ram(conv_integer(counter+1)) <= msg_in(7 downto 4);
				counter <= counter+2; --writes a byte at a time
			else
				digits <= digits(11 downto 0) & ram(conv_integer(counter));
				counter <= counter + 1;
			end if;
		end if;
	end process;
	
	--display ram array
	dig1 <= digits(3 downto 0);
	dig2 <= digits(7 downto 4);
	dig3 <= digits(11 downto 8);
	dig4 <= digits(15 downto 12);
	
	LEDs <= counter; --display position in array


--	--write message to array
--	process(enb) begin
--		if rst = '1' then --reset write position
--			counter <= (others => '0');
--		elsif enb = '1' and enb'event then --write the values to ram
--			ram(conv_integer(counter)) <= msg_in(3 downto 0);
--			ram(conv_integer(counter+1)) <= msg_in(7 downto 4);
--			counter <= counter+2; --writes a byte at a time
--		end if;
--	end process;
--	
--	--increment display position
--	process(btn) begin
--		if btn = '1' and btn'event then
--			counter2 <= counter2 + 1;
--		end if;
--	end process;
--	
--	--display on 7 -seg
--	dig1 <= ram(conv_integer(counter2));
--	dig2 <= ram(conv_integer(counter2+1));
--	dig3 <= ram(conv_integer(counter2+2));
--	dig4 <= ram(conv_integer(counter2+3));
--	
--	LEDs <= counter2; --shows lowest position being displayed on the seven seg
		
end Behavioral;