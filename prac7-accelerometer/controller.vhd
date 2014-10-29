----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:04:55 09/14/2014 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

entity controller is port(
	rst : in std_logic; --reset FSM
	clk : in std_logic; --clock the FSM
	enable : in std_logic; --enable system operation
	CE : out std_logic; --clock enable
	MOSI : out std_logic; --data out line 
	MISO : in std_logic; --data in line
	Clock : out std_logic; --clocking the accelerometer
	xout : out std_logic_vector(11 downto 0);
	yout : out std_logic_vector(11 downto 0);
	zout : out std_logic_vector(11 downto 0)
	);
end controller;

architecture Behavioral of controller is

	type state_type is (start, CEenable, operation, complete); 
	signal state : state_type := start;
	
	signal wrtenable : std_logic := '0'; --can start writing data
	signal rdenable : std_logic := '0'; --start reading data
	signal transfercomplete : std_logic := '1'; --data transfer complete
	signal data : std_logic_vector(63 downto 0); --write command plus register and value
	signal clkenable : std_logic := '0';
	
	--read FSM
	type state_type1 is (start, reading);
	signal reader : state_type1 := start;
	
	--write FSM
	type state_type2 is (start, writing, nothing);
	signal writer : state_type2 := start;

begin

	process(rst, clk, state) 
	
		variable reader : std_logic := '0';
	
	begin
	
	
		if rst = '1' then
			state <= start;
			CE <= '1';
			reader := '0';
			wrtenable <= '0';
			rdenable <= '0';
		
		elsif(clk'event and clk = '1') then
		
			case state is
			
				when start => --need to trigger only once every 300ms or so
					if enable = '1' then
						state <= CEenable;
					else
						state <= start;
					end if;
						
				when CEenable => --need to take clock enable low and decide read or write
					CE <= '0';
					state <= operation;
					if reader = '0' then
						wrtenable <= '1';
						data(23 downto 0) <= "000010100010110100001010"; --data for initial write
						data(63 downto 24) <= (others => '0');
					else
						rdenable <= '1';
						data(63 downto 56) <= "00001011"; --read command 00001011
						data(55 downto 48) <= "00001110";--"00001000"; --register to read 00001000 (read 0x08 then read 9 and 10)
						data(47 downto 0) <= (others => '1');
					end if;
		
				when operation => --tell other fsm or datapath to start operation
					state <= complete;
					wrtenable <= '0';
					rdenable <= '0';
						
				when complete => --disable clock line
					if transfercomplete = '1' then
						CE <= '1';
						state <= start;
						reader := '1';
					else
						state <= complete;
					end if;

			end case;

		end if;
		
	end process;
	
	--write data path
	process(clk, rst) 
	
		variable cnt : std_logic_vector(5 downto 0) := (others => '0'); --count through send vector
		
		begin
		
		if rst = '1' then
			writer <= start;
			clkenable <= '0';
		
		elsif clk'event and clk = '0' then
		
			case writer is
			
				when start =>
					if wrtenable = '1' then
						cnt := "010111";
						MOSI <= data(conv_integer(unsigned(cnt)));
						transfercomplete <= '0';
						clkenable <= '1';
						writer <= writing;
					elsif rdenable = '1' then
						cnt := "111111";
						MOSI <= data(conv_integer(unsigned(cnt)));
						transfercomplete <= '0';
						clkenable <= '1';
						writer <= writing;
					else
						writer <= start;
						MOSI <= '0';
						clkenable <= '0';
					end if;
					
				when writing =>
					cnt := cnt - 1;
					MOSI <= data(conv_integer(unsigned(cnt)));
					if(cnt = 0) then
						writer <= nothing;
					else
						writer <= writing;
					end if;
					
				when nothing =>
					transfercomplete <= '1';
					clkenable <= '0';
					MOSI <= '0';
					writer <= start;
								
			end case;
		
		end if;
		
	end process;
	
	
	
	--read data path
	process(clk, rst)
	
		variable cnt : std_logic_vector(5 downto 0) := (others => '0');
		variable data : std_logic_vector(47 downto 0) := (others => '0');
		
	begin
	
		if rst = '1' then
			reader <= start;
		
		elsif clk'event and clk = '1' then
			
			case reader is
		
				when start =>
					if rdenable = '1' then
						cnt := "111111";
						reader <= reading;
					else
						reader <= start;
					end if;
					
				when reading =>
					cnt := cnt - 1;
					if cnt = 0 then
						data(0) := MISO;
						xout <= data(35 downto 32) & data(47 downto 40);
						yout <= data(19 downto 16) & data(31 downto 24);
						zout <= data(3 downto 0) & data(15 downto 8);
						reader <= start;
						
					elsif cnt < 48 then
						data(conv_integer(unsigned(cnt))) := MISO;
						reader <= reading;
					else
						reader <= reading;
					end if;
					
			end case;
						
		end if;
		
	end process;
	
	Clock <= '1' when clk = '1' and clkenable = '1' else '0'; --clock for acceleromter

end Behavioral;

