library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port (
        in1 : in unsigned(15 downto 0); 
        in2 : in unsigned(15 downto 0); 
        select_operation : in unsigned(1 downto 0);
        result : out unsigned(15 downto 0);
        carry : out std_logic;
        overflow : out std_logic
        --select_operation: "00": sum; "01": substraction; "10": and; "11": or
    );
end ULA;

architecture a_ULA of ULA is
    signal sum_result: unsigned(16 downto 0);
    begin
        --result <=   in1 + in2 when select_operation = "00" else 
        --            in1 - in2 when select_operation = "01" else
        --            in1 and in2 when select_operation = "10" else
        --            in1 or in2 when select_operation = "11" else
        --            "0000000000000000";
        --when summing:
        if select_operation = "00" then
            sum_result <= ('0' & in1) + ('0' & in2);
            result <= sum_result(15 downto 0);
            -- carry
            carry <= sum_result(16);
            -- overflow
            overflow <= '1' when (in1(15) = in2(15)) and (result(15) /= in1(15)) else
                        '0';
        --when subtracting:
        elsif select_operation = "01" then
            sum_result <= ('0' & in1) - ('0' & in2);
            result <= sum_result(15 downto 0);
            -- carry
            carry <= '1' when (in1 < in2) else '0';
            -- overflow
            overflow <= '1' when (in1(15) /= in2(15)) and (result(15) /= in1(15)) else
                        '0';
        --AND:
        elsif select_operation = "10" then
            result <= in1 and in2;
            carry <= '0';
            overflow <= '0';
        --OR:
        elsif select_operation = "11" then
            result <= in1 or in2;
            carry <= '0';
            overflow <= '0';
        end if;
    end architecture;