library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_uc_tb is
end;

architecture a_pc_uc_tb of pc_uc_tb is
    component pc_uc is
        port(    clk      : in std_logic;
                 rst      : in std_logic;
                 wr_en    : in std_logic
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, reset  : std_logic;

begin
	uut: pc_uc port map (
		clk => clk,
		rst => reset,
		wr_en => '1'
	);

	reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;
    
	sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULA��O!!!
        finished <= '1';
        wait;
    end process sim_time_proc;
	
	clk_proc: process
    begin                       -- gera clock at� que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
	
	process
	begin
		wait for 200 ns;
		wait;
	end process;
end architecture a_pc_uc_tb;