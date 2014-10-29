--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:34:43 09/06/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac6/FSMD_test.vhd
-- Project Name:  prac6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FSMD
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
use IEEE.STD_LOGIC_ARITH.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY FSMD_test IS
END FSMD_test;
 
ARCHITECTURE behavior OF FSMD_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FSMD
    PORT(
         bitin : IN  std_logic_vector(7 downto 0);
         bitready : IN  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic;
         divisor : IN  std_logic_vector(1 downto 0);
         outbit : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal bitin : std_logic_vector(7 downto 0) := (others => '0');
   signal bitready : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal divisor : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal outbit : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSMD PORT MAP (
          bitin => bitin,
          bitready => bitready,
          reset => reset,
          clk => clk,
          divisor => divisor,
          outbit => outbit
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
      -- hold reset state for 100 ns.
      wait for clk_period*10;	

		reset <= '0';
		divisor <= "11";

      wait for clk_period*10;

		--3 clocks per average ??

		--put value in on 0
		wait for clk_period/2;
      bitin <= std_logic_vector(to_unsigned(136, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(23, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(28, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(34, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(173, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(126, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;

		bitin <= std_logic_vector(to_unsigned(48, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(126, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(37, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(14, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(217, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(143, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(237, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(178, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(149, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(208, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(225, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(253, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(0, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(221, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(156, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(253, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(135, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(122, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(205, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(58, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(127, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(230, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(147, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(216, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(189, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(150, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(63, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(170, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(21, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(160, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(169, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(186, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(228, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(251, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(196, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(148, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(237, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(148, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(4, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(30, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(220, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(123, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(216, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(53, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(141, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(161, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(8, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(157, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(92, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(12, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(125, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(49, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;

		bitin <= std_logic_vector(to_unsigned(31, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(52, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(37, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(48, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
		bitin <= std_logic_vector(to_unsigned(10, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;

		bitin <= std_logic_vector(to_unsigned(162, 8));
		bitready <= '1';
		wait for clk_period;
		bitready <= '0';
		wait for clk_period*2;
		
      wait;
   end process;

END;
