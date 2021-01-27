library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity test is end entity;

architecture rtl of test is
constant N : integer := 8;
signal clk, rst : std_logic;
signal inp_val : std_logic;
signal prd : unsigned(N - 1 downto 0);
signal conf : std_logic; 

procedure delay ( n : integer; signal clk : std_logic ) is
begin
	for i in 1 to n loop
		wait until clk'event and clk = '1';
	end loop;
end delay;

begin
	DUT : entity work.timer 
	generic map ( N => N )
	port map ( clk => clk, rst => rst, inp_val => inp_val, prd => prd, conf => conf );
	
	process is begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process;

	process is begin 
		rst <= '1';
		delay(10, clk);
		rst <= '0';
		wait;
	end process;
		
	process is begin
		delay(10, clk);
		
		--test one-time timer for 5 tacts
		prd <= conv_unsigned(5, N); 
		conf <= '0';
		inp_val <= '1';
		delay(1, clk);
		inp_val <= '0';
		delay(10, clk);
		
		--test periodic timer once in each 3 tacts
		prd <= conv_unsigned(3, N);
		conf <= '1';
		inp_val <= '1';
		delay(1, clk);
		inp_val <= '0';
      delay(30, clk);

		wait;
    end process;	
end rtl;	