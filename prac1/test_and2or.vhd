--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:26:29 08/05/2014
-- Design Name:   
-- Module Name:   C:/Users/Edward/Documents/projects/prac1/test_and2or.vhd
-- Project Name:  prac1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: and2or
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_and2or IS
END test_and2or;
 
ARCHITECTURE behavior OF test_and2or IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT and2or
    PORT(
         in1 : IN  std_logic;
         in2 : IN  std_logic;
         in3 : IN  std_logic;
         in4 : IN  std_logic;
         outandor : OUT  std_logic;
         outandor_flow : OUT  std_logic;
         outandor_beh : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
--   signal in1 : std_logic := '0';
--   signal in2 : std_logic := '0';
--   signal in3 : std_logic := '0';
--   signal in4 : std_logic := '0';
	signal inputs : std_logic_vector(3 downto 0) := "0000";

 	--Outputs
   signal outandor : std_logic;
   signal outandor_flow : std_logic;
   signal outandor_beh : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: and2or PORT MAP (
--          in1 => in1,
--          in2 => in2,
--          in3 => in3,
--          in4 => in4,
		    in1 => inputs(0),
			 in2 => inputs(1),
			 in3 => inputs(2),
			 in4 => inputs(3),
          outandor => outandor,
          outandor_flow => outandor_flow,
          outandor_beh => outandor_beh
        );
		  
		  input_gen : process
		  begin
		      inputs <= "0000";
				for I in 1 to 16 loop
				    wait for 100ps;
					 
							if (inputs = "0000") then
										assert (outandor = '0') report "0000 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "0000 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "0000 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "0001") then
										assert (outandor = '0') report "0001 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "0001 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "0001 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "0010") then
										assert (outandor = '0') report "0010 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "0010 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "0010 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "0011") then
										assert (outandor = '1') report "0011 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "0011 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "0011 bad gate - stuck at 0 : beh" severity error;
							elsif (inputs = "0100") then
										assert (outandor = '0') report "0100 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "0100 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "0100 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "0101") then
										assert (outandor = '0') report "0101 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "0101 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "0101 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "0110") then
										assert (outandor = '0') report "0110 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "0110 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "0110 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "0111") then
										assert (outandor = '1') report "0111 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "0111 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "0111 bad gate - stuck at 0 : beh" severity error;
							elsif (inputs = "1000") then
										assert (outandor = '0') report "1000 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "1000 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "1000 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "1001") then
										assert (outandor = '0') report "1001 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "1001 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "1001 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "1010") then
										assert (outandor = '0') report "1010 bad gate - stuck at 1" severity error;
										assert (outandor_flow = '0') report "1010 bad gate - stuck at 1 : flow" severity error;
										assert (outandor_beh = '0') report "1010 bad gate - stuck at 1 : beh" severity error;
							elsif (inputs = "1011") then
										assert (outandor = '1') report "1011 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "1011 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "1011 bad gate - stuck at 0 : beh" severity error;
							elsif (inputs = "1100") then
										assert (outandor = '1') report "1100 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "1100 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "1100 bad gate - stuck at 0 : beh" severity error;
							elsif (inputs = "1101") then
										assert (outandor = '1') report "1101 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "1101 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "1101 bad gate - stuck at 0 : beh" severity error;
							elsif (inputs = "1110") then
										assert (outandor = '1') report "1110 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "1110 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "1110 bad gate - stuck at 0 : beh" severity error;
							elsif (inputs = "1111") then
										assert (outandor = '1') report "1111 bad gate - stuck at 0" severity error;
										assert (outandor_flow = '1') report "1111 bad gate - stuck at 0 : flow" severity error;
										assert (outandor_beh = '1') report "1111 bad gate - stuck at 0 : beh" severity error;
							end if;

					 inputs <= inputs + '1';
				end loop;
				
				wait;
   	 end process;

END;
