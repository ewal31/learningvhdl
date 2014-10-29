--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:17:33 09/14/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac7-accelerometer/bcd_display_test.vhd
-- Project Name:  prac7-accelerometer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bcd_display
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bcd_display_test IS
END bcd_display_test;
 
ARCHITECTURE behavior OF bcd_display_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bcd_display
    PORT(
         binin : IN  std_logic_vector(7 downto 0);
         bcdout : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal binin : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal bcdout : std_logic_vector(11 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bcd_display PORT MAP (
          binin => binin,
          bcdout => bcdout
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

		binin <= "00001111";

      --wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
