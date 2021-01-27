library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity timer is 
	generic ( N : integer := 8 ); --input width
	port (
		clk, rst : in std_logic;
		inp_val : in std_logic;
		prd : in unsigned(N - 1 downto 0); --call interrut once in prd tacts
		conf : in std_logic; --0 if one-time, 1 if periodic
		out_val : out std_logic;
		led : out std_logic --1 if interrupt, 0 otherwise
	);
end entity;

architecture rtl of timer is
signal cnt : unsigned(N - 1 downto 0); --counter that decreases during each period
signal global_cnt : unsigned(N - 1 downto 0); --stores the inintial value of cnt for periodic timers
begin
	process (clk, rst) is begin
		if clk'event and clk = '1' then
			if rst = '1' then 
				cnt <= conv_unsigned(0, N);
				global_cnt <= conv_unsigned(0, N);
				led <= '0';
				out_val <= '0';
			else
				if inp_val = '1' then --if new data is sent start counting takts
					cnt <= prd - conv_unsigned(1, N);
					if conf = '1' then  --save prd if periodic setup
						global_cnt <= prd; 
					else  
						global_cnt <= conv_unsigned(0, N);
					end if;
				end if;
				if cnt = conv_unsigned(1, N) then --period is done
					led <= '1';
					out_val <= '1';
					cnt <= global_cnt; --start next period if periodic setup
				elsif cnt /= 0 then --decrease cnt
					cnt <= cnt - conv_unsigned(1, N);
					out_val <= '0';
					led <= '0';
				else
					out_val <= '0';
					led <= '0';				
				end if;
			end if;
		end if;
	end process;	
end rtl;	