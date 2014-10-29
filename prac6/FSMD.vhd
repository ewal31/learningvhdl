----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:54:14 09/06/2014 
-- Design Name: 
-- Module Name:    FSMD - Behavioral 
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

entity FSMD is
	PORT ( bitin : in std_logic_vector(7 downto 0);
			 bitready : in std_logic;
			 reset : in std_logic;
			 clk : in std_logic;
			 divisor : in std_logic_vector(1 downto 0); -- 0 is 2, 1 is 4, 2 is 8, 3 is 16
			 outbit : out std_logic_vector(7 downto 0));
end FSMD;

architecture Behavioral of FSMD is

	type state_type is (input, addition, divide);
	signal state : state_type := input;
	
	type window is array (16 downto 0) of std_logic_vector(7 downto 0);
	signal data : window := (others => (others => '0'));
	
	signal sum : std_logic_vector(11 downto 0) := (others => '0');

begin



	process(reset, clk, state) begin
	
		if reset = '1' then
			data <= (others => (others => '0'));
			state <= input;
			outbit <= "00000000";
			sum <= "000000000000";
			
		elsif (clk'event and clk = '1') then
		
			case state is
			
				when input => -- shift array and get next value
					if (bitready = '1') then
						data <= data(15 downto 0) & bitin; --add new value to array
						state <= addition; --move to next state
					else
						state <= input;
					end if;
					
				when addition =>
					--subtract first added number
					if divisor = 1 then
						sum <= sum - data(4) + data(0);
					elsif divisor = 2 then
						sum <= sum - data(8) + data(0);
					elsif divisor = 3 then
						sum <= sum - data(16) + data(0);
					end if;
				
					--add new number and move to next state
					--sum <= sum + data(0);
					state <= divide;					 
				
				when divide =>
					--Divide by set amount
					if divisor = 1 then
						outbit <= sum(9 downto 2);
					elsif divisor = 2 then
						outbit <= sum(10 downto 3);
					elsif divisor = 3 then
						outbit <= sum(11 downto 4);
					end if;
					
					--move back to first state
					state <= input;
				
			end case;
			
		end if;
		
	end process;

end Behavioral;
