----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:14 10/12/2014 
-- Design Name: 
-- Module Name:    spi_read_write - Behavioral 
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

entity spi_read_write is port (
	clk : in std_logic;
	
	msg : in std_logic_vector(7 downto 0); --sends a byte at a time
	rec_msg : out std_logic_vector(7 downto 0); --byte recieved
	enb : in std_logic; --start send
	--Spi Stuff (CE should be handled separately so multiple bytes can be sent/recieved)
	MOSI : out std_logic; --data out line 
	MISO : in std_logic; --data in line
	SCK : out std_logic; --clocking the accelerometer
	fin : out std_logic --indicates has finished sending byte
	);
end spi_read_write;

architecture Behavioral of spi_read_write is

	signal cnt : std_logic_vector (2 downto 0) := (others => '0'); --position in read and write
	signal clk_enb : std_logic := '0'; --enable spi clock
	type state is (waiting, processing);
	signal mode : state := processing;

begin

	SCK <= clk when clk_enb = '1' else '0';

	process(clk) begin
	
		if clk = '0' and clk'event then --on clock down output next value so that it will be clocked in by
			if mode = processing then	  --the radio correctly
				clk_enb <= '1';
				MOSI <= msg(conv_integer(unsigned(cnt)));
			else --don't output any value if the system has not been enabled
				MOSI <= '0';
				clk_enb <= '0';
			end if;
		
		elsif clk = '1' and clk'event then --read in a value on high
			
			case mode is
			
				when waiting => --wait for an spi request
					if enb = '1' then --enable spi
						cnt <= "111";
						rec_msg <= "00000000";
						mode <= processing;
					else --don't do anything if the system hasn't been enabled
						mode <= waiting;
					end if;
				
				when processing => --process SPI request (read in value on clock and decrement count of read in)
					rec_msg(conv_integer(unsigned(cnt))) <= MISO; --read in a bit for the message
					if(cnt = "000") then --if the count is zero then the system has finished read/write a byte
						mode <= waiting;
					else
						cnt <= cnt - 1;
					end if;					
				
			end case;
			
		end if;
	
	end process;
	
	fin <= '1' when enb = '0' and mode = waiting else '0'; --this dictates when the spi interaction is complete (1 byte done)


end Behavioral;

