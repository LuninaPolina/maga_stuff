library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.p.all;
   
entity test is end entity;

architecture rtl of test is
constant T : integer := 8; --number of tests
type tTests is array (0 to T - 1) of tInput; 
signal tests : tTests; --array containing all test cases
signal test : tInput;
signal cur_gt : integer := 0; --idx of current test to generate
signal cur_rt : integer := 0; --idx of current test to receive

--generator/receiver working shedule is defined by bit state 
--where 1 -- ready to generate/receive, 0 -- not ready
shared variable gen_state : std_logic;
shared variable rec_state : std_logic;

signal clk, in_tvalid, out_tready,in_tready, out_tvalid : std_logic;
signal in_tdata : tInput;
signal out_tdata : tVArr;
signal result, init_done : boolean;

procedure delay ( n : integer; signal clk : std_logic ) is begin
	for i in 1 to n loop
		wait until rising_edge(clk);
	end loop;
end delay;

procedure clear_input (signal in_tdata : inout tInput) is begin
	in_tdata.vecs <= (others => (others => 'X'));
	in_tdata.nums <= (others => (others => 'X'));
end clear_input;

procedure check_result ( in_tdata : in tInput; pipe_out : in tVarr; signal result : out boolean ) is
	 variable vecs : tVArr;
	 variable simple_out : tVArr;
	 variable nums : tNArr;
 begin
	result <= true;
	vecs := in_tdata.vecs;
	nums := in_tdata.nums;
	for i in 0 to M - 1 loop
		simple_out(i) := vecs(to_integer(unsigned(nums(i))));
	end loop;
	for i in 0 to M - 1 loop
		if simple_out(i) /= pipe_out(i) then result <= false; end if;
	end loop;
 end check_result;
	 
procedure gen_tests ( signal tests : inout tTests; rn_num : integer) is begin
	for i in 0 to T - 1 loop
		for j in 0 to M - 1 loop
			tests(i).vecs(j) <= std_logic_vector(to_unsigned((i + j) mod rn_num, N));
			tests(i).nums(j) <= std_logic_vector(to_unsigned((i + j + rn_num) mod M, logM));
		end loop;
	end loop;
end gen_tests;
  
begin
	DUT : entity work.reshuffle 
	generic map (N => N, M => M)
	port map
	(clk => clk, in_tvalid => in_tvalid, out_tdata => out_tdata, out_tvalid => out_tvalid, in_tready => in_tready, out_tready => out_tready, in_tdata => in_tdata);
	
	process is begin
		clk <= '1';
		wait for 4 ns;
		clk <= '0';
		wait for 4 ns;
	end process;

	process is begin --set generator state for the each takt
		gen_state := '0';
		delay(3, clk);
		gen_state := '1';
		delay(4, clk);
		gen_state := '0';
		delay(2, clk);
		gen_state := '1';
		delay(2, clk);
	end process;
	
	process is begin --set receiver state for the each takt
		rec_state := '0';
		delay(3, clk);
		rec_state := '1';
		delay(5, clk);
		rec_state := '0';
		delay(1, clk);
		rec_state := '1';
		delay(2, clk);
	end process;
	
	process is begin --generate array of test data
		gen_tests(tests, 5);
		delay(2, clk);
		init_done <= true;
		wait;
	end process;	
	
--GENERATOR 
--sends signal in_tvalid to pipe depending on the current stage
--sends test data into pipe when pipe is ready to recieve
	process (clk) is begin 
		if rising_edge(clk) and init_done then
			if cur_gt < T then --there are tests to run
				if gen_state = '0' then 
					in_tvalid <= '0';
					clear_input(in_tdata);
				else
					if in_tready = '1' then
						in_tvalid <= '1';
						in_tdata <= tests(cur_gt);
						cur_gt <= cur_gt + 1; --switch to next test;
					end if;
				end if;
			else --all tests are done
				in_tvalid <= '0';
				clear_input(in_tdata);
			end if;
		end if;
	end process;
		
--RECEIVER 
--sends signal out_tready to pipe depending on the current stage
--recieves ready results when pipe is ready to send
--then compares results with simple reshuffle implementation
	process (clk) is begin 
		if rising_edge(clk) and init_done then
			result <= false;
			if cur_rt < T then --there are tests to check
				out_tready <= rec_state;
				if out_tvalid = '1' then 
					check_result(tests(cur_rt), out_tdata, result);
					cur_rt <= cur_rt + 1; --switch to next test				
				end if;
			end if;
		end if;
	end process;
end rtl;