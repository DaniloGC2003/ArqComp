library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_regs_tb is
end;

architecture a_bank_regs_tb of bank_regs_tb is
    component bank_regs is
        port(    reg_r    : in unsigned(2 downto 0);
                 reg_wr   : in unsigned(2 downto 0);
                 clk      : in std_logic;
                 rst      : in std_logic;
                 wr_en    : in std_logic;
                 data_in  : in unsigned(15 downto 0);
                 data_out : out unsigned(15 downto 0)
        );
    end component;
   
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   reg_r       : unsigned(2 downto 0);
    signal   reg_wr      : unsigned(2 downto 0);
    signal   clk, reset  : std_logic;
	signal   wr_en       : std_logic;
	signal   data_in	 : unsigned(15 downto 0);
	signal   data_out	 : unsigned(15 downto 0);
   
begin
	uut: bank_regs port map (
		reg_r => reg_r,
        reg_wr => reg_wr,
        clk => clk,
        rst => reset,
        wr_en => wr_en,
        data_in => data_in,
        data_out => data_out
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
        
        reg_wr <= "000";

		wr_en <= '1';
		data_in <= "0000000011000000";
		wait for 100 ns;
        reg_r <= "000";
        wait for 100 ns;
		wait;
	end process;
end architecture a_bank_regs_tb;