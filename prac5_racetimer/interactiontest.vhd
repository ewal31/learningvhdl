--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:14:55 09/03/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac5_racetimer/interactiontest.vhd
-- Project Name:  prac5_racetimer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FSM
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
 
ENTITY interactiontest IS
END interactiontest;
 
ARCHITECTURE behavior OF interactiontest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FSM
    PORT(
         clk : IN  std_logic;
         button : IN  std_logic_vector(1 downto 0);
         count : OUT  std_logic;
         reseter : OUT  std_logic;
         firstplace : OUT  std_logic
        );
    END COMPONENT;
	 
	 COMPONENT counter
    port (
        reset: in STD_LOGIC;
        clk: in STD_LOGIC;
        count_enable: in STD_LOGIC;
        digit_out: out STD_LOGIC_VECTOR (7 downto 0)
    );
	 END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal button : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal count : std_logic;
   signal reseter : std_logic;
   signal firstplace : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	
	signal digit_out : std_logic_vector (7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSM PORT MAP (
          clk => clk,
          button => button,
          count => count,
          reseter => reseter,
          firstplace => firstplace
        );
		  
	uut1: counter PORT MAP (
			 reset => reseter,
			 clk => clk,
			 count_enable => count,
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

		button(0) <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		button(0) <= '0';

      wait for clk_period;

      button(1) <= '1'; 
		
		wait for clk_period;
		
		button(1) <= '0';
		
		wait for clk_period*20;
		
		button(1) <= '1';
		
		wait for clk_period;
		
		button(1) <= '0';
		
		wait for clk_period;
		
		button(1) <= '1';
		
		wait for clk_period;
		
		button(1) <= '0';
		
		wait for clk_period*10;
		
		button(0) <= '1';
		
		wait for clk_period;
		
		button(0) <= '0';

      wait;
   end process;

END;
