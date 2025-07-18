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
        overflow : out std_logic;
        zero : out std_logic;
        result_sign : out std_logic
        -- zero: '1' when result = 0
        --select_operation: "00": sum; "01": substraction; "10": and; "11": or
    );
end ULA;

architecture a_ULA of ULA is
    signal sum_result: unsigned(16 downto 0);
    signal sub_result: unsigned(16 downto 0);
    signal and_result: unsigned(15 downto 0);
    signal or_result: unsigned(15 downto 0);
    signal final_result: unsigned(15 downto 0);
    begin
        sum_result <= ("0" & in1) + ("0" & in2);
        sub_result <= ("0" & in2) - ("0" & in1);
        and_result <= in1 and in2;
        or_result <= in1 or in2;
        final_result <= sum_result(15 downto 0) when select_operation = "00" else
                  sub_result(15 downto 0) when select_operation = "01" else
                  and_result when select_operation = "10" else
                  or_result when select_operation = "11" else
                  (others => '0');
        result <= final_result;
        carry <= sum_result(16) when select_operation = "00" else
                '1' when select_operation = "01" and in2 < in1 else '0'; -- editar depois.
                    -- overflow sum: inputs with same signs and result has different sign
                    -- overflow sub: inputs with different signs and result has different sign from in1

                    --two operands with same sign and result has different sign
        overflow <= '1' when select_operation = "00" and (in1(15) = in2(15)) and (sum_result(15) /= in1(15)) else 
                    --two operands with different signs and result has different sign from in1
                    '1' when select_operation = "01" and (in2(15) /= in1(15)) and (sub_result(15) /= in2(15)) else
                    '0';
        zero <= '1' when final_result = "0000000000000000" else '0';
        result_sign <= '1' when final_result(15) = '1' else '0'; -- sign of the result
    end architecture;