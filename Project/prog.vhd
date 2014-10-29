----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:08:29 10/29/2014 
-- Design Name: 
-- Module Name:    prog - Behavioral 
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

entity prog is port (
	rst : in std_logic; --add channel and address based on slideswitches
	slideSwitches : in std_logic_vector(1 downto 0); --controls which channel and address to use
	prog_cnt : in std_logic_vector(9 downto 0); --controls which ram value is being looked up
	values : out std_logic_vector(11 downto 0); --current value being checked
	prev : out std_logic_vector(3 downto 0) --previous instruction
	);
end prog;

architecture Behavioral of prog is

-------------------------------Data Storage------------------------------------------------------
--	--Storing the Channel for each base station
--	type rf_channel_arr is array(0 to 3) of std_logic_vector(7 downto 0);
--	signal rf_channel : rf_channel_arr := (x"2B", x"2E", x"30", x"32"); --43, 46, 48, 50
--	--Force the data to be stored in ram
--	attribute ram_style : string;
--	attribute ram_style of rf_channel : signal is "block";
--
--	--Storing the address for each base station
--	type rf_address_arr is array(0 to 3) of std_logic_vector(39 downto 0);
--	signal rf_address : rf_address_arr := (x"0012345678", x"0012345679", x"001234567A", x"E7E7E7E7E7"); --001234567B
--	--Force the data to be stored in ram
--	--	attribute ram_style : string;
--	attribute ram_style of rf_address : signal is "block";
	
	--array that contains the program that will be executed
	type prog_arr is array(0 to 160) of std_logic_vector(11 downto 0);
	signal prog : prog_arr := (
	
-------------------------------------Setup Section--------------------
	x"300", --SS = 0
	x"010" or x"020", --write to tx_addr
	x"0E7", --tx_addr1
	x"0E7", --tx_addr2
	x"0E7", --tx_addr3
	x"0E7", --tx_addr4
	x"0E7", --tx_addr5
	x"200", --SS = 1

	x"300", --SS = 0
	x"00A" or x"020", --write to rx_addr
	x"0E7", --rx_addr1
	x"0E7", --rx_addr2
	x"0E7", --rx_addr3
	x"0E7", --rx_addr4
	x"0E7", --rx_addr5
	x"200", --SS = 1

	x"300", --SS = 0
	x"001" or x"020", --write to disable ACK
	x"000", --set to 00
	x"200", --SS = 1

	x"300", --SS = 0
	x"002" or x"020", --write to enable RX pipe 0
	x"001", --enable pipe 0
	x"200", --SS = 1

	x"300", --SS = 0
	x"011" or x"020", --write to payload width
	x"020", --width of 32
	x"200", --SS = 1

	x"300", --SS = 0
	x"005" or x"020", --write RF Channel
	x"032", --RF Channel
	x"200", --SS = 1

	x"300", --SS = 0
	x"006" or x"020", --write to RF_Setup
	x"006", --set gain and bitrate
	x"200", --SS = 1

	x"300", --SS = 0
	x"000" or x"020", --write to PWR_UP
	x"033", --power up and put in rx mode
	x"200", --SS = 1

	x"400", --CE = 1
	x"F00", --Section End

-------------------------------------Transmit Section-----------------
--	x"500", --CE = 0

	--Setup
	x"300", --SS = 0
	x"000" or x"020", --change config
	x"032", --write to config
	x"200", --SS = 1

	--Packet
	x"300", --SS = 0
	x"0A0", --W_RX_PAYLOAD
	x"720", --packet type
	x"700", --source address 1
	x"700", --source address 2
	x"700", --source address 3
	x"700", --source address 4	
	x"742", --Destination Address 1
	x"792", --Destination Address 2
	x"724", --Destination Address 3
	x"792", --Destination Address 4
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"800", --message from source
	x"200", --SS = 1

	--Change back to rx mode
	x"B00", --Delay 140 micro
	x"500", --CE = 0
	x"B00", --Delay 140 micro
	x"400", --CE = 1
	x"B00", --Delay 140 micro
	x"500", --CE = 0
	x"B00", --Delay 1ms
	x"B00", --Delay 1ms
	x"B00", --Delay 1ms
	x"B00", --Delay 1ms
	x"B00", --Delay 1ms
	x"B00", --Delay 1ms
	x"B00", --Delay 1ms

	--Refresh Config Register
	x"300", --SS = 0
	x"000" or x"020", --change config
	x"033", --write to config
	x"200", --SS = 1
	x"400", --CE = 1
	
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms

	
	x"A00", --snd_cnt <= snd_cnt + 1;
	x"F00", --Section End

-------------------------------------Recieve Section------------------
	x"300", --SS = 0
	x"061", --R_RX_PAYLOAD      --will have to do something with these
	x"0FF", --packet type       --values eventually
	x"0FF", --packet type
	x"0FF", --Destination Address 1
	x"0FF", --Destination Address 2
	x"0FF", --Destination Address 3
	x"0FF", --Destination Address 4
	x"0FF", --Destination Address 1
	x"0FF", --Destination Address 2
	x"0FF", --Destination Address 3
	x"0FF", --Destination Address 4
	x"0FF", --source address 1
	x"0FF", --source address 2
	x"0FF", --source address 3
	x"0FF", --source address 4
	x"0FF", --source address 1
	x"0FF", --source address 2
	x"0FF", --source address 3
	x"0FF", --source address 4
	x"9FF", --write first message
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source
	x"9FF", --message from source-- end
	x"9FF", --message from source
	x"9FF", --message from source
	x"200", --SS = 1
	
	x"D00", --increment recieve count

	x"600", --Delay 10 micro

	--RX FLUSH
	x"300", --SS = 0
	x"0E2", --flush RX Fifo
	x"200", --SS = 1
	
	--SET CE LOW
	x"500", --CE = 0	
	x"600", --Delay 10 micro

	--Status Reg
	x"300", --SS = 0
	x"007" or x"020", --status register
	x"040", --reset IRQ
	x"200", --SS = 1

	--Refresh Config Register
	x"300", --SS = 0
	x"000" or x"020", --change config
	x"033", --write to config
	x"200", --SS = 1
	
	--CE HIGH
	x"400", --CE = 1
	
	x"C00", --Delay 1ms
	x"C00", --Delay 1ms

	x"F00"  --Section End
	);
--------------------------------------------------------------------------------------------------

begin

	process(rst, prog_cnt) begin
	
--		if rst = '1' then
--			--need to add RF_Chan and TX_ADDR to RAM block so
--			--store correct tx address for transfer
--			prog(2) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (7 downto 0);
--			prog(3) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (15 downto 8);
--			prog(4) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (23 downto 16);
--			prog(5) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (31 downto 24);
--			prog(6) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (39 downto 32);
--			--store source address for packet transmission
--			prog(49) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (7 downto 0);
--			prog(50) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (15 downto 8);
--			prog(51) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (23 downto 16);
--			prog(52) (7 downto 0) <= rf_address(conv_integer(slideSwitches)) (31 downto 24);
--			--store correct rf channel
--			prog(30) (7 downto 0) <= rf_channel(conv_integer(slideSwitches));
--		else
			values <= prog(conv_integer(prog_cnt));
			prev <= prog(conv_integer(prog_cnt-1)) (11 downto 8);
--		end if;
	end process;

end Behavioral;

