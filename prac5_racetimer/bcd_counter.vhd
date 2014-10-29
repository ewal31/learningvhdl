----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:01:31 08/31/2014 
-- Design Name: 
-- Module Name:    bcd_counter - Behavioral 
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity bcd_counter is
    port (
        reset: in STD_LOGIC;
        clk: in STD_LOGIC;
        count_enable: in STD_LOGIC;
        carry_out: out STD_LOGIC;
        digit_out: out STD_LOGIC_VECTOR (3 downto 0)
    );
end bcd_counter;

architecture bcd_counter_arch of bcd_counter is

	signal counter_value: STD_LOGIC_VECTOR (3 downto 0);
begin

--	process(clk, reset) begin
--		if reset = '1' then
--			counter_value <= "0000";
--		
--		elsif clk'event and clk = '1' then
--			counter_value <= counter_value + 1;
--		
--		end if;
--	end process;
--	
--	digit_out <= counter_value;



	process(clk, reset, counter_value, count_enable)
	begin
		if reset = '1' then
			counter_value <= "0000";
			carry_out <= '0';
			
		elsif clk'EVENT and clk = '1' then
		   if count_enable = '1' then 
				if counter_value < "1001" then
							
				-------------------------------
				--ENTER YOUR COUNTER LOGIC HERE
            -- remember that carry_out needs to be generated 
				-------------------------------		
				
				if(counter_value = 8) then
						carry_out <= '1';
				end if;
				 
					counter_value <= counter_value + 1;
								
				else 
--				-------------------------------
--				--ENTER YOUR COUNTER LOGIC HERE
--				-------------------------------			
					counter_value <= "0000";
					carry_out <= '0';

				
				end if;
		   else 
		     -- and here -- remember that carry_out needs to get a value here 
           -- otherwise the compiler will infer a latch (which yo do not want !!)  
			
				counter_value <= counter_value;
				
         end if ; 
					
		end if;
	end process;
	
	digit_out <= counter_value;

 end bcd_counter_arch;


