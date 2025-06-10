library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
end;

architecture a_ram_tb of ram_tb is
    component ram is
        port(    clk      : in std_logic;
                 endereco : in unsigned(6 downto 0);
                 wr_en    : in std_logic;
                 dado_in  : in unsigned(15 downto 0);
                 dado_out : out unsigned(15 downto 0)
        );
    end component;
   constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic;
    signal   endereco    : unsigned(6 downto 0);
    signal   wr_en       : std_logic;
    signal   dado_in     : unsigned(15 downto 0);
    signal   dado_out    : unsigned(15 downto 0);
begin
	uut: ram port map (
		clk => clk,
		endereco => endereco,
		wr_en => wr_en,
		dado_in => dado_in,
		dado_out => dado_out
	);

	reset_global: process
    begin
        wait for period_time*2; -- espera 2 clocks, pra garantir
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
        wr_en <= '0';
		wait for 200 ns;
        wr_en <= '1';
        endereco <= "0101100"; 
        dado_in <= "1110010110000000";
        wait for 200 ns;
        wr_en <= '1';
        endereco <= "0001100"; 
        dado_in <= "1111000000000000";
        wait for 200 ns;
        wr_en <= '0';
        endereco <= "0101100";
        wait for 200 ns;
        wr_en <= '0';
        endereco <= "0001100";
        wait for 200 ns;
        wait;
	end process;
end architecture a_ram_tb;