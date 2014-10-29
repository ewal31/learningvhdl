----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:19:00 10/22/2014 
-- Design Name: 
-- Module Name:    erro_insertion - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity erro_insertion is port (
	switches : in std_logic_vector(7 downto 0); --choose what errors to insert
	msg_in : in std_logic_vector(7 downto 0); --message that will have errors inserted
	msg_out : out std_logic_vector(7 downto 0) --inputted message with errors
 );
end erro_insertion;

architecture Behavioral of erro_insertion is

begin

	msg_out <= msg_in xor switches; --input error into sent message (first 8 switches)


end Behavioral;

