library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package p is
	 constant N : integer := 8;
	 constant M : integer := 16;
--pipe size depends on input size
	 constant PSZ : integer := M * N / 128 + 1;
	 constant logM : integer := integer(ceil(log2(real(M))));
	 type tVArr is array (0 to M - 1) of std_logic_vector (N - 1 downto 0);
	 type tNArr is array (0 to M - 1) of std_logic_vector (logM - 1 downto 0);
    type tInput is record
        vecs: tVArr;
        nums: tNArr;
    end record tInput;
	 type tNReg is array (0 to PSZ - 1) of tNArr;
	 type tVReg is array (0 to PSZ - 1) of tVArr;
end p;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.p.all;

entity reshuffle is 
	generic ( 
		N : integer := N; 
		M : integer := M
		);
	port (
		clk : in std_logic;
		in_tvalid : in std_logic;
		in_tdata : in tInput;
		in_tready : out std_logic;
		out_tvalid : out std_logic;
		out_tdata : out tVArr;
		out_tready : in std_logic
	);
end entity;

architecture rtl of reshuffle is begin
	process (clk, out_tready) is
		variable poz : integer;
		variable vecsr : tVReg;
		variable numsr : tNReg;
		variable outr : tVReg;
		variable flags : unsigned(0 to PSZ - 1);
	begin 
		in_tready <= out_tready;
		if rising_edge(clk) then 
			if out_tready = '1' then --reciever is ready => pipe can work
--shift registers
				vecsr := vecsr(0) & vecsr(0 to PSZ - 2);
				numsr := numsr(0) & numsr(0 to PSZ - 2);
				outr := outr(0) & outr(0 to PSZ - 2);
				flags := shift_right(flags, 1);
--clear 0th elements or write new data if exists
				if in_tvalid = '1' then --new data was sent
					vecsr(0) := in_tdata.vecs; 
					numsr(0) := in_tdata.nums;
					flags(0) := '1';
				else
					vecsr(0) := (others => (others => 'X'));
					numsr(0) := (others => (others => 'X'));
					flags(0) := '0';
				end if;
--process data: blocks work on data slices of size M / PSZ 
				for i in 0 to PSZ - 1 loop
					for j in i * M / PSZ to (i + 1) * M / PSZ - 1 loop
						poz := to_integer(unsigned(numsr(i)(j)));
						outr(i)(j) := vecsr(i)(poz);
					end loop;
				end loop;
--send result if ready			
				if flags(PSZ - 1) = '1' then 
					out_tvalid <= '1';
					out_tdata <= outr(PSZ - 1);
				else out_tvalid <= '0';
				end if;
			else out_tvalid <= '0';
			end if;
		end if;
	end process;	
end rtl;