--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:01:05 10/16/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/project - milestone 2/butto_debounce_test.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: button_debounce
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
 
ENTITY butto_debounce_test IS
END butto_debounce_test;
 
ARCHITECTURE behavior OF butto_debounce_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT button_debounce
    PORT(
         clk : IN  std_logic;
         pushButtons : IN  std_logic_vector(4 downto 0);
         button : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal pushButtons : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal button : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: button_debounce PORT MAP (
          clk => clk,
          pushButtons => pushButtons,
          button => button
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		
		pushButtons(1) <= '1';
		
		wait for clk_period*10;
		
		pushButtons(1) <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
