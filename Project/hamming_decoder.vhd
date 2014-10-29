----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:53:02 10/01/2014 
-- Design Name: 
-- Module Name:    hamming_decoder - Behavioral 
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

entity hamming_decoder is port (
	rst : in std_logic;
	clk : in std_logic;
	msg : in std_logic_vector(6 downto 0);
	enb : in std_logic;
	decoded : out std_logic_vector(3 downto 0)
);
end hamming_decoder;

architecture Behavioral of hamming_decoder is

	type state_type is (get_bits, check_msg, output_bits); --states for decoder
	signal decoder : state_type := get_bits; --decoder FSM

	signal bits : std_logic_vector(6 downto 0); --input bits stored on enable
	signal syndrome : std_logic_vector(2 downto 0); --syndrome bits for error correction

begin

	process(clk, rst)
	
	begin
	
		if rst = '1' then --allows for initial reset so all signals defined
			bits <= (others => '0');
			syndrome <= (others => '0');
			decoder <= get_bits;
--			decoded <= (others => '0');
	
		elsif(clk'event and clk = '1') then
		
			case decoder is
			
				when get_bits => --load in value and move to next state
					if enb = '1' then
						bits <= msg;
						decoder <= check_msg;
					else
						decoder <= get_bits;
					end if;
				
				when check_msg => --calculate syndrome bits
					syndrome(2) <= bits(0) xor bits(1) xor bits(3) xor bits(6);
					syndrome(1) <= bits(0) xor bits(2) xor bits(3) xor bits(5);
					syndrome(0) <= bits(1) xor bits(2) xor bits(3) xor bits(4);
					decoder <= output_bits;
				
				when output_bits => --output corrected decoded value
					if syndrome = "110" then --check possible syndrome values
						decoded <= bits(3 downto 1) & (bits(0) xor '1'); --correct bit
					elsif syndrome = "101" then
						decoded <= bits(3 downto 2) & (bits(1) xor '1') & bits(0);
					elsif syndrome = "011" then
						decoded <= bits(3) & (bits(2) xor '1') & bits(1 downto 0);
					elsif syndrome = "111" then
						decoded <= (bits(3) xor '1') & bits(2 downto 0);
					else
						decoded <= bits(3 downto 0);
					end if;
					decoder <= get_bits;
				
			end case;
		
		end if;
		
	end process;

end Behavioral;

