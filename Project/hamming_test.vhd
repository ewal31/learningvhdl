--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:18:35 10/01/2014
-- Design Name:   
-- Module Name:   D:/Dropbox/Year 3/CSSE4010 Pracs/project - milestone 1/hamming_test.vhd
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hamming_encoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.simple_functions.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY hamming_test IS
END hamming_test;
 
ARCHITECTURE behavior OF hamming_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
--    COMPONENT hamming_encoder
--    PORT(
--         rst : IN  std_logic;
--         clk : IN  std_logic;
--         msg : IN  std_logic_vector(3 downto 0);
--         enb : IN  std_logic;
--         coded : OUT  std_logic_vector(6 downto 0)
--        );
--    END COMPONENT;
--	 
--	 component hamming_decoder 
--	 port(
--		   rst : in std_logic;
--		   clk : in std_logic;
--		   msg : in std_logic_vector(6 downto 0);
--	      enb : in std_logic;
--	      decoded : out std_logic_vector(3 downto 0)
--		  );
--	 end component;
--	 
--	 component error_inserter 
--	 port (
--			msg_in : in std_logic_vector(6 downto 0);
--			msg_out : out std_logic_vector(6 downto 0);
--			clk : in std_logic;
--			enb : in std_logic
--			);
--	 end component;
    

   --Inputs
--   signal rst : std_logic := '0';
--   signal clk : std_logic := '0';
--   signal msg : std_logic_vector(3 downto 0) := (others => '0');
--   signal enb : std_logic := '0';
--	signal msg2 : std_logic_vector(6 downto 0) := (others => '0');
--	signal enb2 : std_logic := '0';
--	signal decoded : std_logic_vector(3 downto 0) := (others => '0');
--
-- 	--Outputs
--   signal coded : std_logic_vector(6 downto 0);
--	
--	signal msg_in : std_logic_vector(6 downto 0);
--	signal msg_out : std_logic_vector(6 downto 0);
--	signal err_clock : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	signal bitin : std_logic_vector(3 downto 0) := x"F";
	signal enc : std_logic_vector(7 downto 0);
	signal error : std_logic_vector(7 downto 0);
	signal dec : std_logic_vector(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
--   uut: hamming_encoder PORT MAP (
--          rst => rst,
--          clk => clk,
--          msg => msg,
--          enb => enb,
--          coded => coded
--        );
--		  
--	uut1: hamming_decoder PORT MAP (
--			 rst => rst,
--			 clk => clk,
--			 msg => msg2,
--			 enb => enb2,
--			 decoded => decoded
--		  );
--		  
--	uut2 : error_inserter PORT MAP (
--			 msg_in => msg_in,
--			 msg_out => msg_out,
--			 clk => err_clock,
--			 enb => '1'
--		  );
			 

   -- Clock process definitions
--   clk_process :process
--   begin
--		clk <= '0';
--		wait for clk_period/2;
--		clk <= '1';
--		wait for clk_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	
		wait for clk_period;
		
		enc <= hamming_encode84(bitin);
		wait for clk_period;
		error <= enc xor "00000001";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "00000010";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "00000100";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "00001000";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "00010000";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "00100000";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "01000000";
		wait for clk_period;
		dec <= hamming_decode84(error);
		wait for clk_period;
		error <= enc xor "10000000";
		wait for clk_period;
		dec <= hamming_decode84(error);
		

      wait;
   end process;

END;





------------------------------------------------------------------------------------------------------
      -- hold reset state for 100 ns.
--		rst <= '1';
--		
--      wait for 100 ns;	
--		
--		rst <= '0';
--
--      wait for clk_period*10;
--		
--		for i in 0 to 20 loop
--
--			--hamming encode/decode test with errors---------------------------------------------
--
--			--input message bits and enable processing
--			msg <= "0000"; --input message
--			enb <= '1'; --enable encode
--			wait for clk_period; --remove enable after clocked in
--			enb <= '0'; 
--			wait for clk_period*2;
--			assert (coded = "0000000") report "0000" severity error; --assert correct encode
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			err_clock <= '1';
--			
--			msg <= "0001";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1100001") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0000") report "d0000" severity error;
--			err_clock <= '1';
--			
--			msg <= "0010";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1010010") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0001") report "d0001" severity error;
--			err_clock <= '1';
--			
--			msg <= "0011";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0110011") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0010") report "d0010" severity error;
--			err_clock <= '1';
--			
--			msg <= "0100";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0110100") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0011") report "d0011" severity error;
--			err_clock <= '1';
--			
--			msg <= "0101";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1010101") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0100") report "d0100" severity error;
--			err_clock <= '1';
--			
--			msg <= "0110";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1100110") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0101") report "d0101" severity error;
--			err_clock <= '1';
--			
--			msg <= "0111";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0000111") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0110") report "d0110" severity error;
--			err_clock <= '1';
--			
--			msg <= "1000";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1111000") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "0111") report "d0111" severity error;
--			err_clock <= '1';
--			
--			msg <= "1001";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0011001") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1000") report "d1000" severity error;
--			err_clock <= '1';
--			
--			msg <= "1010";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0101010") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1001") report "d1001" severity error;
--			err_clock <= '1';
--			
--			msg <= "1011";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1001011") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1010") report "d1010" severity error;
--			err_clock <= '1';
--			
--			msg <= "1100";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1001100") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1011") report "d1011" severity error;
--			err_clock <= '1';
--			
--			msg <= "1101";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0101101") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1100") report "d1100" severity error;
--			err_clock <= '1';
--			
--			msg <= "1110";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "0011110") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1101") report "d1101" severity error;
--			err_clock <= '1';
--			
--			msg <= "1111";
--			enb <= '1';
--			wait for clk_period;
--			enb <= '0';
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (coded = "1111111") report "0001" severity error;
--			--add error to coded output
--			msg_in <= coded;
--			wait for clk_period;
--			--insert coded message to decoder
--			msg2 <= msg_out;
--			enb2 <= '1';
--			assert (decoded = "1110") report "d1110" severity error;
--			err_clock <= '1';
--			
--			wait for clk_period;
--			enb2 <= '0';
--			err_clock <= '0';
--			wait for clk_period*2;
--			assert (decoded = "1111") report "d1111" severity error;	
--
--			wait for clk_period*3;
--			
--			------------------------------------------------------------------
--			
--		end loop;




--		--hamming encode/decode test without errors---------------------------------------------
--
--      --input message bits and enable processing
--		msg <= "0000";
--		enb <= '1';
--		wait for clk_period; --remove enable after clocked in
--		enb <= '0';
--		wait for clk_period*2;
--		assert (coded = "0000000") report "0000" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		
--		msg <= "0001";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1100001") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0000") report "d0000" severity error;
--		
--		msg <= "0010";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1010010") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0001") report "d0001" severity error;
--		
--		msg <= "0011";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0110011") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0010") report "d0010" severity error;
--		
--		msg <= "0100";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0110100") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0011") report "d0011" severity error;
--		
--		msg <= "0101";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1010101") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0100") report "d0100" severity error;
--		
--		msg <= "0110";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1100110") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0101") report "d0101" severity error;
--		
--		msg <= "0111";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0000111") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0110") report "d0110" severity error;
--		
--		msg <= "1000";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1111000") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "0111") report "d0111" severity error;
--		
--		msg <= "1001";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0011001") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1000") report "d1000" severity error;
--		
--		msg <= "1010";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0101010") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1001") report "d1001" severity error;
--		
--		msg <= "1011";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1001011") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1010") report "d1010" severity error;
--		
--		msg <= "1100";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1001100") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1011") report "d1011" severity error;
--		
--		msg <= "1101";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0101101") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1100") report "d1100" severity error;
--		
--		msg <= "1110";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "0011110") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1101") report "d1101" severity error;
--		
--		msg <= "1111";
--		enb <= '1';
--		wait for clk_period;
--		enb <= '0';
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (coded = "1111111") report "0001" severity error;
--		--insert coded message to decoder
--		msg2 <= coded;
--		enb2 <= '1';
--		assert (decoded = "1110") report "d1110" severity error;
--		
--		wait for clk_period;
--		enb2 <= '0';
--		wait for clk_period*2;
--		assert (decoded = "1111") report "d1111" severity error;		
--		
--		------------------------------------------------------------------
