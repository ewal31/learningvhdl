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

entity radio_design is port (
	clk : in std_logic; --module clock
	MISO : in std_logic; --master in slave out
	MOSI : out std_logic; --master out slave in
	SCK : out std_logic; --spi clock
	SS : out std_logic; --slave select 
	CE : out std_logic; --help controll the radios mode
	IRQ : in std_logic; --radio IRQ pin (used to detect recieved message)
	error_switches : in std_logic_vector(7 downto 0);
	slideSwitches : in std_logic_vector(1 downto 0); --switches used to select which base address and channel will be used
	send : in std_logic; --start send message
	rst : in std_logic; --reset state machine and set up radio again with new slide switch arrangement
	source_clock : out std_logic; --clock to get next set of bits from source
	source_msg : in std_logic_vector(7 downto 0); --get message from source
	delay_rst : out std_logic; --reset delay clock
	T_10micro : in std_logic; --clocks at 10 micro seconds
	sink_clock : out std_logic; --clock value into sink
	sink_msg : out std_logic_vector(7 downto 0); --msg clocked into sinc
	source_rst : out std_logic; --resets the source counter position
	sink_rst : out std_logic; --resest the sink counter position
	re_cnt : out std_logic_vector(1 downto 0); --just used to show on logic analyzer
	statusLeds : out std_logic_vector(2 downto 0) --LEDs that indicate if errors have been received
	);
end radio_design;

architecture Behavioral of radio_design is

-----------------------------External Modules-----------------------------------------------------

--read and write commands to radio
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

--module for inserting errors into vector
component erro_insertion port ( --insert error into sent message
	switches : in std_logic_vector(7 downto 0); --choose what errors to insert
	msg_in : in std_logic_vector(7 downto 0); --message that will have errors inserted
	msg_out : out std_logic_vector(7 downto 0) --inputted message with errors
 );
end component;

--Contains the program for running this module in ram
component prog is port (
	rst : in std_logic; --add channel and address based on slideswitches
	slideSwitches : in std_logic_vector(1 downto 0); --controls which channel and address to use
	prog_cnt : in std_logic_vector(9 downto 0); --controls which ram value is being looked up
	values : out std_logic_vector(11 downto 0); --current value being checked
	prev : out std_logic_vector(3 downto 0) --previous instruction
	);
end component;

--------------------------------------------------------------------------------------------------
	
	--Controls position in array
	signal prog_cnt : std_logic_vector(9 downto 0) := (others => '0');
	
	--fsm has a part for hamming encode and decode as well as a wait state while spi is being completed
	type controller_fsm is (waiting, processing, communicating, hamming, decode);
	signal controller : controller_fsm := waiting;
	
	--singals to control when spi message is ready to be sent and when interaction complete
	signal spi_enb : std_logic := '0';
	signal spi_fin : std_logic := '0';
	signal rec_msg : std_logic_vector(7 downto 0); --message received over spi
	signal msg : std_logic_vector(7 downto 0); --message sent over spi

--	signal test : std_logic_vector(3 downto 0) := (others => '0'); --just used for testing delete
	
	--Hamming signals
	signal enc : std_logic_vector(5 downto 0);
	signal half_byte : std_logic := '0'; --which byte being using because they have to be inverted
	signal ham_check : std_logic := '0'; --wait for encode
	signal decode_check : std_logic := '0'; --wait for decode
	signal ham_check2 : std_logic := '0'; --has half byte been received
	signal dec_byte : std_logic_vector(3 downto 0); --store half byte decoded
	signal ham_delay : std_logic := '0';
	
	--Packets that have been sent and received count
	signal snd_cnt : std_logic_vector(2 downto 0) := (others => '0');
	signal re_count : std_logic_vector(2 downto 0) := (others => '0');

	--Count how many delays have occured
	signal delay_count : std_logic_vector(9 downto 0) := (others => '0');
	
	--message to which error should be added and the message that has had errors added
	signal err_msg_in : std_logic_vector(7 downto 0);
	signal err_msg_out : std_logic_vector(7 downto 0);
	
	signal current : std_logic_vector(11 downto 0);
	signal prev : std_logic_vector(3 downto 0);

begin

	re_cnt <= re_count(1 downto 0); --outputting the count to logic analyzer

	--module for sending/receiving information over spi
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
	
	--module to add errors to the message being sent
	u2 : erro_insertion port map (
		switches => error_switches,
		msg_in => err_msg_in,
		msg_out => err_msg_out
	);
	
	u3 : prog port map (
		rst => rst,
		slideSwitches => slideSwitches,
		prog_cnt => prog_cnt,
		values => current,
		prev =>  prev
	);	

	--transmission controller
	process(clk) begin
	
		if rst = '1' then
			prog_cnt <= (others => '0');
			controller <= processing;
			CE <= '0';

		
		elsif clk = '1' and clk'event then
		
			case controller is
			
				when waiting => --wait for a read or write command or continue write if already started
					SS <= '1'; --need to intiate slave select to 1
					source_rst <= '0'; --don't want to be reseting the position in the sink or source
					sink_rst <= '0';
					ham_check2 <= '0';
					decode_check <= '0';
					if IRQ = '0' then --this indicates that a message has been received by the radio
						if re_count = 0 then
							sink_rst <= '1';
						end if;
						prog_cnt <= "0001101011";--107 is the start of the receive program
						controller <= processing;
					elsif send = '1' or snd_cnt /= 0 then --this indicates that a message should be sent over the radio
						if(snd_cnt = 0) then --if this is the first message being sent reset the position in the source to ensure
							   source_rst <= '1'; --correct information is being sent
						end if;
						prog_cnt <= "0000101010";--42 is start of send program
						half_byte <= '0';
						controller <= processing;
					else
						controller <= waiting;
					end if;
				
				when processing => --check what the next command is and execute
					source_rst <= '0';
					sink_clock <= '0';
					sink_rst <= '0';
				
					case (current (11 downto 8)) is
						
						when x"0" => --write state
							msg <= current (7 downto 0); --make message ready to send
							spi_enb <= '1'; --start spi
							controller <= communicating;
							prog_cnt <= prog_cnt + 1;
							
						when x"2" => --SS = 1
							SS <= '1';
							prog_cnt <= prog_cnt + 1;
							
						when x"3" => --SS = 0
							SS <= '0';
							prog_cnt <= prog_cnt + 1;
							
						when x"4" => --CE = 1
							CE <= '1';
							prog_cnt <= prog_cnt + 1;
							
						when x"5" => --CE = 0
							CE <= '0';
							prog_cnt <= prog_cnt + 1;
							
						when x"6" => --Delay for 10 micro second
							delay_rst <= '1'; --reset delay count
							prog_cnt <= prog_cnt + 1;
							controller <= communicating;
							
						when x"7" => --Hamming Encode (packet not source)
							if half_byte = '0' then --need to inver the half bytes from what is stored
								enc <= "00" & current (3 downto 0);
								half_byte <= '1';
							else
								enc <= "00" & current (7 downto 4);
								half_byte <= '0';
								prog_cnt <= prog_cnt + 1;
							end if;
							controller <= hamming;
							
						when x"8" => --Hamming Encode info from source
							if (snd_cnt /= 4 or (snd_cnt = 4 and prog_cnt <= 64)) then --need to pad the last 6 values with 0's
								if ham_check = '0' then --need to inver the byte
									enc <= "00" & source_msg(7 downto 4);
									ham_check <= '1';
								else
									enc <= "00" & source_msg(3 downto 0);
									source_clock <= '1';
									ham_check <= '0';
								end if;
							
							else
								enc <= "000000"; --pad packet remainder with zeroes
							end if;
							controller <= hamming;
							prog_cnt <= prog_cnt + 1;
							
						when x"9" => --Hamming Decode and save to sink
							msg <= current (7 downto 0); --set message to all 1's
							spi_enb <= '1'; 
							controller <= communicating;
							prog_cnt <= prog_cnt + 1;
							
						when x"A" => --Finished sending packet
							if snd_cnt = 4 then --if finished sending return count to 0
								snd_cnt <= (others => '0');
								source_rst <= '1';
							else
								snd_cnt <= snd_cnt + 1; --increment send count
							end if;
							prog_cnt <= prog_cnt + 1;
							
						when x"B" => --delay 140 micro
							delay_count <= "0000001110"; --counts 10 micro second delays
							delay_rst <= '1';
							prog_cnt <= prog_cnt + 1;
							controller <= communicating;
							
						when x"C" => --delay 1ms
							delay_count <= "1111101000"; --counts 10 micro second delays
							delay_rst <= '1';
							prog_cnt <= prog_cnt + 1;
							controller <= communicating;
							
						when x"D" => --increase recieve count
							if re_count >= 4 then --if finished receiving 5 packets then reset count to 0
								re_count <= (others => '0');
								sink_rst <= '1';
							else
								re_count <= re_count + 1; --increment receive count
							end if;
							prog_cnt <= prog_cnt + 1;
					
						when x"F" => --Section End
							controller <= waiting; --go back to the initial state to wait for send or receive request
							
						when others => --Shouldn't be here revert to wait state
							controller <= waiting;
					
					end case;
					
				when communicating =>--wait for system to finish transmitting and delays to be complete
					delay_rst <= '0'; --start delay on 1 -> 0 toggle
					spi_enb <= '0'; --otherwise will continually send same message
					
					if(spi_fin = '1' and T_10micro = '1') then --system will wait until the delay is complete and transmission is complete
						if(delay_count = 0) then
							if prev = x"9" then --if the command was receive
								
								if re_count <= 3 or (re_count = 4 and prog_cnt <= 136) then --when receiving the last 6 values will be padded 0's so ignore
									enc <= hamming_decode84(rec_msg);
									controller <= decode;
								else --if in the section with padded zeros then skip
									controller <= processing;
								end if;			
							else --if not receiving then just continue processing
								controller <= processing;
							end if;
						else --if the delay isn't 0 then need to wait longer
							delay_count <= delay_count -1;
							delay_rst <= '1';
						end if;
					else
						controller <= communicating;
					end if;
					
				when hamming => --hamming encode message and set to send
					if ham_delay = '0' then --need to wait for error to be added
						ham_delay <= '1';
						err_msg_in <= hamming_encode84(enc(3 downto 0));
						source_clock <= '0';
						controller <= hamming;
					else --errors has been added now can send the message
						ham_delay <= '0'; 
						msg <= err_msg_out;
						spi_enb <= '1';
						controller <= communicating;
					end if;
					
				when decode => --hamming decode message and save to sink
					if ham_check2 = '0' then --getting first byte
						ham_check2 <= '1';
						dec_byte <= enc(3 downto 0);	
						controller <= processing;
					else --getting second byte
						--write
						--clock
						if decode_check = '0' then --wait for decode
							--sink_msg <= enc & dec_byte;
							sink_msg <= dec_byte & enc(3 downto 0);
							decode_check <= '1';
							controller <= decode;
						else --decode complete
							sink_clock <= '1';
							decode_check <= '0';
							ham_check2 <= '0';
							controller <= processing;
							statusLeds(0) <= not(enc(4) or enc(5)); --no errors
							statusLeds(1) <= enc(4) and not(enc(5)); --error
							statusLeds(2) <= enc(4) and enc(5); --error and parity
						end if;
					
					end if;
					
			end case;
			
		end if;
		
	end process;
	
end Behavioral;
