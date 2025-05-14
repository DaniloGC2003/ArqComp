library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end;

architecture a_ULA_tb of ULA_tb is
    component ULA
        port (
            in1 : in unsigned(16 downto 0); 
            in2 : in unsigned(16 downto 0); 
            select_operation : in unsigned(1 downto 0);
            result : out unsigned(16 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;
    signal in1, in2, result : unsigned(16 downto 0);
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
        -- sum with carry
        in1 <= "10000000000000001";
        in2 <= "10000000000000010";
        select_operation <= "00";
        wait for 50 ns;
        
        -- subtraction with carry
        in1 <= "00000000000000010";
        in2 <= "10000000000000001";
        select_operation <= "01";
        wait for 50 ns;
        
        --sum without carry
        in1 <= "00000000100110001";
        in2 <= "00000000100000001";
        select_operation <= "00";
        wait for 50 ns;
        
        -- subtraction without carry
        in1 <= "11001100011001100";
        in2 <= "00110011000110011";
        select_operation <= "01";
        wait for 50 ns;

        -- sum with overflow
        in1 <= "01000000000010100";
        in2 <= "01000000000101000";
        select_operation <= "00";
        wait for 50 ns;
    
        -- subtraction with overflow
        in1 <= "11000000000010100";
        in2 <= "01001010000101000";
        select_operation <= "01";
        wait for 50 ns;

        -- sum without overflow
        in1 <= "00000000011110000";
        in2 <= "00000000110001010";
        select_operation <= "00";
        wait for 50 ns;

        -- subtraction without overflow
        in1 <= "00110000000001000";
        in2 <= "00000000001000000";
        select_operation <= "01";
        wait for 50 ns;

        -- and operation
        in1 <= "10000000110010010";
        in2 <= "01100000110000100";  
        select_operation <= "10";
        wait for 50 ns;

        -- or operation
        in1 <= "00000010000000011";
        in2 <= "00000010000011000";
        select_operation <= "11";
        wait for 50 ns;

        wait;
    end process;
end architecture;