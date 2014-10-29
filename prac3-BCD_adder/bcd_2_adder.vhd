----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:39 08/16/2014 
-- Design Name: 
-- Module Name:    bcd_2_adder - Behavioral 
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

entity bcd_2_adder is
	port ( Carry_in : in std_logic;
			 Carry_out : out std_logic;
			 Adig0: in std_logic_vector (3 downto 0);
			 Adig1: in std_logic_vector (3 downto 0);
			 Bdig0: in std_logic_vector (3 downto 0);
			 Bdig1: in std_logic_vector (3 downto 0);
			 Sdig0: out std_logic_vector (3 downto 0);
			 Sdig1: out std_logic_vector (3 downto 0));
end bcd_2_adder;

architecture bcd_2_adder_arch of bcd_2_adder is

	component bcd_1_adder port ( A: in STD_LOGIC_VECTOR (3 downto 0);
										  B: in STD_LOGIC_VECTOR (3 downto 0);
										  C_IN: in STD_LOGIC;
										  SUM: out STD_LOGIC_VECTOR (3 downto 0);
										  C_OUT: out STD_LOGIC);
	end component;
	
	signal Adig0s: std_logic_vector (3 downto 0);
	signal Adig1s: std_logic_vector (3 downto 0);
	signal C_IN1: std_logic;
	signal C_OUT1: std_logic;
	signal Bdig0s: std_logic_vector (3 downto 0);
	signal Bdig1s: std_logic_vector (3 downto 0);
	signal C_OUT2: std_logic;
	signal Sdig0s: std_logic_vector (3 downto 0);
	signal Sdig1s: std_logic_vector (3 downto 0);
		
	begin
	
	Adig0s <= Adig0;
	Adig1s <= Adig1;
	Bdig0s <= Bdig0;
	Bdig1s <= Bdig1;
	C_IN1 <= Carry_in;
	
	Sdig0 <= Sdig0s;
	Sdig1 <= Sdig1s;
	Carry_out <= C_OUT2;
	
	u1 : bcd_1_adder port map ( 
		A => Adig0s,
		B => Bdig0s,
		C_IN => C_IN1,
		SUM => Sdig0s,
		C_OUT => C_OUT1
	);

	u2 : bcd_1_adder port map ( 
		A => Adig1s,
		B => Bdig1s,
		C_IN => C_OUT1,
		SUM => Sdig1s,
		C_OUT => C_OUT2
	);
	
end bcd_2_adder_arch;