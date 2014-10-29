----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:09:57 08/31/2014 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

entity counter is
    port (
        reset: in STD_LOGIC;
        clk: in STD_LOGIC;
        count_enable: in STD_LOGIC;
        digit_out: out STD_LOGIC_VECTOR (7 downto 0)
    );
end counter;

architecture Behavioral of counter is

	component bcd_counter port (
		reset: in STD_LOGIC;
      clk: in STD_LOGIC;
      count_enable: in STD_LOGIC;
      carry_out: out STD_LOGIC;
      digit_out: out STD_LOGIC_VECTOR (3 downto 0));
	end component;

	signal carry : std_logic;
	signal overflow : std_logic;
	signal digit1 : std_logic_vector(3 downto 0);
	signal digit2 : std_logic_vector(3 downto 0);
	signal carry_check : std_logic;

begin

	u1: bcd_counter port map(
		reset => reset,
		clk => clk,
		count_enable => count_enable,
		carry_out => carry,
		digit_out => digit1);
		
	u2: bcd_counter port map(
		reset => reset,
		clk => clk,
		count_enable => carry_check,
		carry_out => overflow,
		digit_out => digit2);
		
	carry_check <= '1' when (count_enable = '1' and carry = '1') else '0';
	digit_out <= digit2 & digit1;
	--when overflow = '0' else "11111111" when clk'event and clk = '1';
	
end Behavioral;

