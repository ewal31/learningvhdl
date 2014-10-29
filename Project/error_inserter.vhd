----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:07:34 10/01/2014 
-- Design Name: 
-- Module Name:    error_inserter - Behavioral 
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

entity error_inserter is port (
	msg_in : in std_logic_vector(6 downto 0);
	msg_out : out std_logic_vector(6 downto 0);
	clk : in std_logic;
	enb : in std_logic
	);
end error_inserter;

architecture Behavioral of error_inserter is

	signal counter : std_logic_vector(6 downto 0) := "0000001"; --this has an initial 1 in the error position

begin

	process (clk) begin
		if clk = '1' and clk'event then
			counter <= counter(5 downto 0) & counter(6); --where the error is inserted is just rotated along register
		end if;
	end process;
	
	msg_out <= (msg_in xor counter) when (enb = '1') else msg_in; --xor with msg adding error
	
--	data(conv_integer(inpbitpos))
	
end Behavioral;

