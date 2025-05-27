library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- bits [16:13] = opcode
-- opcode: 1111 = jump
-- bits [12:6] = immediate
entity uc is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;--currently not used
         data_in  : in unsigned(6 downto 0);
         data_out : out unsigned(6 downto 0);

         jump_en      : out std_logic;
         instruction  : in unsigned(16 downto 0)
   );
end entity;

architecture a_uc of uc is
   signal opcode: unsigned(3 downto 0);
   signal immediate: unsigned(6 downto 0);
   signal j_en: std_logic;
begin
   opcode <= instruction(16 downto 13);
   j_en <= '0' when rst = '1' else '1' when opcode = "1111" else '0';
   jump_en <= j_en;
   immediate <= instruction(12 downto 6);
   data_out <= (others => '0') when rst = '1' else
               data_in + 1 when j_en = '0' else 
               immediate;
end architecture;