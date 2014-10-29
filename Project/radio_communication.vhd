----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:35:28 10/11/2014 
-- Design Name: 
-- Module Name:    radio_communication - Behavioral 
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

library work;
use work.simple_functions.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity radio_communication is port (
	clk : in std_logic; --module clock
	MISO : in std_logic; --master in slave out
	MOSI : out std_logic; --master out slave in
	SCK : out std_logic; --spi clock
	SS : out std_logic; --slave select 
	CE : out std_logic; --help controll the radios mode
	IRQ : in std_logic; --radio IRQ pin (used to detect recieved message)
	slideSwitches : in std_logic_vector(1 downto 0); --switches used to select which base address and channel will be used
	send : in std_logic; --start send message
	rst : in std_logic; --reset state machine and set up radio again with new slide switch arrangement
	source_clock : out std_logic; --clock to get next set of bits from source
	source_msg : in std_logic_vector(3 downto 0); --get message from source
	delay_rst : out std_logic; --reset delay clock
	T_10micro : in std_logic; --clocks at 10 micro seconds
	delay_130micro : in std_logic; --clocks after 130 microseconds
	sink_clock : out std_logic; --clock value into sink
	sink_msg : out std_logic_vector(3 downto 0) --msg clocked into sinc
	);
end radio_communication;

architecture Behavioral of radio_communication is

-------------------------------Data Storage------------------------------------------------------
	--Storing the Channel for each base station
	type rf_channel_arr is array(0 to 3) of std_logic_vector(7 downto 0);
	signal rf_channel : rf_channel_arr := (x"2B", x"2E", x"30", x"32"); --43, 46, 48, 50
	--Force the data to be stored in ram
	attribute ram_style : string;
	attribute ram_style of rf_channel : signal is "block";

	--Storing the address for each base station
	type rf_address_arr is array(0 to 3) of std_logic_vector(31 downto 0);
	signal rf_address : rf_address_arr := (x"12345678", x"12345679", x"1234567A", x"1234567B");
	--Force the data to be stored in ram
--	attribute ram_style : string;
	attribute ram_style of rf_address : signal is "block";
	
	--Default Radio Register Settings
	type rf_settings_arr is array(0 to 30) of std_logic_vector(7 downto 0);
	signal rf_settings : rf_settings_arr := (x"10" or x"20", --write to tx_addr
														  x"00", --tx_addr1
														  x"00", --tx_addr2
														  x"00", --tx_addr3
														  x"00", --tx_addr4
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"0A" or x"20", --write to rx_addr
														  x"00", --rx_addr1
														  x"00", --rx_addr2
														  x"00", --rx_addr3
														  x"00", --rx_addr4
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"01" or x"20", --write to disable ACK
														  x"00", --set to 00
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"02" or x"20", --write to enable RX pipe 0
														  x"01", --enable pipe 0
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"11" or x"20", --write to payload width
														  x"20", --width of 32
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"05" or x"20", --write RF Channel
														  x"00", --RF Channel
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"06" or x"20", --write to RF_Setup
														  x"06", --set gain and bitrate
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"00" or x"20", --write to PWR_UP
														  x"33", --power up and put in rx mode
														  x"FF", --signify end of packet (can't have FF for this section)
														  x"61"	--R_RX_PAYLOAD
														 );
--	attribute ram_style : string;
	attribute ram_style of rf_settings : signal is "block";
	
	--not entirely sure but have made the power control register above and below mask TX_DS and MAX_RT
	--wanted to only see the interupt RX_DR which should signify a recieved message
	--before was 03 -rx mode, 02 - tx mode now 33 - rx mode, 32
	
	
	type packet_arr is array(0 to 11) of std_logic_vector(7 downto 0); --need to add modified status register
	signal packet : packet_arr := (x"00" or x"20", --change config
											 x"32", --write to config
											 x"A0", --W_RX_PAYLOAD
											 x"20", --packet type
											 x"92", --Destination Address 1
											 x"24", --Destination Address 2
											 x"92", --Destination Address 3
											 x"42", --Destination Address 4
											 x"00", --source address 1
											 x"00", --source address 2
											 x"00", --source address 3
											 x"00" --source address 4
											 );
--	attribute ram_style : string;
	attribute ram_style of packet : signal is "block";
											 

--------------------------------------------------------------------------------------------------

-----------------------------External Modules-----------------------------------------------------

component spi_read_write port (
	clk : in std_logic;
	msg : in std_logic_vector(7 downto 0); --sends a byte at a time
	rec_msg : out std_logic_vector(7 downto 0); --byte recieved
	enb : in std_logic; --start send
	--Spi Stuff (CE should be handled separately so multiple bytes can be sent/recieved)
	MOSI : out std_logic; --data out line 
	MISO : in std_logic; --data in line
	SCK : out std_logic; --clocking the accelerometer
	fin : out std_logic --indicates transmission was finished
	);
end component;

--------------------------------------------------------------------------------------------------

	type controller is (waiting, wrt_spi, wrt_spi_wait, form, sending, to_tx, to_rx, recieving); -- Main FSM to controller send and recieve
	signal radio : controller := waiting;
	
	--spi read/write signals
	signal msg : std_logic_vector(7 downto 0) := (others => '0'); --send message
	signal rec_msg : std_logic_vector(7 downto 0) := (others => '0'); --recieve message
	signal spi_enb : std_logic := '0'; --enable byte transfer
	signal spi_fin : std_logic := '0'; --spi transfer complete
	
	signal cnt : std_logic_vector(5 downto 0) := (others => '0');
	
	signal check : std_logic := '0';
	
	signal temp : std_logic_vector(3 downto 0) := (others => '0'); --for performing hamming encode
	
	signal snd_cnt : std_logic_vector(2 downto 0) := (others => '0'); --count how much of the source has been sent

begin

	u1 : spi_read_write port map (
		clk => clk,
		msg => msg,
		rec_msg => rec_msg,
		enb => spi_enb,
		MOSI => MOSI,
		MISO => MISO,
		SCK => SCK,
		fin => spi_fin
	);

	--main SPI controller
	--not going to be able to get this in 4 states so have 8 states to play with
	process(clk)
	
	begin
		
		if rst = '1' then
			--need to add RF_Chan and TX_ADDR to RAM block so
			--store correct tx address for transfer
			rf_settings(1) <= rf_address(conv_integer(slideSwitches)) (7 downto 0);
			rf_settings(2) <= rf_address(conv_integer(slideSwitches)) (15 downto 8);
			rf_settings(3) <= rf_address(conv_integer(slideSwitches)) (23 downto 16);
			rf_settings(4) <= rf_address(conv_integer(slideSwitches)) (31 downto 24);
			--store source address for packet transmission
			packet(8) <= rf_address(conv_integer(slideSwitches)) (7 downto 0);
			packet(9) <= rf_address(conv_integer(slideSwitches)) (15 downto 8);
			packet(10) <= rf_address(conv_integer(slideSwitches)) (23 downto 16);
			packet(11) <= rf_address(conv_integer(slideSwitches)) (31 downto 24);
			--store correct rf channel
			rf_settings(22) <= rf_channel(conv_integer(slideSwitches));
			radio <= wrt_spi;
			CE <= '0';
			cnt <= (others => '0');
			delay_rst <= '1';
			
		
		elsif clk = '1' and clk'event then
		
			case radio is
			
				when waiting => --wait for IRQ or send request
					SS <= '1';
					cnt <= (others => '0');
					if (send = '1') then --initiate transmission
						radio <= form;
						cnt <= "000011";
						snd_cnt <= (others => '0');
					elsif(IRQ = '0') then --initiate transmission (active low so I think down)
						radio <= recieving;
						check <= '0';
					elsif(snd_cnt /= 0 and snd_cnt /= 5) then --continue transmission
						radio <= form;
						cnt <= "000011";
					else --nothing to transmit or recieve
						radio <= waiting;
					end if;
					
				when wrt_spi => --need to cycle through the rf_address array
									 --if get FF then raise slave select instead of outputting message
					if(cnt = 29) then
						CE <= '1';
						radio <= waiting;
					elsif(rf_settings(conv_integer(cnt)) /= x"FF") then
						SS <= '0';
						msg <= rf_settings(conv_integer(cnt));
						spi_enb <= '1'; --enable transfer
						radio <= wrt_spi_wait;--move to wait state
					else
						SS <= '1';
						radio <= wrt_spi;
					end if;
					cnt <= cnt + 1;
					check <= '0';
								
				when wrt_spi_wait => --just waits for a completed write to get next word
					if(spi_fin = '1' and cnt = 38 and check = '1') then
						SS <= '1';
						cnt <= "000000";
						snd_cnt <= snd_cnt + 1;
						radio <= to_tx; --this will be move to tx mode and send
					elsif(spi_fin = '1' and check = '0') then
						radio <= wrt_spi;
						SS <= (cnt(0)) and (not cnt(1)) and (cnt(2)) and (cnt(3)) and (cnt(4));
					elsif(spi_fin = '1' and check = '1') then
						SS <= (cnt(0)) and (not cnt(1)) and (cnt(2)) and (not cnt(3)) and (not cnt(4)) and (not cnt(5));
						radio <= form;
						source_clock <= '0';
					else
						spi_enb <= '0'; --disable next transfer
						radio <= wrt_spi_wait;
					end if;
		
				when form => --Forms the packets for sending information over the radio
					check <= '1';
					SS <= '0';
					if (snd_cnt = 4 and cnt >= 32) then --pad zeroes for final packet
						temp <= "0000";
					elsif (cnt >= 24) then --add message from source
						temp <= source_msg;
						source_clock <= '1';
					elsif (cnt(0) = '0') then --start write to register and add packet start structure
						temp <= packet(conv_integer(cnt(5 downto 1))) (7 downto 4); --need to fix this think just divide 4
					else
						temp <= packet(conv_integer(cnt(5 downto 1))) (3 downto 0);
					end if;
					cnt <= cnt + 1;
					radio <= sending;
					
				when sending => --This states enable transfer of information for filling FIFO Buffer
					source_clock <= '0';
					if (cnt <= 6) then --register commands
						msg <= packet(conv_integer(cnt)-4);
					else
						msg <= hamming_encode84(temp);
					end if;
					spi_enb <= '1';
					radio <= wrt_spi_wait;

				when to_tx => --this is the state which moves from RX to TX Mode
					if(T_10micro = '1' and cnt = 3) then --move to next state
						cnt <= "000000";
						radio <= to_rx;
						--need to change back to rx mode
						
					elsif(T_10micro = '1') then --wait for delay
						delay_rst <= '1'; --reset delay signal
						CE <= cnt(0);
						cnt <= cnt + 1;
						radio <= to_tx;
					else
						delay_rst <= '0'; --start delay count
						radio <= to_tx;
					end if;

				
				when to_rx =>--need to write RX mode register and set CE high
					if(cnt = 3) then
						radio <= waiting;
						CE <= '1';
					elsif(spi_fin = '1' and cnt = 2) then
						radio <= to_rx;
						SS <= '1';
						cnt <= cnt + 1;
					elsif(cnt = 0) then --select register
						SS <= '0';
						cnt <= cnt + 1;
						msg <= rf_settings(27);
						spi_enb <= '1';
					elsif(cnt = 1 and spi_fin = '1') then --write to register
						cnt <= cnt + 1;
						msg <= rf_settings(28);
						spi_enb <= '1';
					else
						spi_enb <= '0';
						radio <= to_rx;
					end if;
				
				when recieving => --waiting for sink to be filled
					--need to read and flush buffer
					--then move to state to_tx with cnt = 2 I think (may have a little too much delay maybe just set CE = 0 and set cnt = 3)
					--rf_settings(30) is the read payload command
					if(cnt = 0) then --send initial read request
						SS <= '0';
						msg <= rf_settings(30);
						spi_enb <= '1';
						cnt <= cnt + 1;
					elsif(cnt = 33 and spi_fin = '1') then
						SS <= '1';
						cnt <= "000011"; 
						radio <= to_tx;
					elsif(spi_fin = '1') then --next message
						msg <= "11111111";
						spi_enb <= '1';
						temp <= hamming_decode84(rec_msg);
						cnt <= cnt + 1;
						if(cnt >= 19) then
							check <= '1';
						end if;
					else
						spi_enb <= '0';
						sink_clock <= '0';
						if(check = '1') then
							sink_msg <= temp;
							sink_clock <= '1';
							check <= '0';
						end if;
					end if;					
		
			end case;
		
		end if;
	
	end process;

end Behavioral;

--prim RX is the lowest bit of the config register
--1 is recieve mode
--0 is transmit mode
--
--so when starting should be in standby 1 and CE = 0
--
--to transmit
--	write to config register
--	CE = 1
-- wait for 130 - 140 micro seconds