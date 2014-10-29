--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:00:05 08/31/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac5_racetimer/bcd_counter_test.vhd
-- Project Name:  prac5_racetimer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bcd_counter
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
 
ENTITY bcd_counter_test IS
END bcd_counter_test;
 
ARCHITECTURE behavior OF bcd_counter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bcd_counter
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         count_enable : IN  std_logic;
         carry_out : OUT  std_logic;
         digit_out : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal count_enable : std_logic := '0';

 	--Outputs
   signal carry_out : std_logic;
   signal digit_out : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bcd_counter PORT MAP (
          reset => reset, 
          clk => clk,
          count_enable => count_enable,
          carry_out => carry_out,
          digit_out => digit_out
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
		reset <= '1';
      wait for 100 ns;	
		
		reset <= '0';
		count_enable <= '1';

      -- insert stimulus here 

      wait;
   end process;

END;
