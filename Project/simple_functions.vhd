--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package simple_functions is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

	--Hamming 8,4 Encoder Function
	function hamming_encode84(msg : std_logic_vector) return std_logic_vector;
	
	--Hamming 8,4 Decoder Function
	function hamming_decode84(msg : std_logic_vector) return std_logic_vector;
	
--	function "/" (L: std_logic_vector; R: std_logic_vector) return std_logic_vector;

	--SPI Data Out
--	procedure spi_send (clk : in std_logic;
--							  data : in std_logic_vector;
--							  MOSI : out std_logic; --master out slave in
--							  SCK : out std_logic; --spi clock
--							  CE : out std_logic --clock enable
--							 );

end simple_functions;

package body simple_functions is

	--Hamming 8,4 Encoder Function
	function hamming_encode84(msg : std_logic_vector) return std_logic_vector is
		
			variable parity : std_logic_vector(3 downto 0);
		
		begin
		
			--rewritten as combinational logic
			parity(3) := msg(3) xor msg(1) xor msg(0);
			parity(2) := msg(3) xor msg(2) xor msg(0);
			parity(1) := msg(3) xor msg(2) xor msg(1);
			parity(0) := msg(2) xor msg(1) xor msg(0);
	
			return msg & parity;
			
	end hamming_encode84;
	
	--Hamming 8,4 Decode Function
	function hamming_decode84(msg : std_logic_vector) return std_logic_vector is
	
			variable syndrome : std_logic_vector(2 downto 0);
			variable result : std_logic_vector(5 downto 0);
		
		begin
	
			--calculate the syndrome matrix
			syndrome(2) := msg(1) xor msg(5) xor msg(6) xor msg(7);
			syndrome(1) := msg(2) xor msg(4) xor msg(6) xor msg(7);
			syndrome(0) := msg(3) xor msg(4) xor msg(5) xor msg(7);
			
			--correct the outputted message
--			result(6) := msg(6) xor (syndrome(2) and (not syndrome(1)) and (not syndrome(0)));
--			result(5) := msg(5) xor ((not syndrome(2)) and syndrome(1) and (not syndrome(0)));
--			result(4) := msg(4) xor ((not syndrome(2)) and (not syndrome(1)) and syndrome(0));

			result(5) := msg(0) xor msg(4) xor msg(5) xor msg(6); --indicates parity error
			result(4) := syndrome(2) or syndrome(1) or syndrome(0); --indicates error
			result(3) := msg(7) xor (syndrome(2) and syndrome(1) and syndrome(0));
			result(2) := msg(6) xor (syndrome(2) and syndrome(1) and (not syndrome(0)));
			result(1) := msg(5) xor (syndrome(2) and (not syndrome(1)) and syndrome(0));
			result(0) := msg(4) xor ((not syndrome(2)) and syndrome(1) and syndrome(0));
			
			return result;
			
	end hamming_decode84;
	
--	--just for dividing by multiples of 2 easily
--	function "/" (L: std_logic_vector; R: std_logic_vector) return std_logic_vector is
--	begin
--			return 
--	end;
	
--	procedure spi_send (clk : in std_logic;
--							  data : in std_logic_vector;
--							  MOSI : out std_logic; --master out slave in
--							  SCK : out std_logic; --spi clock
--							  CE : out std_logic --clock enable
--							 ) is
--							 
--			variable position : std_logic_vector
--							 
--		begin
--		
--	end procedure;


---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end simple_functions;
