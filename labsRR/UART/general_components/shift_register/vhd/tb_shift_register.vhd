library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_sr is
end testbench_sr;

architecture BEH of testbench_sr is
  signal clock : std_logic                    := '0';
  signal sh_en : std_logic                    := '0';
  signal ld_en : std_logic                    := '0';
  signal s_in  : std_logic                    := '0';
  signal s_out : std_logic;
  signal p_in  : std_logic_vector(7 downto 0) := "10101010";
  signal p_out : std_logic_vector(7 downto 0);

  component shift_register_8bit is
    port (
      clock : in  std_logic := '0';              --clock
      --controls
      sh_en : in  std_logic;                     --shift enable
      ld_en : in  std_logic;                     --load enable
      --input
      s_in  : in  std_logic;                     -- serial in
      s_out : out std_logic;                     -- serial out
      --output
      p_in  : in  std_logic_vector(7 downto 0);  -- parallel in
      p_out : out std_logic_vector(7 downto 0)   -- parallel out
      );
  end component;

begin

  clock <= not(clock) after 10 ns;

  load : process
  begin
    ld_en <= '0';
    wait for 10 ns;
    ld_en <= '1';
    wait for 50 ns;
    ld_en <= '0';
    wait;
  end process;
  sh_en <= '1' after 100 ns;
  inst1 : shift_register_8bit port map(
    clock => clock,
    sh_en => sh_en,
    ld_en => ld_en,
    p_in  => p_in,
    p_out => p_out,
    s_in  => s_in,
    s_out => s_out
    );
end architecture;
