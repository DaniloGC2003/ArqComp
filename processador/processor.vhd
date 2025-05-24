library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
   port( clk      : in std_logic;
         rst      : in std_logic;
         state    : out unsigned(1 downto 0);
         PC      : out unsigned(6 downto 0);
         instruction : out unsigned(16 downto 0);
         bank_reg_out : out unsigned(15 downto 0);
         accumulator_out : out unsigned(15 downto 0);
   );
end entity;

architecture a_processor of processor is
   component pc_uc is
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic
      );
   end component;

   component bank_ULA is
      port(
         reg_r    : in unsigned(2 downto 0);
         reg_wr   : in unsigned(2 downto 0);
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic; 
         data_in  : in unsigned(15 downto 0);
         data_out : out unsigned(15 downto 0);
         select_operation: in unsigned(1 downto 0)
      );
   end component;

begin
    pc_uc_inst: pc_uc
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => '1'  -- Assuming write enable is always high for this example
        );
    
    bank_ULA_inst: bank_ULA
        port map(
            reg_r    => "000",  -- Example register read
            reg_wr   => "001",  -- Example register write
            clk      => clk,
            rst      => rst,
            wr_en    => '1',  -- Assuming write enable is always high for this example
            data_in  => (others => '0'),  -- Example data input
            data_out => bank_reg_out,
            select_operation => "00"  -- Example operation selection
        );



    end architecture;