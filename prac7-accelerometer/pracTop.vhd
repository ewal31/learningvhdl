----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:54 09/14/2014 
-- Design Name: 
-- Module Name:    pracTop - Behavioral 
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

entity pracTop is port(
	clk100mhz : in std_logic;
	pushButtons : in std_logic_vector(0 downto 0);
	MISOpin : in std_logic;
	slideSwitches : in std_logic_vector(2 downto 0);
	LEDs : in std_logic_vector(15 downto 0);
	ssegCathode : out std_logic_vector (7 downto 0);
	ssegAnode : out std_logic_vector(7 downto 0);
	logic_analyzer : out std_logic_vector(3 downto 0);
	SCK : out std_logic;
	MOSIpin : out std_logic;
	CS : out std_logic);
end pracTop;


architecture Behavioral of pracTop is

	component controller port(
		rst : in std_logic; --reset FSM
		clk : in std_logic; --clock the FSM
		enable : in std_logic; --enable  system operation
		CE : out std_logic; --clock enable
		MOSI : out std_logic; --data out line
		MISO : in std_logic; --data in line
		Clock : out std_logic; --clocking the accelerometer
		xout : out std_logic_vector(11 downto 0);
		yout : out std_logic_vector(11 downto 0);
		zout : out std_logic_vector(11 downto 0)
		);
	end component;

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
	
	component bcd_display is port (
		binin : in std_logic_vector(11 downto 0);
		clk : in std_logic; --bout 17
		bcdout : out std_logic_vector(15 downto 0);
		sign : out std_logic;
		rst : in std_logic);
	end component;


	signal xout : std_logic_vector(11 downto 0);
	signal yout : std_logic_vector(11 downto 0);
	signal zout : std_logic_vector(11 downto 0);
	--signal clkdiv : std_logic;
	signal clkscaler : std_logic_vector(6 downto 0);
	
	signal CE : std_logic := '0';
	signal MOSI : std_logic := '0';
	signal MISO : std_logic := '0';
	signal Clock : std_logic := '0';
	
	signal digit1 : std_logic_vector(3 downto 0);
	signal digit2 : std_logic_vector(3 downto 0);
	signal digit3 : std_logic_vector(3 downto 0);
	signal digit4 : std_logic_vector(3 downto 0);
	
	signal digin : std_logic_vector(11 downto 0);
	signal sign : std_logic;
	signal digit5 : std_logic_vector(3 downto 0);
	
begin

	process (clk100mhz) begin
	
		if clk100mhz = '1' and clk100mhz'event then
			clkscaler <= clkscaler + 1;
		end if;
	
	end process;	

	u1 : controller port map(
		rst => pushButtons(0),
		clk => clkscaler(6),
		enable => '1',
		CE => CE,
		MOSI => MOSI,
		MISO => MISO,
		Clock => Clock,
		xout => xout,
		yout => yout,
		zout => zout	
	);
	
	--SSEG Used for testing
	u2 : ssegDriver port map (
		clk => clkscaler(6),
		rst => '0',
		cathode_p => ssegCathode,
      digit1_p => digit1,
      anode_p => ssegAnode,
      digit2_p => digit2, 
      digit3_p => digit3,
		digit4_p => digit4,
		digit5_p => digit5, 
		digit6_p => "0000",
		digit7_p => "0000",
		digit8_p => "0000"
	);
	
	u3 : bcd_display port map (
		binin => digin,
		clk => clkscaler(2),
		bcdout(3 downto 0) => digit1,
		bcdout(7 downto 4) => digit2,
		bcdout(11 downto 8) => digit3,
		bcdout(15 downto 12) => digit4,
		sign => sign,
		rst => clkscaler(6)	
	);
	
	digin <= xout(11 downto 0) when slideSwitches(0) = '1' else
				yout(11 downto 0) when slideSwitches(1) = '1' else
				zout(11 downto 0) when slideSwitches(2) = '1' else
				"000000000000";

	--Assign to Logic Analyzer
	logic_analyzer(0) <= Clock;
	logic_analyzer(1) <= CE;
	logic_analyzer(2) <= MOSI;
	logic_analyzer(3) <= MISOpin;
	
	--Assign to acccelerometer
	SCK <= Clock;
	MOSIpin <= MOSI;
	MISO <= MISOpin;
	CS <= CE;

	digit5 <= "1111" when sign = '1' else 
				 "1110" when sign = '0';

end Behavioral;

