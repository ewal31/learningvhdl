----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:47 09/25/2014 
-- Design Name: 
-- Module Name:    clock_scaler - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_scaler is port (
	rst : in std_logic; --start 130 delay count
	clk : in std_logic; --main clock in
	clkscaled : out std_logic; --scaled clock out
	clkscaled11 : out std_logic;
	T_10micro : out std_logic --goes high when 10 microseconds has passed
	);
end clock_scaler;

architecture Behavioral of clock_scaler is
	
	signal delay : std_logic_vector(9 downto 0) := "1111111111"; --for delays
	signal clkscaler : std_logic_vector(8 downto 0) := (others => '0'); --this is used to scale the clock signal
	
begin

	clkscaler <= clkscaler + 1 when clk = '1' and clk'event; --increment clock scaler
	
	--scaled signals
	clkscaled <= clkscaler(5);
	clkscaled11 <= clkscaler(8);
	
	--create 10 micro second delay
	delay <= delay + 1 when clk = '1' and clk'event and delay < "1111111111" else (others => '0') when rst = '1';
	T_10micro <= '1' when delay >= 1000 else '0';
	
end Behavioral;

