library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- bits [16:13] = opcode
-- opcodes: 
--    1111 = jump
--    0001 = nop
--    0000 = nop
--    0010 = add
--    0011 = load immediate. Reg1 <- immediate
--    0100 = subtract
--    0101 = move
--    0110 = addi. 0110_IIIIIII_0RRR_xxx. I = immediate, RRR = reg1. reg1 += I.
--    0111 = subi. 0111_IIIIIII_0RRR_xxx. I = immediate, RRR = reg1. reg1 -= I.
--    1000 = clear. 1000_xxxxxxx_ARRR_xxx
--    1001 = CMPI. 1001_IIIIIII_ARRR_xxx. NOTE: MAKE IT SO THAT THE ALU ONLY UPDATES WHEN IT NEEDS TO EXECUTE AN OPRATIAON
-- bits [12:6] = immediate
-- bits [5:2] = reg1
--
-- move operation: 0101_xxxxxxx_ARRR_xxx
-- where RRR = reg1. If A = 0: reg1 <- A. Else: A <- reg1.
entity uc is
   port( 
         rst      : in std_logic;
         data_in  : in unsigned(6 downto 0);
         data_out : out unsigned(6 downto 0); -- data used to update PC

         jump_en      : out std_logic;
         add_op       : out std_logic;
         ld_op        : out std_logic; -- load immediate operation
         subtract_op : out std_logic; -- subtract operation
         move_op    : out std_logic; -- move operation
         addi_op   : out std_logic; -- add immediate operation
         subi_op   : out std_logic; -- subtract immediate operation
         clr_op   : out std_logic; -- clear operation
         cmpi_op   : out std_logic; -- compare immediate operation
         instruction  : in unsigned(16 downto 0);
         immediate    : out unsigned(6 downto 0);
         reg1         : out unsigned(3 downto 0)
   );
end entity;

architecture a_uc of uc is
   signal opcode: unsigned(3 downto 0);
   signal immediate_s: unsigned(6 downto 0);
   signal j_en: std_logic;
begin
   immediate_s <= instruction(12 downto 6);
   immediate <= immediate_s;
   opcode <= instruction(16 downto 13);
   j_en <= '0' when rst = '1' else '1' when opcode = "1111" else '0';
   jump_en <= j_en;

   add_op <= '1' when opcode = "0010" else '0';

   ld_op <= '1' when opcode = "0011" else '0'; -- load immediate operation

   subtract_op <= '1' when opcode = "0100" else '0'; -- subtract operation

   move_op <= '1' when opcode = "0101" else '0'; -- move operation

   addi_op <= '1' when opcode = "0110" else '0'; -- add immediate operation
   
   subi_op <= '1' when opcode = "0111" else '0'; -- subtract immediate operation

   clr_op <= '1' when opcode = "1000" else '0'; -- clear operation

   cmpi_op <= '1' when opcode = "1001" else '0'; -- compare immediate operation

   reg1 <= instruction(5 downto 2); -- bits [5:2] = reg1

   -- instruction equal to all zeros means the circuit has just been resetted. Next instruction will be the first one.
   data_out <= --(others => '0') when rst = '1' or instruction = "0000000000000000" else
               data_in + 1 when j_en = '0' else 
               immediate_s;
   
end architecture;