----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:15:51 08/16/2014 
-- Design Name: 
-- Module Name:    bcd_1_adder - Behavioral 
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity bcd_1_adder is
    port (
        A: in STD_LOGIC_VECTOR (3 downto 0);
        B: in STD_LOGIC_VECTOR (3 downto 0);
        C_IN: in STD_LOGIC;
        SUM: out STD_LOGIC_VECTOR (3 downto 0);
        C_OUT: out STD_LOGIC
    );
end bcd_1_adder;

--algorithm 
-- If A + B <= 9 then -- assume both A and B are valid BCD numbers 
-- RESULT = A + B ; 
-- CARRY = 0 ; 
-- else 
-- RESULT = A + B + 6 ; 
-- CARRY = 1; 
-- end if ; 

architecture bcd_1_adder_arch of bcd_1_adder is

	component fourbitadder is
		port (
         A: in STD_LOGIC_VECTOR (3 downto 0);
         B: in STD_LOGIC_VECTOR (3 downto 0);
         SUM: out STD_LOGIC_VECTOR (3 downto 0);
			C_IN: in STD_LOGIC;
         C_OUT: out STD_LOGIC
      );
	end component;

	signal addition : std_logic_vector(3 downto 0);
	signal carry : std_logic;

begin

	u1 : fourbitadder port map ( 
		A => A,
		B => B,
		SUM => addition,
		C_IN => C_IN,
		C_OUT => carry
	);
	
	process(addition, carry) begin

		if (carry = '1') or ((addition(3) = '1') and ((addition(2) = '1') or (addition(1) = '1'))) then
			SUM <= addition + "0110";
			C_OUT <= '1';
		else
			SUM <= addition;
			C_OUT <= '0';
		end if;
		
	end process;






----------------------------------------------------------------------------------------------
	--BCD adder logic
	--process (A,B,C_IN)
	
	--variable Sout : std_logic_vector(4 downto 0);
	--variable Add_Out : std_logic_vector(1 downto 0);
	--variable A1 : std_logic_vector(1 downto 0);
	--variable B1 : std_logic_vector(1 downto 0);
	
	--begin 
	
--		Sout := ('0' & A) + B + C_IN;
--
--		if (Sout(4) = '1') or ((Sout(3) = '1') and ((Sout(1) = '1') or (Sout(2) = '1'))) then
--			Sout := Sout + "110";
--		end if;
--		
--		SUM <= Sout(3 downto 0);
--		C_OUT <= Sout(4);
	
--		if (('0' & A) + B + C_IN) <= "1001" then
--			SUM <= A + B + C_IN;
--			C_OUT <= '0';
--		else
--			SUM <= A + B + "0110" + C_IN;
--			C_OUT <= '1';
--		end if;

	--end process;
-------------------------------------------------------------------------------------------------
	
end bcd_1_adder_arch;