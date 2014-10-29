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

entity hamming_decoder84 is port (
	rst : in std_logic;
	clk : in std_logic;
	msg : in std_logic_vector(7 downto 0);
	enb : in std_logic;
	decoded : out std_logic_vector(3 downto 0);
	syndrom_err : out std_logic;
	correct : out std_logic;
	parity : out std_logic
);
end hamming_decoder84;

architecture Behavioral of hamming_decoder84 is

--	type state_type is (get_bits, check_msg, output_bits); --states for decoder
--	signal decoder : state_type := get_bits; --decoder FSM

--	signal bits : std_logic_vector(7 downto 0); --input bits stored on enable
--	signal syndrome : std_logic_vector(2 downto 0); --syndrome bits for error correction
--	signal par : std_logic; --parity check 

	signal syndrome : std_logic_vector(2 downto 0);
	signal result : std_logic_vector(6 downto 0);
	signal par : std_logic;

begin

--	process(clk, rst)
	
--	variable data : std_logic_vector(7 downto 0) := (others => '0'); --store inputted data
--	variable par : std_logic := '0'; --calculate the parity

--	variable data : std_logic_vector(7 downto 0);
	
--	begin
	
		--calculate the syndrome matrix
		syndrome(2) <= msg(0) xor msg(1) xor msg(3) xor msg(6);
		syndrome(1) <= msg(0) xor msg(2) xor msg(3) xor msg(5);
		syndrome(0) <= msg(1) xor msg(2) xor msg(3) xor msg(4);
		
		--correct the outputted message
		result(6) <= msg(6) xor (syndrome(2) and (not syndrome(1)) and (not syndrome(0)));
		result(5) <= msg(5) xor ((not syndrome(2)) and syndrome(1) and (not syndrome(0)));
		result(4) <= msg(4) xor ((not syndrome(2)) and (not syndrome(1)) and syndrome(0));
		result(3) <= msg(3) xor (syndrome(2) and syndrome(1) and syndrome(0));
		result(2) <= msg(2) xor ((not syndrome(2)) and syndrome(1) and syndrome(0));
		result(1) <= msg(1) xor (syndrome(2) and (not syndrome(1)) and syndrome(0));
		result(0) <= msg(0) xor (syndrome(2) and syndrome(1) and (not syndrome(0)));
		
		par <= (result(6) xor result(5) xor result(4) xor result(3) xor result(2) xor result(1) xor result(0));
		
		decoded <= result(3 downto 0);
		
		--change led indicators
		parity <= '0' when msg(7) = par else '1';
		syndrom_err <= '1' when syndrome /= "000" else '0';
		correct <= '1' when msg(7) = par and syndrome = "000" else '0';
		



--		if rst = '1' then --allows for initial reset so all signals defined
--			data := (others => '0');
--			syndrome <= (others => '0');
--			decoder <= get_bits;
----			decoded <= (others => '0');
--	
--		elsif(clk'event and clk = '1') then
--		
--			case decoder is
--			
--				when get_bits => --load in value and calculate the syndrome
--					if enb = '1' then
--						data := msg;
--						syndrome(2) <= msg(0) xor msg(1) xor msg(3) xor msg(6);
--						syndrome(1) <= msg(0) xor msg(2) xor msg(3) xor msg(5);
--						syndrome(0) <= msg(1) xor msg(2) xor msg(3) xor msg(4);
--						decoder <= check_msg;
--					else
--						decoder <= get_bits;
--					end if;
--					
--				when check_msg => --check for non zero syndrome and correct.
--					if syndrome = "110" then --check possible syndrome values
--						data(0) := (data(0) xor '1');
----						data := data(7 downto 1) & (data(0) xor '1'); --correct bit
--					elsif syndrome = "101" then
--						data(1) := (data(1) xor '1');
----						data := data(7 downto 2) & (data(1) xor '1') & data(0);
--					elsif syndrome = "011" then
--						data(2) := (data(2) xor '1');
----						data := data(7 downto 3) & (data(2) xor '1') & data(1 downto 0);
--					elsif syndrome = "111" then
--						data(3) := (data(3) xor '1');
----						data := data(7 downto 4) & (data(3) xor '1') & data(2 downto 0);
--					elsif syndrome = "001" then
--						data(4) := (data(4) xor '1');
----						data := data(7 downto 5) & (data(4) xor '1') & data(3 downto 0);
--					elsif syndrome = "010" then
--						data(5) := (data(5) xor '1');
----						data := data(7 downto 6) & (data(5) xor '1') & data(4 downto 0);
--					elsif syndrome = "100" then
--						data(6) := (data(6) xor '1');
----						data := data(7) & (data(6) xor '1') & data(5 downto 0);
----					else
----						data := data;
--					end if;
--					
--					--do parity check after correction
--					par := (data(6) xor data(5) xor data(4) xor data(3) xor data(2) xor data(1) xor data(0));
--					decoder <= output_bits;
--					
--				when output_bits => --output corrected decoded value
--					decoded <= data(3 downto 0);
--					
--					--change led indicators
--					if data(7) = par then
--						parity <= '0';
--					else
--						parity <= '1';
--					end if;
--					if syndrome /= "000" then
--						syndrom_err <= '1';
--					else
--						syndrom_err <= '0';
--					end if;
--					if data(7) = par and syndrome = "000" then
--						correct <= '1';
--					else
--						correct <= '0';
--					end if;
--					decoder <= get_bits;
			
--				when get_bits => --load in value and move to next state
--					if enb = '1' then
--						bits <= msg;
--						decoder <= check_msg;
--					else
--						decoder <= get_bits;
--					end if;
--				
--				when check_msg => --calculate syndrome bits
--					par <= (bits(6) xor bits(5) xor bits(4) xor bits(3) xor bits(2) xor bits(1) xor bits(0)); 
--					syndrome(2) <= bits(0) xor bits(1) xor bits(3) xor bits(6);
--					syndrome(1) <= bits(0) xor bits(2) xor bits(3) xor bits(5);
--					syndrome(0) <= bits(1) xor bits(2) xor bits(3) xor bits(4);
--					decoder <= output_bits;
--				
--				when output_bits => --output corrected decoded value
--					if syndrome = "110" then --check possible syndrome values
--						decoded <= bits(3 downto 1) & (bits(0) xor '1'); --correct bit
--					elsif syndrome = "101" then
--						decoded <= bits(3 downto 2) & (bits(1) xor '1') & bits(0);
--					elsif syndrome = "011" then
--						decoded <= bits(3) & (bits(2) xor '1') & bits(1 downto 0);
--					elsif syndrome = "111" then
--						decoded <= (bits(3) xor '1') & bits(2 downto 0);
--					else
--						decoded <= bits(3 downto 0);
--					end if;
--					
--					if bits(7) = par then
--						parity <= '0';
--					else
--						parity <= '1';
--					end if;
--					decoder <= get_bits;
				
--			end case;
		
--		end if;
		
--	end process;

end Behavioral;

