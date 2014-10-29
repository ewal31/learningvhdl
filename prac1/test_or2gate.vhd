--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:33:30 08/05/2014
-- Design Name:   
-- Module Name:   C:/Users/Edward/Documents/projects/prac1/test_or2gate.vhd
-- Project Name:  prac1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: or2gate
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
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:20:40 08/05/2014
-- Design Name:   
-- Module Name:   C:/Users/Edward/Documents/projects/prac1/test_or2gate.vhd
-- Project Name:  prac1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: or2gate
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
 
ENTITY test_or2gate IS
END test_or2gate;

ARCHITECTURE behavior OF test_or2gate IS

    COMPONENT or2gate
        PORT(
            in1 : IN std_logic;
            in2 : IN std_logic;
            outOr : OUT std_logic
        );
    END COMPONENT;

    signal inputs : std_logic_vector(1 downto 0) := "00";
    signal outOr : std_logic;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: or2gate PORT MAP (
        in1 => inputs(0),
        in2 => inputs(1),
        outOr => outOr
    );

    input_gen : process
    begin
        inputs <= "00";
        --this loop will walk the truth table for the and gate
        for I in 1 to 4 loop
            wait for 100ps;
				
				if (inputs = "00") then
					assert (outOr = '0') report "bad gate - stuck at 1" severity error;
				elsif (inputs = "10") then
					assert (outOr = '1') report "bad gate - stuck at 1 " severity error;
				elsif (inputs = "01") then
					assert (outOr = '1') report "bad gate- stuck at 1" severity error;
				elsif (inputs = "11") then
					assert (outOr = '1') report "bad gate - stuck at 0" severity error ;
				end if;
				
            inputs <= inputs + '1';
        end loop;

        wait;
    end process;

END;
