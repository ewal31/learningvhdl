--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:22:00 08/16/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac3-BCD_adder/bcd_1_adder_test.vhd
-- Project Name:  prac3-BCD_adder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bcd_1_adder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bcd_1_adder_test IS
END bcd_1_adder_test;
 
ARCHITECTURE behavior OF bcd_1_adder_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bcd_1_adder
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         C_IN : IN  std_logic;
         SUM : OUT  std_logic_vector(3 downto 0);
         C_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');
   signal C_IN : std_logic := '0';

 	--Outputs
   signal SUM : std_logic_vector(3 downto 0);
   signal C_OUT : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bcd_1_adder PORT MAP (
          A => A,
          B => B,
          C_IN => C_IN,
          SUM => SUM,
          C_OUT => C_OUT
        );
 
   -- Stimulus process
   stim_proc: process
   begin		

		for I in 1 to 10 loop --iterate B
			for K in 1 to 10 loop --iterate A
				for T in 1 to 2 loop --iterate C_IN
				
					wait for 100ps;
					
					if (('0' & A) + B + C_IN) <= "1001" then
						assert ((C_OUT & SUM) = ('0' & (A + B + C_IN))) report "Bad addition (less than 10)" severity ERROR;
					else
						assert ((C_OUT & SUM) = ('1' & (A + B + "0110" + C_IN))) report "Bad addition (greater than 9)" severity ERROR;
					end if;
					
					C_IN <= '1';
					
				end loop;
				
				C_IN <= '0';				
				A <= A + '1';
				
			end loop;
			
			B <= B + '1';
			A <= "0000";
		
		end loop;
			
      wait;
   end process;

END;
