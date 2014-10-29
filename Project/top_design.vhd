----------------------------------------------------------------------------------
--Project Title : Simple Communication System
--Course : CSSE4010
--Date of Last Modification : 25/09/2014
--
--Brief Description
--This project can connect with and transmit and recieve information packets over
--a nRF24l01+ radio. The packets that are sent and recieved should be encoded
--using Hamming. All communication with the Radio is done using SPI. Message are
--recieved periodically and are constantly checked for after a short delay.
--The user can interface with the system using the pushbuttons on the board. This
--allows a message to be sent as well as change what is currently displayed on the
--7 SEG display.
--
--
--Project Updates
--Date : 25/09/2014
--Modification : The project top level has been created and a basic outline set up

--Date : 3/10/2014
--Modification : Have added the modules required for Milestone 1. This includes
	--Secded hamming encode and decode
	--A user interface and display for on board testing
	--A clock scaler module
	--A button debounce module
	--Added a source and sink to store messages
	--Added ability to add errors to encoded message
	
--Date : 16/10/2014
--Modification : Have written the code for the controller and program file
					--Ready to try testing the code soon
					--Think the radio should work
	
--Date : 17/10/2014
--Modification : Have Fixed the Clock Scaler and added delays allowing for transmission
					  --with radio
					--Have Fixed the Source as it was not display on the 7-seg properly
					
--Date : 18/10/2014
--Modification : Removed some of the extra signals and cleaned up the code a bit
               --Got the Display for the sink working correctly
					--Can now receive message from the radio correctly
					
--Date : 29/10/2014
--Modification : Added Status LED's for errors in the Hamming and Parity
					--Separated the program file to make the Rtl a little more friendly
					--just finalise some of the commenting
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

entity top_design is port (
	clk100mhz : in std_logic; --Main clock that drives the whole system
	pushButtons : in std_logic_vector(4 downto 0); --these are for the user interface
	MISO : in std_logic; --part of radio SPI
	slideSwitches : in std_logic_vector(10 downto 0); --used for adding errors to the hamming
	LEDs : out std_logic_vector(14 downto 0); --show display count
	ssegCathode : out std_logic_vector(7 downto 0); --used for the 7-SEG display
	ssegAnode : out std_logic_vector(7 downto 0); --used for the 7-SEG display
	logic_analyzer : out std_logic_vector(7 downto 0);
	CE : out std_logic; --Control the radios clock enable
	IRQ : in std_logic; --indicates that the radio is attempteding to activate an interrupt
	SCK : out std_logic; --SPI clock for the radio
	MOSI : out std_logic; --data out line for SPI
	CSN : out std_logic); --select line for the radio
end top_design;

architecture Behavioral of top_design is
 
--Used to show the message that is currently being sent or a recieved message
component ssegDriver port (
	clk : in std_logic;
	rst : in std_logic;
	cathode_p : out std_logic_vector(7 downto 0);
	digit1_p : in std_logic_vector(3 downto 0);
	anode_p : out std_logic_vector(7 downto 0);
	digit2_p : in std_logic_vector(3 downto 0);
	digit3_p : in std_logic_vector(3 downto 0);
	digit4_p : in std_logic_vector(3 downto 0);
	digit5_p : in std_logic_vector(3 downto 0);
	digit6_p : in std_logic_vector(3 downto 0);
	digit7_p : in std_logic_vector(3 downto 0);
	digit8_p : in std_logic_vector(3 downto 0)
	);
end component;

--Clock Scaler (also produces a 10micro second delay that can be used for transmitting)
	 component clock_scaler is port (
		rst : in std_logic; --start 130 delay count
		clk : in std_logic; --main clock in
		clkscaled : out std_logic; --scaled clock out
		clkscaled11 : out std_logic; --a longer scaled clock output
		T_10micro : out std_logic --10 microsecond delay
	 );
	 end component;

--Data Source (contains the information vector that will be sent over the radio)
component source is port (
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
end component;

--Debounce all 5 buttons for use with the other modules
component button_debounce port (
	clk : in std_logic; --clock
	pushButtons : in std_logic_vector(4 downto 0); --hardware buttons
	button : out std_logic_vector(4 downto 0) --debounced buttons
	);
end component;

--sink is used to store value array after decoded
component sink is port (
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
end component;

--Contains all the logic to send and receive with the radio
component radio_design port(
	clk : IN  std_logic; --clocks the module
	MISO : IN  std_logic; --MISO line used by SPI
	MOSI : OUT  std_logic; --MOSI line used by SPI
	SCK : OUT  std_logic; --SCK line used by SPI
	SS : OUT  std_logic; --SS line used by SPI
	CE : out std_logic; --help controll the radios mode
	IRQ : in std_logic; --radio IRQ pin (used to detect recieved message)
	error_switches : in std_logic_vector(7 downto 0); --used to add errors to the message being transmitted
	slideSwitches : IN  std_logic_vector(1 downto 0); --slideswitches used to control which channel to transmit on
	send : IN std_logic; --triggers the module to send message
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
end component;

--Systems signals
	signal clkscaler : std_logic; --Systems clock divider
	signal clkscaled11 : std_logic;
	signal T_10micro : std_logic := '0';
	signal delay_rst : std_logic := '0';

--SSEG signals - connected to the digit outputs
	signal digit1 : std_logic_vector(3 downto 0);
	signal digit2 : std_logic_vector(3 downto 0);
	signal digit3 : std_logic_vector(3 downto 0);
	signal digit4 : std_logic_vector(3 downto 0);
	signal digit5 : std_logic_vector(3 downto 0);
	signal digit6 : std_logic_vector(3 downto 0);
	signal digit7 : std_logic_vector(3 downto 0);
	signal digit8 : std_logic_vector(3 downto 0);

--source signals
	signal senb : std_logic := '0';
	signal smsg : std_logic_vector(7 downto 0) := (others => '0');
	signal source_clock : std_logic := '0';
	signal source_rst : std_logic := '0';
	
--debouncer signals
	signal button : std_logic_vector(4 downto 0) := (others => '0');
	
--sink signals
	signal sink_msg : std_logic_vector(7 downto 0) := (others => '0');	
	signal sink_clock : std_logic := '0';
	signal sink_rst : std_logic :='0';
	
--just for testing
	signal CEp : std_logic;
	signal IRQp : std_logic;
	signal SCKp : std_logic;
	signal MISOp : std_logic;
	signal MOSIp : std_logic;
	signal CSNp : std_logic;
	signal re_cnt : std_logic_vector(1 downto 0) := (others => '0');


begin

--System Clock Scaler
--Should be passed at varying degrees to lower levels so multiple clock scalers don't have to be
--set up wasting excess flip flops. This will have to have the largest clock scaler value
--required by the system.
	u1 : clock_scaler port map (
		rst => delay_rst,
		clk => clk100mhz,
		clkscaled => clkscaler,
		clkscaled11 => clkscaled11,
		T_10micro => T_10micro
	);
	
--sseg driver port map. This will have signals passed to it from the lower level
--send and recieve data arrays that are in the Data Source and Data Sink
	u2 : ssegDriver port map (
		clk => clkscaled11,
		rst => '0',
		cathode_p => ssegCathode,
		digit1_p => digit1,
		anode_p => ssegAnode,
		digit2_p => digit2, 
		digit3_p => digit3,
		digit4_p => digit4,
		digit5_p => digit5, 
		digit6_p => digit6,
		digit7_p => digit7,
		digit8_p => digit8
	);
	
--outputs a value that is encoded etc. The value is changed on enb toggle
	u3 : source port map (
		LEDs => LEDs(8 downto 3),
		btn => button(2),
		dig1 => digit1,
		dig2 => digit2,
		dig3 => digit3,
		dig4 => digit4,
		rst => source_rst,
		enb => source_clock,
		msg => smsg
	);
	
--debounces all the hardware buttons
	u4 : button_debounce port map (
		clk => clk100mhz,
		pushButtons => pushButtons,
		button => button
	);

--stores resultant decoded messages when the signal is decoded
	u6 : sink port map (
		LEDs => LEDs(14 downto 9),
		btn => button(3),
		dig1 => digit5,
		dig2 => digit6,
		dig3 => digit7,
		dig4 => digit8,
		rst => sink_rst,
		enb => sink_clock,
		msg_in => sink_msg
	);
	
--Contains all the logic require to send and receive message with another radio
--This contains 2 other modules that are used
          --Error Inserter
			 --Spi_read_write
	u7: radio_design port map (
		 clk => clkscaler,
		 MISO => MISO,
		 MOSI => MOSIp,
		 SCK => SCKp,
		 SS => CSNp,
		 CE => CEp,
		 IRQ => IRQ,
		 error_switches => slideSwitches(7 downto 0),
		 slideSwitches => slideSwitches(10 downto 9),
		 send => button(1),
		 rst => button(0),
		 source_clock => source_clock,
		 source_msg => smsg,
		 delay_rst => delay_rst,
		 T_10micro => T_10micro,
		 sink_clock => sink_clock,
		 sink_msg => sink_msg,
		 source_rst => source_rst,
		 sink_rst => sink_rst,
		 re_cnt => re_cnt,
		 statusLeds => LEDs(2 downto 0)
	  );
	  
	  --Just assigns the test signals used with the logic analyzer
	  CE <= CEp;
	  SCK <= SCKp;
	  IRQp <= IRQ;
	  MISOp <= MISO;
	  MOSI <= MOSIp;
	  CSN <= CSNp;
	  
	  logic_analyzer(0) <= CSNp;
	  logic_analyzer(1) <= SCKp;
	  logic_analyzer(2) <= MOSIp;
	  logic_analyzer(3) <= MISOp;
	  logic_analyzer(4) <= CEp;
	  logic_analyzer(5) <= IRQp;
	  logic_analyzer(6) <= re_cnt(0);
	  logic_analyzer(7) <= re_cnt(1);
	
end Behavioral;

