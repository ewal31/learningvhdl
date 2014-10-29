----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:36:47 09/06/2014 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
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
--USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values,
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is port(
	clk100mhz : in std_logic;
	JC : out std_logic_vector(7 downto 0);
	JD : out std_logic_vector(7 downto 0);
	ssegCathode : out std_logic_vector (7 downto 0);
	ssegAnode : out std_logic_vector(7 downto 0);
	slideSwitches : in std_logic_vector (1 downto 0);
	pushButtons : in std_logic_vector(0 downto 0));
end top_level;

architecture Behavioral of top_level is

	component FSMD port(
		bitin : in std_logic_vector(7 downto 0);
		bitready : in std_logic;
		reset : in std_logic;
		clk : in std_logic;
		divisor : in std_logic_vector(1 downto 0); -- 0 is 2, 1 is 4, 2 is 8, 3 is 16
		outbit : out std_logic_vector(7 downto 0));
	end component;
	
	component ssegDriver port (
		clk : in std_logic;
		rst : in std_logic;
		cathode_p : out std_logic_vector(7 downto 0);
		digit1_p : in std_logic_vector(3 downto 0);
		anode_p : out std_logic_vector(7 downto 0);
		digit2_p : in std_logic_vector(3 downto 0);
		digit3_p : in std_logic_vector(3 downto 0);
		digit4_p : in std_logic_vector(3 downto 0)
	);
	end component;

	--input data
	type dataarray is array (63 downto 0) of integer;
	signal data : dataarray;

	--clock divider for input bit (each average takes 3 ticks)
	signal counter : std_logic_vector(4 downto 0) := (others => '0');
	signal clk : std_logic;
	
	--position in data array
	signal inpbitpos : std_logic_vector(5 downto 0) := (others => '0');
	
	--data being input to the FSM
	signal input_bit : std_logic_vector(7 downto 0) := (others => '0');
	
	--tell the FSM that data is ready to be read
	signal bitready : std_logic;
	
	--reset the system using pushButton 0
	signal reseter : std_logic;
	
	--clk divider to slow the speed of the system
	signal clckdiv : std_logic_vector(23 downto 0);
	signal clkdiv : std_logic;
	
	--bits being recieved from the FSM
	signal outbits : std_logic_vector(7 downto 0);
	signal check : std_logic := '0';

begin

	--system clock divider 
	process (clk100mhz) begin
		if(clk100mhz'event and clk100mhz = '1') then
			clckdiv <= clckdiv + 1;
		end if;
	end process;
	clkdiv <= clckdiv(3);
	
	--Data to run through
	data <= (162,10,48,37,52,31,49,125,12,92,157,8,161,141,53,216,123,220,30,4,148,237,148,196,251,228,186,169,160,21,170,63,150,189,216,147,230,127,58,205,122,135,253,156,221,0,253,225,208,149,178,237,143,217,14,37,126,48,126,173,34,28,23,136);
	--(255, 255, 255, 255, 255, 255, 255, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255);
	--sine wave(99,43,8,1,25,74,136,195,239,255,242,201,142,80,30,3,6,38,92,155,211,247,255,232,184,123,63,18,0,13,53,111,173,225,253,251,220,166,104,47,10,1,22,69,131,191,236,255,244,205,147,85,33,4,4,35,87,150,207,245,255,235,189,128);
	--flat sections and rising(255, 255, 255, 255, 255, 255, 255, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255); 
	--(99,43,8,1,25,74,136,195,239,255,242,201,142,80,30,3,6,38,92,155,211,247,255,232,184,123,63,18,0,13,53,111,173,225,253,251,220,166,104,47,10,1,22,69,131,191,236,255,244,205,147,85,33,4,4,35,87,150,207,245,255,235,189,128);
	--(99,43,8,1,25,74,136,195,239,255,242,201,142,80,30,3,6,38,92,155,211,247,255,232,184,123,63,18,0,13,53,111,173,225,253,251,220,166,104,47,10,1,22,69,131,191,236,255,244,205,147,85,33,4,4,35,87,150,207,245,256,235,189,128);
	--(162,10,48,37,52,31,49,125,12,92,157,8,161,141,53,216,123,220,30,4,148,237,148,196,251,228,186,169,160,21,170,63,150,189,216,147,230,127,58,205,122,135,253,156,221,0,253,225,208,149,178,237,143,217,14,37,126,48,126,173,34,28,23,136);
	--(255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,30,4,148,237,148,196,251,228,186,169,160,21,170,63,150,189,216,147,230,127,58,205,122,135,253,156,221,0,253,225,208,149,178,237,143,217,14,37,126,48,126,173,34,28,23,136);
	--(162,10,48,37,52,31,49,125,12,92,157,8,161,141,53,216,123,220,30,4,148,237,148,196,251,228,186,169,160,21,170,63,150,189,216,147,230,127,58,205,122,135,253,156,221,0,253,225,208,149,178,237,143,217,14,37,126,48,126,173,34,28,23,136);

	--FSMD 
	u1 : FSMD port map(
		bitin => input_bit,
		bitready => bitready,
		reset => reseter,
		clk => clkdiv,
		divisor => slideSwitches, -- 1 is 4, 2 is 8, 3 is 16
		outbit => outbits);
		 
	--SSEG Used for testing
	u2 : ssegDriver port map (
		clk => clckdiv(11),
		rst => '0',
		cathode_p => ssegCathode,
      digit1_p => input_bit(3 downto 0),
      anode_p => ssegAnode,
      digit2_p => input_bit(7 downto 4), 
      digit3_p => outbits(3 downto 0),
      digit4_p => outbits(7 downto 4)
	);

	--divider for data input
	process (clkdiv, pushButtons(0)) begin
		if(pushButtons(0) = '1') then
			reseter <= '1';
			input_bit <= "00000000";
			counter <= "00000";
			bitready <= '0';
			inpbitpos <= "000000";
			
		elsif(clkdiv'event and clkdiv = '0') then
			counter <= counter + 1;
			reseter <= '0';
			if (counter = 1) then
				bitready <= '0';
			elsif(counter = 16) then
				if(inpbitpos = 0 and check = '0') then
				
					reseter <= '1';
					input_bit <= "00000000";
					check <= '1';
				
				else
			
					counter <= "00000";
					input_bit <= conv_std_logic_vector(data(conv_integer(inpbitpos)), input_bit'length);
					bitready <= '1';
					inpbitpos <= inpbitpos + 1;
					check <= '0';
					
				end if;
			end if;
		end if;
	
	end process;

	JD <= input_bit;
	JC <= outbits;

end Behavioral;

