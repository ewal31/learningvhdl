----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:52 08/09/2014 
-- Design Name: 
-- Module Name:    Asynch_Comb_Lock - Behavioral 
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

entity Synch_Comb_Lock is
	PORT ( ssegAnode : out STD_LOGIC_VECTOR (7 downto 0);
			 ssegCathode : out STD_LOGIC_VECTOR (7 downto 0);
			 slideSwitches : in STD_LOGIC_VECTOR (7 downto 0);
			 pushButtons : in STD_LOGIC_VECTOR (3 downto 0);
			 LEDS : out STD_LOGIC_VECTOR (15 downto 0);
			 clk100mhz : in STD_LOGIC;
			 logic_analyzer : out STD_LOGIC_VECTOR (7 downto 0));
end Synch_Comb_Lock;

architecture Behavioral of Synch_Comb_Lock is

	component ssegDriver port( clk : in std_logic;
										rst : in std_logic;
										cathode_p : out std_logic_vector (7 downto 0);
										anode_p : out std_logic_vector (7 downto 0);
										digit1_p : in std_logic_vector (3 downto 0);
										digit2_p : in std_logic_vector (3 downto 0);
										digit3_p : in std_logic_vector (3 downto 0);
										digit4_p : in std_logic_vector (3 downto 0));
	end component;
	
	signal masterReset : std_logic;
	signal clockScalers : std_logic_vector (26 downto 0);
	signal digit1 : std_logic_vector (3 downto 0);
	signal digit2 : std_logic_vector (3 downto 0);
	signal digit3 : std_logic_vector (3 downto 0);
	signal digit4 : std_logic_vector (3 downto 0);
	signal logic_tmp : std_logic; --stores whether input 1 correct or not
	signal logic_tmp1 : std_logic; --stores whether input 2 correct or not
	signal unlocked : std_logic; --set to one if system unlocked

begin

	masterReset <= pushButtons(3);
	
	--increments another clock at a slower speed for the 7-seg display
	process (clk100mhz, masterReset) begin
		if (masterReset = '1') then
			clockScalers <= "000000000000000000000000000";
		elsif (clk100mhz'event and clk100mhz = '1')then
			clockScalers <= clockScalers + '1';
		end if;
	end process;	

	--Synchronous Combinational Lock
	process(clk100mhz) begin
		if(clk100mhz'event and clk100mhz = '1') then
		
			--check for all digits entered correctly
			if logic_tmp = '1' and logic_tmp1 = '1' then
				unlocked <= '1';
			else
				unlocked <= '0';
			end if;
		
			--check button 1 and correct two lower digits
			if pushButtons(0) = '1' then
				if slideSwitches(7 downto 0) = "10010010" then
					logic_tmp <= '1';
				else
					logic_tmp <= '0';
				end if;
					digit1 <= slideSwitches(3 downto 0);
					digit2 <= slideSwitches(7 downto 4);
			end if;
			
			--check button 2 and correct two upper digits
			if pushButtons(1) = '1' then
				if slideSwitches(7 downto 0) = "00100100" then
					logic_tmp1 <= '1';
				else
					logic_tmp1 <= '0';
				end if;
				digit3 <= slideSwitches(3 downto 0);
				digit4 <= slideSwitches(7 downto 4);
			end if;
			
			--check for reset button
			if pushButtons(2) = '1' then
				logic_tmp <= '0';
				logic_tmp1 <= '0';
				unlocked <= '0';
				digit1 <= "0000";
				digit2 <= "0000";
				digit3 <= "0000";
				digit4 <= "0000";
			end if;
			
		end if;
	end process;	
	
	--set up 7-seg driver
	u1 : ssegDriver port map (
		clk => clockScalers(11),
      rst => masterReset,
      cathode_p => ssegCathode,
      digit1_p => digit1,
      anode_p => ssegAnode,
      digit2_p => digit2, 
      digit3_p => digit3,
      digit4_p => digit4
	);
	
	LEDs(15 downto 1) <= "000000000000000";
	logic_analyzer <= digit4 & digit3;
	
	--assign unlock LED
	LEDs(0) <= unlocked;
	
end Behavioral;