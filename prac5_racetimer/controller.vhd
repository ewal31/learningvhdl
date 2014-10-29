----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:29:35 08/31/2014 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating 
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
	port( clk100mhz : in std_logic;
			pushButtons : in std_logic_vector (1 downto 0);
			ssegCathode : out std_logic_vector (7 downto 0);
			ssegAnode : out std_logic_vector(7 downto 0);
			logic_analyzer : out std_logic_vector(1 downto 0));
end controller;

architecture Behavioral of controller is

	component counter	port (
        reset: in STD_LOGIC;
        clk: in STD_LOGIC;
        count_enable: in STD_LOGIC;
        digit_out: out STD_LOGIC_VECTOR (7 downto 0)
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
		digit4_p : in std_logic_vector(3 downto 0)
	);
	end component;
	
	component FSM port (
		clk : in std_logic;
		button : in std_logic_vector (1 downto 0);
		count : out std_logic;
		reseter : out std_logic;
		firstplace : out std_logic
	);
	end component;

	signal digit1 : std_logic_vector(3 downto 0);
	signal digit2 : std_logic_vector(3 downto 0); 
	signal digit3 : std_logic_vector(3 downto 0);
	signal digit4 : std_logic_vector(3 downto 0);
	signal clk : std_logic;
	signal clk_scaler : std_logic_vector (26 downto 0);
	signal digit_store : std_logic_vector (7 downto 0);
	signal count : std_logic;
	signal reseter : std_logic;
	signal firstplace : std_logic;

begin

	u1 : ssegDriver port map (
		clk => clk_scaler(11),
		rst => '0',
		cathode_p => ssegCathode,
      digit1_p => digit1,
      anode_p => ssegAnode,
      digit2_p => digit2, 
      digit3_p => digit3,
      digit4_p => digit4
	);

	u2 : counter port map (
		reset => reseter,
		clk => clk,
		count_enable => count,
		digit_out => digit_store
	);
	
	u3 : FSM port map (
		clk => clk100mhz,
		button => pushButtons,
		count => count,
		reseter => reseter,
		firstplace => firstplace
	);
	
	--Clock divider 
	process (clk100mhz) begin
		
		if (clk100mhz'event and clk100mhz = '1') then
--			if clk_scaler = 99999999 then
--				clk <= '0';
--				clk_scaler <= "000000000000000000000000000";
--			elsif clk_scaler = 49999999 then
--				clk <= '1';
--				clk_scaler <= clk_scaler + 1;
--			else
--				clk_scaler <= clk_scaler + 1;
--			end if;

			if clk_scaler = 49999999 then
				clk <= not clk;
				clk_scaler <= "000000000000000000000000000";
			else
				clk_scaler <= clk_scaler + 1;
			end if;

		end if;
	end process;

	digit1 <= digit_store(3 downto 0) when firstplace = '0' else digit1;
	digit2 <= digit_store(7 downto 4) when firstplace = '0' else digit2;
	digit3 <= digit_store(3 downto 0);
	digit4 <= digit_store(7 downto 4);
	logic_analyzer(0) <= clk;
	logic_analyzer(1) <= clk_scaler(1);

end Behavioral;
