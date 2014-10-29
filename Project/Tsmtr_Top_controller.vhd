----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:49:42 09/25/2014 
-- Design Name: 
-- Module Name:    Tsmtr_Top_controller - Behavioral 
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

entity Tsmtr_Top_controller is port (
	clk : in std_logic; --FSM clock
	SNDMSG : in std_logic; --message is sent on button depress
	Data : out std_logic_vector --data that is being sent
	);
end Tsmtr_Top_controller;

architecture Behavioral of Tsmtr_Top_controller is

begin


end Behavioral;

