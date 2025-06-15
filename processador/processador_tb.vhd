library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
    component processador is
        port(
            clk      : in std_logic;
            rst      : in std_logic;
            state    : out unsigned(1 downto 0);
            pc_out       : out unsigned(6 downto 0);
            instruction : out unsigned(16 downto 0);
            bank_reg_out : out unsigned(15 downto 0);
            accumulator_out : out unsigned(15 downto 0);
            ULA_out : out unsigned(15 downto 0)
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, reset  : std_logic;
    signal   state       : unsigned(1 downto 0);
    signal   pc_out          : unsigned(6 downto 0);
    signal   instruction : unsigned(16 downto 0);
    signal   bank_reg_out: unsigned(15 downto 0);
    signal   accumulator_out: unsigned(15 downto 0);
    signal   ULA_out: unsigned(15 downto 0);

begin
	uut: processador port map (
		clk => clk,
        rst => reset,
        state => state,
        pc_out => pc_out,
        instruction => instruction,
        bank_reg_out => bank_reg_out,
        accumulator_out => accumulator_out,
        ULA_out => ULA_out
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
        wait for 1000 us;         -- <== TEMPO TOTAL DA SIMULA��O!!!
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
end architecture a_processador_tb;