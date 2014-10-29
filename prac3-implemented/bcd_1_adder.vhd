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

	--signal Sout : std_logic_vector (4 downto 0);

begin

	--BCD adder logic
	process (A,B,C_IN)
	
	variable Sout : std_logic_vector(3 downto 0);
	variable Carry : std_logic;
	--variable Add_Out : std_logic_vector(1 downto 0);
	--variable A1 : std_logic_vector(1 downto 0);
	--variable B1 : std_logic_vector(1 downto 0);
	
	begin 
	
		Sout := A + B + C_IN;
		Carry := '0';

		if not(Sout <= 9 and (not (A > 5 and B > 5))) then
			Sout := Sout + 6;
			Carry := '1';
		end if;

		SUM <= Sout;
		C_OUT <= Carry;

	
--		Sout := ('0' & A & '1') + ('0' & B & C_IN);
--		
--		if Sout > 9 then
--			Sout := Sout + "01100";
--		end if;
--		
--		SUM <= Sout(4 downto 1);
--		C_OUT <= Sout(5);
	
	
		--Sout <= ('0' & A) + ('0' & B) + C_IN;

--		if (('0' & A) + ('0' & B) + C_IN) > 9 then
--			SUM <= A + B + C_IN + "0110";
--			C_OUT <= '1';
--		else
--			SUM <= A + B + C_IN;
--			C_OUT <= '0';
--		end if;
--		
--		SUM <= Sout(3 downto 0);
--		C_OUT <= Sout(4);
--	
--		if (('0' & A) + B + C_IN) <= "1001" then
--			SUM <= A + B + C_IN;
--			C_OUT <= '0';
--		else
--			SUM <= A + B + "0110" + C_IN;
--			C_OUT <= '1';
--		end if;

	end process;
	
end bcd_1_adder_arch;