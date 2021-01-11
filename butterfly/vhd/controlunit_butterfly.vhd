library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlunit_butterfly is

  port (status            : in  std_logic_vector (1 downto 0);
        clock, reset      : in  std_logic;
        datapath_commands : out std_logic_vector (21 downto 0);
        done              : out std_logic);
end controlunit_butterfly;

architecture behav of controlunit_butterfly is

  component microROM is

    generic (constant N : integer := 31);
    port (ADDRESS                   : in  std_logic_vector (4 downto 0);
          OUT_MEM_even, OUT_MEM_odd : out std_logic_vector (N-1 downto 0));
  end component;

  component PLA_status is
    port (full_speed, start, lsb_in : in  std_logic;
          cc_validation             : in  std_logic_vector(1 downto 0);
          LSB_out                   : out std_logic);
  end component;

  component mux_2_to_1_rom is

    port (x1, y1 : in  std_logic_vector (30 downto 0);
          s      : in  std_logic;
          m1     : out std_logic_vector(30 downto 0));
  end component;

  component reg is
    generic (
      N : integer);
    port (
      D                    : in  std_logic_vector(N-1 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector(N-1 downto 0));
  end component reg;

  component reg_neg_triggered is
    generic (
      N : integer);
    port (
      D                    : in  std_logic_vector(N-1 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector(N-1 downto 0));
  end component reg_neg_triggered;

  signal mem_out1, mem_out2, mux_out, out_uIR : std_logic_vector (30 downto 0);
  signal in2_mux, in_uAR                      : std_logic;
  signal out_uAR, D_uAR                       : std_logic_vector(5 downto 0);
  signal in_uAR2                              : std_logic_vector(4 downto 0);


begin

  datapath_commands <= out_uIR(27 downto 6);
  done              <= out_uIR(28);
  in_uAR2           <= out_uIR(5 downto 1);
  D_uAR             <= in_uAr2 & in_uAR;


  rom :
    microROM port map (ADDRESS => out_uAR(5 downto 1), OUT_MEM_even => mem_out1, OUT_MEM_odd => mem_out2);

  muxROM :
    mux_2_to_1_rom port map (x1 => mem_out1, y1 => mem_out2, s => out_uAR(0), m1(30 downto 0) => mux_out(30 downto 0));

  late_status :
    PLA_status port map (full_speed    => status(0), start => status(1), lsb_in => out_uIR(0),
                         cc_validation => out_uIR(30 downto 29), LSB_out => in_uAR);


  -- instance "reg_uAR"
  reg_uAR : reg
    generic map (
      N => 6)
    port map (
      D      => D_uAR,
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => out_uAR);

  -- instance "reg_uIR"
  reg_uIR : reg_neg_triggered
    generic map (
      N => 31)
    port map (
      D      => mux_out,
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => out_uIR);



end behav;
