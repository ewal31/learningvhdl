--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:24:40 08/16/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac3-BCD_adder/bcd_2_adder_test.vhd
-- Project Name:  prac3-BCD_adder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bcd_2_adder
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
 
ENTITY bcd_2_adder_test IS
END bcd_2_adder_test;
 
ARCHITECTURE behavior OF bcd_2_adder_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bcd_2_adder
    PORT(
         Carry_in : IN  std_logic;
         Carry_out : OUT  std_logic;
         Adig0 : IN  std_logic_vector(3 downto 0);
         Adig1 : IN  std_logic_vector(3 downto 0);
         Bdig0 : IN  std_logic_vector(3 downto 0);
         Bdig1 : IN  std_logic_vector(3 downto 0);
         Sdig0 : OUT  std_logic_vector(3 downto 0);
         Sdig1 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Carry_in : std_logic := '0';
	signal Adig : std_logic_vector (7 downto 0) := (others => '0');
	signal Bdig : std_logic_vector (7 downto 0) := (others => '0');

 	--Outputs
   signal Carry_out : std_logic;
	signal Sdig : std_logic_vector (7 downto 0);
	
	--test
	signal lower : std_logic_vector (4 downto 0) := (others => '0');
	signal upper : std_logic_vector (4 downto 0) := (others => '0');
	signal test : std_logic_vector (7 downto 0) := (others => '0');

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bcd_2_adder PORT MAP (
          Carry_in => Carry_in,
          Carry_out => Carry_out,
          Adig0 => Adig(3 downto 0),
          Adig1 => Adig(7 downto 4),
          Bdig0 => Bdig(3 downto 0),
          Bdig1 => Bdig(7 downto 4),
          Sdig0 => Sdig(3 downto 0),
          Sdig1 => Sdig(7 downto 4)
        );

   -- Stimulus process
   stim_proc: process
	
   begin		

		wait for 100ps;

		for I in 1 to 10 loop -- tens place B
			for J in 1 to 10 loop --units B
				for K in 1 to 10 loop -- tens A
					for L in 1 to 10 loop --units A
						for M in 1 to 2 loop
													
							wait for 10ps;
													
							---Check
--							if (('0' & Adig(3 downto 0)) + Bdig(3 downto 0) + Carry_in) <= "01001" then
--								lower <= ('0' & Adig(3 downto 0)) + ('0' & Bdig(3 downto 0)) + Carry_in;
--							else
--								lower <= ('0' & Adig(3 downto 0)) + ('0' & Bdig(3 downto 0)) + Carry_in + "00110";
--							end if;
--							
--							if (('0' & Adig(7 downto 4)) + Bdig(7 downto 4) + lower(4)) <= "01001" then
--								upper <= ('0' & Adig(7 downto 4)) + ('0' & Bdig(7 downto 4)) + lower(4);
--							else
--								upper <= ('0' & Adig(7 downto 4)) + ('0' & Bdig(7 downto 4)) + lower(4) + "00110";
--							end if;
--							
--							test <= upper(3 downto 0) & lower(3 downto 0);
--							
--							assert (Sdig(7 downto 0) = upper(3 downto 0)) report "Bad addition" severity ERROR;	
							
							---
							
							Carry_in <= '1';
					
						end loop;
						Carry_in <= '0';
						Adig <= Adig + 1;				
					
					end loop;
					Adig <= (Adig(7 downto 4) + 1) & "0000"; 
					
				end loop;
				Adig <= "00000000";
				Bdig <= Bdig + 1;
				
			end loop;
			Bdig <= (Bdig(7 downto 4) + 1) & "0000";
			
		end loop;

      wait;
   end process;

END;
