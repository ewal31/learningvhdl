--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:17:44 10/12/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/project - milestone 2/spi_read_write_test.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_read_write
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY spi_read_write_test IS
END spi_read_write_test;
 
ARCHITECTURE behavior OF spi_read_write_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_read_write
    PORT(
         clk : IN  std_logic;
         msg : IN  std_logic_vector(7 downto 0);
         rec_msg : OUT  std_logic_vector(7 downto 0);
         enb : IN  std_logic;
         MOSI : OUT  std_logic;
         MISO : IN  std_logic;
         SCK : OUT  std_logic;
			fin : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal msg : std_logic_vector(7 downto 0) := (others => '0');
   signal enb : std_logic := '0';
   signal MISO : std_logic := '0';

 	--Outputs
   signal rec_msg : std_logic_vector(7 downto 0) := (others => '0');
   signal MOSI : std_logic;
   signal SCK : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
	signal fin : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_read_write PORT MAP (
          clk => clk,
          msg => msg,
          rec_msg => rec_msg,
          enb => enb,
          MOSI => MOSI,
          MISO => MISO,
          SCK => SCK,
			 fin => fin
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
		
		msg <= "10101011";
		
		wait for clk_period;
		
		enb <= '1';
		
		wait for clk_period;
		
		enb <= '0';
		
		--input bits to test read
		MISO <= '1';
		wait for clk_period;
		MISO <= '0';
		wait for clk_period;
		MISO <= '1';
		wait for clk_period;
		MISO <= '0';
		wait for clk_period;
		MISO <= '1';
		wait for clk_period;
		MISO <= '0';
		wait for clk_period;
		MISO <= '1';
		wait for clk_period;
		MISO <= '1';
		wait for clk_period;
		MISO <= '0';

      wait;
   end process;

END;
