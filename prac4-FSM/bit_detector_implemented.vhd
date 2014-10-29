----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:39:29 08/22/2014 
-- Design Name: 
-- Module Name:    bit_detector_implemented - Behavioral 
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

entity bit_detector_implemented is
		Port(	clk100mhz : in std_logic;
				slideSwitches : in std_logic_vector (8 downto 0);
				pushButtons : in std_logic_vector (0 downto 0);
				logic_analyzer : out std_logic_vector (7 downto 0));
end bit_detector_implemented;

architecture Behavioral of bit_detector_implemented is

	component bit_detector port(
		clk : in  STD_LOGIC;
      reset : in  STD_LOGIC;
      inputX : in  STD_LOGIC;
		outputZ : out  STD_LOGIC;
		stateID : out STD_LOGIC_VECTOR (3 downto 0));
	end component;

	signal bit_stream : std_logic_vector (29 downto 0);
	signal shift : std_logic;
	
	--used to shift through slide switches
	signal counter : std_logic_vector (3 downto 0);
	
	signal clock_scaler : std_logic_vector (21 downto 0);
	signal mod_clock : std_logic;
	signal reset : std_logic;

begin

	--reduce clock frequency so can be seen by logic analyser
	clock_scaler <= (clock_scaler + 1) when clk100mhz'event and clk100mhz = '1';
	mod_clock <= clock_scaler(21);

	--run through register or not by turning on 9th switch
	shift <= slideSwitches(8);
	
	--Shift Register
	process(slideSwitches, mod_clock, shift, bit_stream, pushButtons(0)) begin
	
		if pushButtons(0) = '1' then
			counter <= "0000";
			bit_stream <= "101101101011010011011101100111";--test pattern
			reset <= '1';
		elsif mod_clock'event and mod_clock = '0' then
			if shift = '1' then
				reset <= '0';

				if counter < 8 then
					bit_stream <= slideSwitches(conv_integer(counter)) & bit_stream(29 downto 1);
					counter <= counter + 1;
				else
					bit_stream <= '0' & bit_stream(29 downto 1);
				end if;
			
			else
				counter <= "0000";
				bit_stream <= "101101101011010011011101100111";--test pattern
				reset <= '1';
			end if;
		end if;
	
	end process;
	
	--Bit Detector FSM
	u1 : bit_detector port map(
		clk => mod_clock,
      reset => reset,
      inputX => bit_stream(0),
		outputZ => logic_analyzer(3),
		stateID => logic_analyzer(7 downto 4));

	logic_analyzer(0) <= mod_clock;
	logic_analyzer(1) <= reset;
	logic_analyzer(2) <= bit_stream(0);


end Behavioral;

