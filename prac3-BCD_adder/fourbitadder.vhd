----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:05:11 08/21/2014 
-- Design Name: 
-- Module Name:    fourbitadder - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fourbitadder is
    port (
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        SUM: out STD_LOGIC_VECTOR (3 downto 0);
		  C_IN: in STD_LOGIC;
        C_OUT: out STD_LOGIC
    );
end fourbitadder;

architecture Behavioral of fourbitadder is

	component bitadder is
		Port ( A : in  STD_LOGIC;
             B : in  STD_LOGIC;
				 Cin : in STD_LOGIC;
             Cout : out  STD_LOGIC;
             S : out  STD_LOGIC);
	end component;
	
	signal A1 : std_logic;
	signal A2 : std_logic;
	signal A3 : std_logic;
	signal A4 : std_logic;
	signal B1 : std_logic;
	signal B2 : std_logic;
	signal B3 : std_logic;
	signal B4 : std_logic;
	signal S1 : std_logic;
	signal S2 : std_logic;
	signal S3 : std_logic;
	signal S4 : std_logic;
	signal C1 : std_logic;
	signal C2 : std_logic;
	signal C3 : std_logic;

begin

	u1 : bitadder port map ( 
		A => A1,
		B => B1,
		Cin => C_IN,
		Cout => C1,
		S => S1
	);

	u2 : bitadder port map ( 
		A => A2,
		B => B2,
		Cin => C1,
		Cout => C2,
		S => S2
	);
	
	u3 : bitadder port map ( 
		A => A3,
		B => B3,
		Cin => C2,
		Cout => C3,
		S => S3
	);
	
	u4 : bitadder port map ( 
		A => A4,
		B => B4,
		Cin => C3,
		Cout => C_OUT,
		S => S4
	);
	
	A1 <= A(0);
	A2 <= A(1);
	A3 <= A(2);
	A4 <= A(3);
	B1 <= B(0);
	B2 <= B(1);
	B3 <= B(2);
	B4 <= B(3);
	SUM <= S4 & S3 & S2 & S1;

end Behavioral;

