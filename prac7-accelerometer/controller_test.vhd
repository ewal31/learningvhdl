--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:17:37 09/14/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/prac7-accelerometer/controller_test.vhd
-- Project Name:  prac7-accelerometer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller
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
 
ENTITY controller_test IS
END controller_test;
 
ARCHITECTURE behavior OF controller_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller
    PORT(
		rst : in std_logic; --reset FSM
		clk : in std_logic; --clock the FSM
		enable : in std_logic; --enable system operation
		CE : out std_logic; --clock enable
		MOSI : out std_logic; --data out line
		MISO : in std_logic; --data in line
		Clock : out std_logic; --clocking the accelerometer
		xout : out std_logic_vector(7 downto 0);
		yout : out std_logic_vector(7 downto 0);
		zout : out std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
	signal MISO : std_logic := '0';

 	--Outputs
   signal CE : std_logic;
   signal MOSI : std_logic;
	signal Clock : std_logic;
	signal xout : std_logic_vector(7 downto 0);
	signal yout : std_logic_vector(7 downto 0);
   signal zout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	signal readdata : std_logic_vector(7 downto 0);
	signal count : std_logic_vector(2 downto 0) := "111";
	signal pwrctrl : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          rst => rst,
          clk => clk,
          enable => enable,
          CE => CE,
          MOSI => MOSI,
			 MISO => MISO,
			 Clock => Clock,
			 xout => xout,
			 yout => yout,
			 zout => zout
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
	 
		rst <= '1';
	
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		rst <= '0';
		enable <= '1';
		
      wait;
   end process;
	
	process(Clock) 
	
	variable writing : std_logic := '0'; --got read command
	variable regrec : std_logic := '0'; --got register
	variable reading : std_logic := '0';
	variable senddata : std_logic_vector(23 downto 0) := "101010100011001111001100";
	-- so should result with xout = 10101010
	-- 							 yout = 00110011
	--                       zout = 11001100
	variable cnt : std_logic_vector(4 downto 0) := "00000";
	variable countlock : std_logic := '0';
	
	begin
	
		if CE = '1' then
			count <= "111";
			
		elsif Clock'event and Clock = '0' then
			if reading = '1' and regrec = '1' then --sending data;
				MISO <= 	senddata(conv_integer(unsigned(cnt)));
				
				if cnt = 0 then
					reading := '0';
					regrec := '0';
					countlock := '0';
				else
					cnt := cnt - 1;
				end if;
			end if;
			
	
		elsif Clock'event and Clock = '1' then
			
			readdata(conv_integer(unsigned(count))) <= MOSI;
			
			if count = 0 and countlock = '0' then
				count <= "111";
				
				if writing = '1' and regrec = '1' then
					if readdata(7 downto 1) = "0000101" and MOSI = '1' then
						pwrctrl <= readdata;
					else
						report "recieved wrong command" severity error;
					end if;
					writing := '0';
					regrec := '0'; 			
				
				elsif writing = '1' then --check for control register
					if readdata(7 downto 1) = "0010110" and MOSI = '1' then 
						regrec := '1';
					else
						report "writing to wrong register" severity error;
					end if;
					
				elsif reading = '1' then
					if readdata(7 downto 1) = "0000100" and MOSI = '0' then
						regrec := '1';
						countlock := '1';
						cnt := "10111";
					else
						report "reading from wrong register" severity error;
					end if;
						
				elsif readdata(7 downto 1) = "0000101" and MOSI = '0' then --now being written to
					writing := '1';
					
				elsif readdata(7 downto 1) = "0000101" and MOSI = '1' then
					reading := '1';
								
				end if;
				
			else
			
				count <= count - 1;
		
			end if;
		
		end if; 
	
	end process;

END;
