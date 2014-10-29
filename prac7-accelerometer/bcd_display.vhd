----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:53:21 09/14/2014 
-- Design Name: 
-- Module Name:    bcd_display - Behavioral 
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

entity bcd_display is port (
	binin : in std_logic_vector(11 downto 0);
	clk : in std_logic; --bout 17
	bcdout : out std_logic_vector(15 downto 0);
	sign : out std_logic;
	rst : in std_logic);
end bcd_display;

architecture Behavioral of bcd_display is

	signal ones : std_logic_vector(3 downto 0);
	signal tens : std_logic_vector(3 downto 0);
	signal hundreds : std_logic_vector(3 downto 0);
	signal thousands : std_logic_vector(3 downto 0);
	signal binary : std_logic_vector(11 downto 0);
	signal cnt : std_logic_vector(3 downto 0) := "0000";
	
	type state_type is (start, shift, check, finish);
	signal converter : state_type := start;

begin

	process(binin, clk, rst)
	
	begin
	
		if(clk'event and clk = '1') then
	
			case converter is 
			
				when start => --load in value
					if rst = '1' then
						binary <= "0" & binin(10 downto 0);
						sign <= binin(11);
						converter <= shift;
						ones <= (others => '0');
						tens <= (others => '0');
						hundreds <= (others => '0');
						thousands <= (others => '0');
						cnt <= "1010";	
					else
						converter <= start;
					end if;
					
				when shift => --shift values
					thousands <= thousands(2 downto 0) & hundreds(3);
					hundreds <= hundreds(2 downto 0) & tens(3);
					tens <= tens(2 downto 0) & ones(3);
					ones <= ones(2 downto 0) & binary(7);
					binary <= binary (10 downto 0) & '0';
					cnt <= cnt - 1;
					
					if (cnt /= 0) then
						converter <= check;
					else
						converter <= finish;
					end if;
					
				when check => --check greater than or equal to 5
					if ones >= 5 then
						ones <= ones + 3;
					end if;
			
					if tens >= 5 then
						tens <= tens + 3;
					end if;
			
					if hundreds >= 5 then 
						hundreds <= hundreds + 3;
					end if;
					
					if thousands >= 5 then
						thousands <= thousands + 3;
					end if;
					
					converter <= shift;
					
				when finish =>
					bcdout <= thousands & hundreds & tens & ones;
					converter <= start;
					
			end case;
			
		end if;
		
	end process;
	
end Behavioral;
