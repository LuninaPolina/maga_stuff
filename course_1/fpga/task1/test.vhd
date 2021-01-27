library ieee;
use ieee.std_logic_1164.all;

entity test is end entity;

architecture rtl of test is
signal x : std_logic_vector(4 downto 0);

begin
	DUT : entity work.sqrt port map (x => x);
	process is 
	begin
		x <= B"00000";
		wait for 1 ns;		
		x <= B"00010";
		wait for 1 ns;
		x <= B"00100";
		wait for 1 ns;
		x <= B"01111";
		wait for 1 ns; 
		x <= B"10000";
		wait for 1 ns;
		x <= B"11111";
		wait for 1 ns;	
	end process;
end rtl;	