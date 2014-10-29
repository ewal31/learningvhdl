----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:42:17 08/16/2014 
-- Design Name: 
-- Module Name:    bcd_adder - Behavioral 
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

entity bcd_adder is
	Port ( ssegAnode : out std_logic_vector (7 downto 0);
			 ssegCathode : out std_logic_vector (7 downto 0);
			 slideSwitches : in std_logic_vector (7 downto 0);
			 pushButtons : in std_logic_vector (1 downto 0);
			 clk100mhz : in std_logic;
			 logic_analyzer : out std_logic_vector (7 downto 0);
			 LEDs : out std_logic_vector (1 downto 0));
end bcd_adder;

architecture Behavioral of bcd_adder is

	component ssegDriver port( clk : in std_logic;
										rst : in std_logic;
										cathode_p : out std_logic_vector (7 downto 0);
										anode_p : out std_logic_vector (7 downto 0);
										digit1_p : in std_logic_vector (3 downto 0);
										digit2_p : in std_logic_vector (3 downto 0);
										digit3_p : in std_logic_vector (3 downto 0);
										digit4_p : in std_logic_vector (3 downto 0);
										digit5_p : in std_logic_vector (3 downto 0);
										digit6_p : in std_logic_vector (3 downto 0));
	end component;
	
	component bcd_1_adder port( A : in std_logic_vector (3 downto 0);
										 B : in std_logic_vector (3 downto 0);
										 C_IN : in std_logic;
										 SUM : out std_logic_vector (3 downto 0);
										 C_OUT : out std_logic);
	end component;
	
	signal masterReset : std_logic;
	signal clockScalers : std_logic_vector (11 downto 0);
	signal digit1 : std_logic_vector (3 downto 0);
	signal digit2 : std_logic_vector (3 downto 0);
	signal digit3 : std_logic_vector (3 downto 0);
	signal digit4 : std_logic_vector (3 downto 0);
	signal digit5 : std_logic_vector (3 downto 0);
	signal digit6 : std_logic_vector (3 downto 0);
	
	signal carry_in : std_logic;
	signal carry_out : std_logic;

begin

	masterReset <= pushButtons(1);
	
	--increments another clock at a slower speed for the 7-seg display
	process (clk100mhz, masterReset) begin
		if (masterReset = '1') then
			clockScalers <= "000000000000";
		elsif (clk100mhz'event and clk100mhz = '1')then
			clockScalers <= clockScalers + '1';
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
      digit4_p => digit4,
		digit5_p => digit5,
		digit6_p => digit6
	);
	
	u2 : bcd_1_adder port map (
		A => digit1,
		B => digit2,
		C_IN => carry_in,
		SUM => digit3,
		C_OUT => carry_out
	);

	digit1 <= slideSwitches(3 downto 0);
	digit2 <= slideSwitches(7 downto 4);
	carry_in <= pushButtons(0);
	digit4 <= "000" & carry_out;
	logic_analyzer <= digit4 & digit3;
	LEDs <= carry_out & carry_in;
	
	digit5 <= "1111" when (digit1 > 9) else "0000";
	digit6 <= "1111" when (digit2 > 9) else "0000";

end Behavioral;