----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:34:04 10/01/2014 
-- Design Name: 
-- Module Name:    hamming_encoder - Behavioral 
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

entity hamming_encoder is port (
	rst : in std_logic;
	clk : in std_logic;
	msg : in std_logic_vector(3 downto 0);
	enb : in std_logic;
	coded : out std_logic_vector(6 downto 0)
	);
end hamming_encoder;

architecture Behavioral of hamming_encoder is

	type state_type is (get_bits, parity_calc, output_bits); --states for encoder
	signal encoder : state_type := get_bits; --encoder FSM

	signal bits : std_logic_vector(3 downto 0); --stored input bits
	signal parity : std_logic_vector(2 downto 0); --calculated parity bits that will be appended

begin

	process(clk, rst)
	
	begin
	
		if rst = '1' then --so system can put into defined state
			bits <= (others => '0');
			parity <= (others => '0');
--			coded <= (others => '0');
			encoder <= get_bits;
	
		elsif(clk'event and clk = '1') then
		
			case encoder is
			
				when get_bits => --load in value
					if enb = '1' then
						bits <= msg;
						encoder <= parity_calc; --move to parity calc state
					else
						encoder <= get_bits;
					end if;
				
				when parity_calc => --calculate parity bits
					parity(2) <= bits(3) xor bits(1) xor bits(0);
					parity(1) <= bits(3) xor bits(2) xor bits(0);
					parity(0) <= bits(3) xor bits(2) xor bits(1);
					encoder <= output_bits;
				
				when output_bits => --output coded value
					coded <= parity & bits; --parity bits are postfixed to the message
					encoder <= get_bits;
				
			end case;
		
		end if;
		
	end process;

end Behavioral;

