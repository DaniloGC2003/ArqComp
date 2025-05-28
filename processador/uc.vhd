library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- bits [16:13] = opcode
-- opcodes: 
--    1111 = jump
--    0001 = nop
--    0010 = add
--    0011 = load immediate
-- bits [12:6] = immediate
-- bits [5:3] = reg1
entity uc is
   port( 
         rst      : in std_logic;
         data_in  : in unsigned(6 downto 0);
         data_out : out unsigned(6 downto 0);

         jump_en      : out std_logic;
         add_op       : out std_logic;
         ld_op        : out std_logic; -- load immediate operation
         instruction  : in unsigned(16 downto 0);
         reg1         : out unsigned(2 downto 0)
   );
end entity;

architecture a_uc of uc is
   signal opcode: unsigned(3 downto 0);
   signal immediate: unsigned(6 downto 0);
   signal j_en: std_logic;
begin
   immediate <= instruction(12 downto 6);
   opcode <= instruction(16 downto 13);
   j_en <= '0' when rst = '1' else '1' when opcode = "1111" else '0';
   jump_en <= j_en;

   add_op <= '1' when opcode = "0010" else '0';

   ld_op <= '1' when opcode = "0011" else '0'; -- load immediate operation

   reg1 <= instruction(5 downto 3); -- bits [5:3] = reg1

   -- instruction equal to all zeros means the circuit has just been resetted. Next instruction will be the first one.
   data_out <= (others => '0') when rst = '1' or instruction = "0000000000000000" else
               data_in + 1 when j_en = '0' else 
               immediate;
   
end architecture;