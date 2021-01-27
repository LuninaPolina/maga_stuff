library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity sqrt is port (
	x : in std_logic_vector(4 downto 0); 
	sqrtX : out std_logic_vector(4 downto 0)
	); 
end entity;

architecture rtl of sqrt is
type sqrtTable is array (0 to 31) of std_logic_vector(4 downto 0);
begin
	process (x) is 
	variable table : sqrtTable;
	variable xInt : integer;
	begin
	   --fill the table, where indexes are integers from 0 to 31
	   --and table(index) is the integer part of index sqrt in bit
		table(0) := B"00000";
		for I in 1 to 3 loop
			table(I) := B"00001"; 
		end loop;
		for I in 4 to 8 loop
			table(I) := B"00010";
		end loop;
		for I in 9 to 15 loop
			table(I) := B"00011";
		end loop;
		for I in 16 to 24 loop
			table(I) := B"00100";
		end loop;		
		for I in 25 to 31 loop
			table(I) := B"00101";
		end loop;
		xInt := conv_integer(unsigned(x));
		sqrtX <= table(xInt);
	end process;	
end rtl;	
