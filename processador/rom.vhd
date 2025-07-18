library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
end entity;
architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(16 downto 0);
   constant conteudo_rom : mem := (      
      --A
      0  => B"0011_0000000_1000_00", -- ld A,0
      1  => B"0101_0000000_0011_00", -- mv R3,A
      --B
      2  => B"0101_0000000_0100_00", -- mv R4,A
      --C
      3  => B"1000_0000000_1000_00", -- clr A
      4  => B"0010_0000000_0100_00", -- add A,R4
      5  => B"0010_0000000_0011_00", -- add A,R3
      6  => B"0101_0000000_0100_00", -- mv R4,A
      --D
      7  => B"1000_0000000_1000_00", -- clr A
      8  => B"0110_0000001_0000_00", -- addi 1
      9  => B"0010_0000000_0011_00", -- add A,R3
      10 => B"0101_0000000_0011_00", -- mv R3,A
      --E
      11 => B"0111_0011110_0000_00", -- subi 30
      12 => B"1101_1110111_0000_00", -- BMI -9 1110111
      --F
      13 => B"0101_0000000_1100_00", -- mv A,R4
      14 => B"0101_0000000_0101_00", -- mv R5,A



      --1  => B"0011_0000101_0100_00", -- ld R4,5
      --2  => B"0010_0000000_0011_00", -- add A,R3
      --4  => B"0100_0000000_0100_00", -- sub A,R4
      --5  => B"0110_0010001_0100_00", -- addi 17
      --6  => B"0110_1111011_0011_00", -- addi -5 
      --7  => B"0111_0001010_0000_00", -- subi 10
      --8  => B"1010_1111000_0000_00", -- BEQ -8

      --0  => B"0011_0000101_0011_10", -- ld R3,5
      --1  => B"0011_0001000_0100_00", -- ld R4,8
      --2  => B"0010_0000000_0011_00", -- add A,R3
      --3  => B"0010_0000000_0100_00", -- add A,R4
      --4  => B"0101_0000000_0101_00", -- mv R5,A
      --5  => B"0111_0000001_0101_00", -- subi 1,R5
      --6  => B"1111_0010100_0000_00", -- j 20
      --7  => B"1000_0000000_0101_00", -- clr R5

      --20 => B"0101_0000000_1101_00", -- mv A,R5
      --21 => B"0101_0000000_0011_00", -- mv R3,A
      --22 => B"1111_0000010_0000_00", -- j 2
      --23  => B"1000_0000000_0011_00", -- clr R3

      -- caso endereco => conteudo
      --0  => B"0011_0001110_1000_10", -- ld 14 into accumulator
      --1  => B"0101_0000000_0101_00", -- MOV Accumulator -> r5
      --2  => B"0111_0000011_0101_00", -- subi r5, 3
      --3  => B"1001_0001011_0101_11", -- cmpi r5, 11
      --4  => B"1001_0001010_0000_00", -- cmpi r5, 10
      --5  => B"0111_0001001_0101_01", -- subi r5, 9
      --6  => B"0011_0000001_0001_10", -- ld into r1
      --7  => B"0011_0100001_0011_10", -- ld into r3
      --8  => B"0010_0000000_0011_00", -- add r3
      --9  => B"0100_0000000_0001_00", -- sub r1
      --10 => B"0101_0000000_1110_10", -- load r6 into Accumulator
      --11 => B"11110000000001011", -- B. instruction says "jump to 0"
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;