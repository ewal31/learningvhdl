--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:38:58 08/21/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac4-FSM/bit_detector_test.vhd
-- Project Name:  prac4-FSM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bit_detector
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
 
ENTITY bit_detector_test IS
END bit_detector_test;
 
ARCHITECTURE behavior OF bit_detector_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bit_detector
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         inputX : IN  std_logic;
         outputZ : OUT  std_logic;
			stateID : out STD_LOGIC_VECTOR (3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal inputX : std_logic := '0';

 	--Outputs
   signal outputZ : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	signal bit_stream : std_logic_vector (27 downto 0) := "1011011010110100110111011001"; --"100110111011001011010";
	signal stateID : std_logic_vector (3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bit_detector PORT MAP (
          clk => clk,
          reset => reset,
          inputX => inputX,
          outputZ => outputZ,
			 stateID => stateID
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
	
		reset <= '1';

      wait for 100 ns;
		
		reset <= '0';
		
		for I in 0 to 27 loop
		
			inputX <= bit_stream(I);
			
			wait for clk_period;
			
		end loop;

      wait;
   end process;

END;
