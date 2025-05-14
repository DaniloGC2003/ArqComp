library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port (
        in1 : in unsigned(16 downto 0); 
        in2 : in unsigned(16 downto 0); 
        select_operation : in unsigned(1 downto 0);
        result : out unsigned(16 downto 0);
        carry : out std_logic;
        overflow : out std_logic
        --select_operation: "00": sum; "01": substraction; "10": and; "11": or
    );
end ULA;

architecture a_ULA of ULA is
    signal sum_result: unsigned(17 downto 0);
    signal sub_result: unsigned(17 downto 0);
    signal and_result: unsigned(16 downto 0);
    signal or_result: unsigned(16 downto 0);
    begin
        sum_result <= ("0" & in1) + ("0" & in2);
        sub_result <= ("0" & in1) - ("0" & in2);
        and_result <= in1 and in2;
        or_result <= in1 or in2;
        result <= sum_result(16 downto 0) when select_operation = "00" else
                  sub_result(16 downto 0) when select_operation = "01" else
                  and_result when select_operation = "10" else
                  or_result when select_operation = "11" else
                  (others => '0'); -- Default case
        carry <= sum_result(16) when select_operation = "00" else
                '1' when select_operation = "01" and in1 < in2 else '0';
                    -- overflow sum: inputs with same signs and result has different sign
                    -- overflow sub: inputs with different signs and result has different sign from in1
        overflow <= '1' when select_operation = "00" and (in1(16) = in2(16)) and (sum_result(16) /= in1(16)) else
                    '1' when select_operation = "01" and (in1(16) /= in2(16)) and (sub_result(16) /= in1(16)) else
                    '0';
    end architecture;