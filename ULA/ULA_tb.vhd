library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end;

architecture a_ULA_tb of ULA_tb is
    component ULA
        port (
            in1 : in unsigned(15 downto 0); 
            in2 : in unsigned(15 downto 0); 
            select_operation : in unsigned(1 downto 0);
            result : out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;
    signal in1, in2, result : unsigned(15 downto 0);
    signal select_operation : unsigned(1 downto 0);
    signal carry, overflow : std_logic;

begin
    uut: ULA port map (
        in1 => in1,
        in2 => in2,
        select_operation => select_operation,
        result => result,
        carry => carry,
        overflow => overflow
    );

    process
    begin
        in1 <= "1000000000000001";
        in2 <= "1000000000000010";
        select_operation <= "00";
        wait for 50 ns;
        
        in1 <= "0000000000000010";
        in2 <= "0000000000000001";
        select_operation <= "01";
        wait for 50 ns;
        
        in1 <= "1111111111111111";
        in2 <= "1010101010101010";
        select_operation <= "10";
        wait for 50 ns;
        
        in1 <= "1100110011001100";
        in2 <= "0011001100110011";
        select_operation <= "11";
        wait for 50 ns;
    
        wait;
    end process;
end architecture;