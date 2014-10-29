--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:22:33 10/13/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/project - milestone 2/radio_communication_test.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: radio_communication
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
 
ENTITY radio_design_test IS
END radio_design_test;
 
ARCHITECTURE behavior OF radio_design_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component radio_design port(
         clk : IN  std_logic;
         MISO : IN  std_logic;
         MOSI : OUT  std_logic;
         SCK : OUT  std_logic;
         SS : OUT  std_logic;
			CE : out std_logic; --help controll the radios mode
			IRQ : in std_logic; --radio IRQ pin (used to detect recieved message)
         slideSwitches : IN  std_logic_vector(1 downto 0);
			send : IN std_logic;
			rst : in std_logic; --reset state machine and set up radio again with new slide switch arrangement
			source_clock : out std_logic; --clock to get next set of bits from source
			source_msg : in std_logic_vector(3 downto 0); --get message from source
			delay_rst : out std_logic; --reset delay clock
			delay_rst2 : out std_logic;
			T_10micro : in std_logic; --clocks at 10 micro seconds
			delay_130micro : in std_logic; --clocks after 130 microseconds
			sink_clock : out std_logic; --clock value into sink
			sink_msg : out std_logic_vector(3 downto 0) --msg clocked into sinc
        );
    end component;
	 
	 component source port (
		enb : in std_logic;
		msg : out std_logic_vector(3 downto 0)
	 );
	 end component;
	 
	 component clock_scaler is port (
		rst : in std_logic; --start 130 delay count
		rst1 : in std_logic;
		clk : in std_logic; --main clock in
		clkscaled : out std_logic; --scaled clock out
		clkscaled11 : out std_logic;
		T_10micro : out std_logic;
		delay_130micro : out std_logic
	 );
	 end component;
    
	 component sink is port (
		switch : in std_logic;
		rst : in std_logic;
		enb : in std_logic;
		msg_in : in std_logic_vector(3 downto 0);
		msg_out : out std_logic_vector(7 downto 0)
	 );
	 end component;

   --Inputs
   signal clk : std_logic := '0';
   signal MISO : std_logic := '0';
   signal slideSwitches : std_logic_vector(1 downto 0) := (others => '0');
	signal send : std_logic := '0';
	signal rst : std_logic := '0';
	signal source_msg : std_logic_vector(3 downto 0) := (others => '0');
	signal delay_rst : std_logic := '0';
	signal IRQ : std_logic := '1';
	signal sink_clock : std_logic := '0';
	signal sink_msg : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal MOSI : std_logic;
   signal SCK : std_logic;
   signal SS : std_logic;
	signal source_clock : std_logic;
	signal T_10micro : std_logic;
	signal delay_130micro : std_logic;
	signal CE : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	signal rand_msg : std_logic_vector(7 downto 0) := (others => '0');
	signal pos : std_logic_vector(2 downto 0) := (others => '0');
	
	signal delay_rst2 : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: radio_design PORT MAP (
          clk => clk,
          MISO => MISO,
          MOSI => MOSI,
          SCK => SCK,
          SS => SS,
			 CE => CE,
			 IRQ => IRQ,
          slideSwitches => slideSwitches,
			 send => send,
			 rst => rst,
			 source_clock => source_clock,
			 source_msg => source_msg,
			 delay_rst => delay_rst,
			 delay_rst2 => delay_rst2,
			 T_10micro => T_10micro,
			 delay_130micro => delay_130micro,
			 sink_clock => sink_clock,
			 sink_msg => sink_msg
        );
		  
	uut2: source port map (
			 enb => source_clock,
			 msg => source_msg
		  );
	
	uut3: clock_scaler port map (
			 rst => delay_rst,
			 rst1 => delay_rst2,
			 clk => clk,
			 T_10micro => T_10micro,
			 delay_130micro => delay_130micro
		  );
		  
	uut4: sink port map (
			 switch => '0',
			 rst => '0',
			 enb => sink_clock,
			 msg_in => sink_msg
		  );
		
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	--random recieve message generate
	process(clk)
	begin
		if clk = '1' and clk'event then
			rand_msg <= rand_msg + 1;
			pos <= pos + 3;
		end if;
	end process;
	
	MISO <= rand_msg(conv_integer(pos));


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		
		wait for 100 ns;
		
		send <= '1';
		
		wait for clk_period;
		
		send <= '0';
		
--		rst <= '1';
--		
--		wait for clk_period;
--		
--		rst <= '0';
--		
--		wait for 3 us;
--		
--		send <= '1';
--		
--		wait for clk_period;
--		
--		send <= '0';
--		
--		wait for 60 us;
		
--		IRQ <= '0';
--		
--		wait for 3 us;
--		
--		IRQ <= '1';
		
--		delay_rst <= '1';
--		wait for clk_period;
--		delay_rst <= '0';
		
		
--      wait for 100 ns;	
--
--      wait for clk_period*10;
--		
--		rst <= '1';
--		
--		wait for clk_period;
--		
--		rst <= '0';
--		
--		wait for 3000 ns;
--		
--		send <= '1';
--		
--		wait for clk_period;
--		
--		send <= '0'; 
--		
--		wait for 100000 ns;
--		
--		IRQ <= '0';
--		
--		wait for 26 us;
--		
--		IRQ <= '1';

      wait;
   end process;

END;
