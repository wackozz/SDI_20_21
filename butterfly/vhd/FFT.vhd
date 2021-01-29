-------------------------------------------------------------------------------
-- Title      : FFT
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FFT.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-15
-- Last update: 2021-01-28
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: FFT
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-15  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity FFT is

  generic (
    N : integer := 20
    );

  port (
    clock     : in  std_logic;
    reset     : in  std_logic;
    start     : in  std_logic;
    done      : out std_logic;
    x0, x0j   : in  std_logic_vector(N-1 downto 0);
    x1, x1j   : in  std_logic_vector(N-1 downto 0);
    x2, x2j   : in  std_logic_vector(N-1 downto 0);
    x3, x3j   : in  std_logic_vector(N-1 downto 0);
    x4, x4j   : in  std_logic_vector(N-1 downto 0);
    x5, x5j   : in  std_logic_vector(N-1 downto 0);
    x6, x6j   : in  std_logic_vector(N-1 downto 0);
    x7, x7j   : in  std_logic_vector(N-1 downto 0);
    x8, x8j   : in  std_logic_vector(N-1 downto 0);
    x9, x9j   : in  std_logic_vector(N-1 downto 0);
    x10, x10j : in  std_logic_vector(N-1 downto 0);
    x11, x11j : in  std_logic_vector(N-1 downto 0);
    x12, x12j : in  std_logic_vector(N-1 downto 0);
    x13, x13j : in  std_logic_vector(N-1 downto 0);
    x14, x14j : in  std_logic_vector(N-1 downto 0);
    x15, x15j : in  std_logic_vector(N-1 downto 0);

    x0_out, x0j_out   : out std_logic_vector(N+4 downto 0);
    x1_out, x1j_out   : out std_logic_vector(N+4 downto 0);
    x2_out, x2j_out   : out std_logic_vector(N+4 downto 0);
    x3_out, x3j_out   : out std_logic_vector(N+4 downto 0);
    x4_out, x4j_out   : out std_logic_vector(N+4 downto 0);
    x5_out, x5j_out   : out std_logic_vector(N+4 downto 0);
    x6_out, x6j_out   : out std_logic_vector(N+4 downto 0);
    x7_out, x7j_out   : out std_logic_vector(N+4 downto 0);
    x8_out, x8j_out   : out std_logic_vector(N+4 downto 0);
    x9_out, x9j_out   : out std_logic_vector(N+4 downto 0);
    x10_out, x10j_out : out std_logic_vector(N+4 downto 0);
    x11_out, x11j_out : out std_logic_vector(N+4 downto 0);
    x12_out, x12j_out : out std_logic_vector(N+4 downto 0);
    x13_out, x13j_out : out std_logic_vector(N+4 downto 0);
    x14_out, x14j_out : out std_logic_vector(N+4 downto 0);
    x15_out, x15j_out : out std_logic_vector(N+4 downto 0)
    );

end entity FFT;

-------------------------------------------------------------------------------

architecture str of FFT is
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal x0_I, x0j_I   : std_logic_vector(N-1 downto 0);
  signal x1_I, x1j_I   : std_logic_vector(N-1 downto 0);
  signal x2_I, x2j_I   : std_logic_vector(N-1 downto 0);
  signal x3_I, x3j_I   : std_logic_vector(N-1 downto 0);
  signal x4_I, x4j_I   : std_logic_vector(N-1 downto 0);
  signal x5_I, x5j_I   : std_logic_vector(N-1 downto 0);
  signal x6_I, x6j_I   : std_logic_vector(N-1 downto 0);
  signal x7_I, x7j_I   : std_logic_vector(N-1 downto 0);
  signal x8_I, x8j_I   : std_logic_vector(N-1 downto 0);
  signal x9_I, x9j_I   : std_logic_vector(N-1 downto 0);
  signal x10_I, x10j_I : std_logic_vector(N-1 downto 0);
  signal x11_I, x11j_I : std_logic_vector(N-1 downto 0);
  signal x12_I, x12j_I : std_logic_vector(N-1 downto 0);
  signal x13_I, x13j_I : std_logic_vector(N-1 downto 0);
  signal x14_I, x14j_I : std_logic_vector(N-1 downto 0);
  signal x15_I, x15j_I : std_logic_vector(N-1 downto 0);

  signal x0_II, x0j_II   : std_logic_vector(N-1 downto 0);
  signal x1_II, x1j_II   : std_logic_vector(N-1 downto 0);
  signal x2_II, x2j_II   : std_logic_vector(N-1 downto 0);
  signal x3_II, x3j_II   : std_logic_vector(N-1 downto 0);
  signal x4_II, x4j_II   : std_logic_vector(N-1 downto 0);
  signal x5_II, x5j_II   : std_logic_vector(N-1 downto 0);
  signal x6_II, x6j_II   : std_logic_vector(N-1 downto 0);
  signal x7_II, x7j_II   : std_logic_vector(N-1 downto 0);
  signal x8_II, x8j_II   : std_logic_vector(N-1 downto 0);
  signal x9_II, x9j_II   : std_logic_vector(N-1 downto 0);
  signal x10_II, x10j_II : std_logic_vector(N-1 downto 0);
  signal x11_II, x11j_II : std_logic_vector(N-1 downto 0);
  signal x12_II, x12j_II : std_logic_vector(N-1 downto 0);
  signal x13_II, x13j_II : std_logic_vector(N-1 downto 0);
  signal x14_II, x14j_II : std_logic_vector(N-1 downto 0);
  signal x15_II, x15j_II : std_logic_vector(N-1 downto 0);

  signal x0_III, x0j_III   : std_logic_vector(N-1 downto 0);
  signal x1_III, x1j_III   : std_logic_vector(N-1 downto 0);
  signal x2_III, x2j_III   : std_logic_vector(N-1 downto 0);
  signal x3_III, x3j_III   : std_logic_vector(N-1 downto 0);
  signal x4_III, x4j_III   : std_logic_vector(N-1 downto 0);
  signal x5_III, x5j_III   : std_logic_vector(N-1 downto 0);
  signal x6_III, x6j_III   : std_logic_vector(N-1 downto 0);
  signal x7_III, x7j_III   : std_logic_vector(N-1 downto 0);
  signal x8_III, x8j_III   : std_logic_vector(N-1 downto 0);
  signal x9_III, x9j_III   : std_logic_vector(N-1 downto 0);
  signal x10_III, x10j_III : std_logic_vector(N-1 downto 0);
  signal x11_III, x11j_III : std_logic_vector(N-1 downto 0);
  signal x12_III, x12j_III : std_logic_vector(N-1 downto 0);
  signal x13_III, x13j_III : std_logic_vector(N-1 downto 0);
  signal x14_III, x14j_III : std_logic_vector(N-1 downto 0);
  signal x15_III, x15j_III : std_logic_vector(N-1 downto 0);

  signal x0_IV, x0j_IV   : std_logic_vector(N-1 downto 0);
  signal x1_IV, x1j_IV   : std_logic_vector(N-1 downto 0);
  signal x2_IV, x2j_IV   : std_logic_vector(N-1 downto 0);
  signal x3_IV, x3j_IV   : std_logic_vector(N-1 downto 0);
  signal x4_IV, x4j_IV   : std_logic_vector(N-1 downto 0);
  signal x5_IV, x5j_IV   : std_logic_vector(N-1 downto 0);
  signal x6_IV, x6j_IV   : std_logic_vector(N-1 downto 0);
  signal x7_IV, x7j_IV   : std_logic_vector(N-1 downto 0);
  signal x8_IV, x8j_IV   : std_logic_vector(N-1 downto 0);
  signal x9_IV, x9j_IV   : std_logic_vector(N-1 downto 0);
  signal x10_IV, x10j_IV : std_logic_vector(N-1 downto 0);
  signal x11_IV, x11j_IV : std_logic_vector(N-1 downto 0);
  signal x12_IV, x12j_IV : std_logic_vector(N-1 downto 0);
  signal x13_IV, x13j_IV : std_logic_vector(N-1 downto 0);
  signal x14_IV, x14j_IV : std_logic_vector(N-1 downto 0);
  signal x15_IV, x15j_IV : std_logic_vector(N-1 downto 0);

  signal w0, w0j : std_logic_vector(N-1 downto 0);
  signal w1, w1j : std_logic_vector(N-1 downto 0);
  signal w2, w2j : std_logic_vector(N-1 downto 0);
  signal w3, w3j : std_logic_vector(N-1 downto 0);
  signal w4, w4j : std_logic_vector(N-1 downto 0);
  signal w5, w5j : std_logic_vector(N-1 downto 0);
  signal w6, w6j : std_logic_vector(N-1 downto 0);
  signal w7, w7j : std_logic_vector(N-1 downto 0);

  signal done_I, done_II, done_III     : std_logic;
  signal start_II, start_III, start_IV : std_logic;

  component reg is
    generic (
      N : integer);
    port (
      D                    : in  std_logic_vector(N-1 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector(N-1 downto 0));
  end component reg;

  component butterfly is
    generic (
      N : integer);
    port (
      clock  : in  std_logic;
      reset  : in  std_logic;
      start  : in  std_logic;
      done   : out std_logic;
      Ar_out : out std_logic_vector(N-1 downto 0);
      Aj_out : out std_logic_vector(N-1 downto 0);
      Br_out : out std_logic_vector(N-1 downto 0);
      Bj_out : out std_logic_vector(N-1 downto 0);
      Wr     : in  std_logic_vector(N-1 downto 0);
      Wj     : in  std_logic_vector(N-1 downto 0);
      Ar_in  : in  std_logic_vector(N-1 downto 0);
      Aj_in  : in  std_logic_vector(N-1 downto 0);
      Br_in  : in  std_logic_vector(N-1 downto 0);
      Bj_in  : in  std_logic_vector(N-1 downto 0));
  end component butterfly;

begin  -- architecture str


  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "reg_1"
  reg_1 : reg
    generic map (
      N => N)
    port map (
      D      => x"7ffff",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w0);

  -- instance "reg_2"
  reg_2 : reg
    generic map (
      N => N)
    port map (
      D      => x"00000",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w0j);

  -- instance "reg_3"
  reg_3 : reg
    generic map (
      N => N)
    port map (
      D      => x"7641b",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w1);

  -- instance "reg_4"
  reg_4 : reg
    generic map (
      N => N)
    port map (
      D      => x"cf044",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w1j);

  -- instance "reg_5"
  reg_5 : reg
    generic map (
      N => N)
    port map (
      D      => x"5a828",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w2);

  -- instance "reg_6"
  reg_6 : reg
    generic map (
      N => N)
    port map (
      D      => x"a57d8",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w2j);

  -- instance "reg_7"
  reg_7 : reg
    generic map (
      N => N)
    port map (
      D      => x"30fbc",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w3);

  -- instance "reg_8"
  reg_8 : reg
    generic map (
      N => N)
    port map (
      D      => x"89be5",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w3j);

  -- instance "reg_9"
  reg_9 : reg
    generic map (
      N => N)
    port map (
      D      => x"00000",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w4);

  -- instance "reg_10"
  reg_10 : reg
    generic map (
      N => N)
    port map (
      D      => x"80000",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w4j);

  -- instance "reg_11"
  reg_11 : reg
    generic map (
      N => N)
    port map (
      D      => x"cf044",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w5);

  -- instance "reg_12"
  reg_12 : reg
    generic map (
      N => N)
    port map (
      D      => x"89be5",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w5j);

  -- instance "reg_13"
  reg_13 : reg
    generic map (
      N => N)
    port map (
      D      => x"a57d8",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w6);

  -- instance "reg_14"
  reg_14 : reg
    generic map (
      N => N)
    port map (
      D      => x"a57d8",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w6j);

  -- instance "reg_15"
  reg_15 : reg
    generic map (
      N => N)
    port map (
      D      => x"89be5",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w7);


  -- instance "reg_16"
  reg_16 : reg
    generic map (
      N => N)
    port map (
      D      => x"cf044",
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => w7j);

-------------------------------------------------------------------------------

  -- instance "butterfly_1"
  Butterfly_1 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x0_I, x0j_I, x8_I, x8j_I, w0, w0j, x0, x0j, x8, x8j);

  -- instance "butterfly_1"
  Butterfly_2 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x1_I, x1j_I, x9_I, x9j_I, w0, w0j, x1, x1j, x9, x9j);
  -- instance "butterfly_1"
  Butterfly_3 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x2_I, x2j_I, x10_I, x10j_I, w0, w0j, x2, x2j, x10, x10j);
  -- instance "butterfly_1"
  Butterfly_4 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x3_I, x3j_I, x11_I, x11j_I, w0, w0j, x3, x3j, x11, x11j);
  -- instance "butterfly_1"
  Butterfly_5 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x4_I, x4j_I, x12_I, x12j_I, w0, w0j, x4, x4j, x12, x12j);
  -- instance "butterfly_1"
  Butterfly_6 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x5_I, x5j_I, x13_I, x13j_I, w0, w0j, x5, x5j, x13, x13j);
  -- instance "butterfly_1"
  Butterfly_7 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, open, x6_I, x6j_I, x14_I, x14j_I, w0, w0j, x6, x6j, x14, x14j);
  -- instance "butterfly_1"
  Butterfly_8 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start, done_I, x7_I, x7j_I, x15_I, x15j_I, w0, w0j, x7, x7j, x15, x15j);
  -- instance "butterfly_1"
  Butterfly_9 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x0_II, x0j_II, x4_II, x4j_II, w0, w0j, x0_I, x0j_I, x4_I, x4j_I);
  -- instance "butterfly_1"
  Butterfly_10 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x1_II, x1j_II, x5_II, x5j_II, w0, w0j, x1_I, x1j_I, x5_I, x5j_I);
  -- instance "butterfly_1"
  Butterfly_11 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x2_II, x2j_II, x6_II, x6j_II, w0, w0j, x2_I, x2j_I, x6_I, x6j_I);
  -- instance "butterfly_1"
  Butterfly_12 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x3_II, x3j_II, x7_II, x7j_II, w0, w0j, x3_I, x3j_I, x7_I, x7j_I);
  -- instance "butterfly_1"
  Butterfly_13 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x8_II, x8j_II, x12_II, x12j_II, w4, w4j, x8_I, x8j_I, x12_I, x12j_I);
  -- instance "butterfly_1"
  Butterfly_14 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x9_II, x9j_II, x13_II, x13j_II, w4, w4j, x9_I, x9j_I, x13_I, x13j_I);
  -- instance "butterfly_1"
  Butterfly_15 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, open, x10_II, x10j_II, x14_II, x14j_II, w4, w4j, x10_I, x10j_I, x14_I, x14j_I);
  -- instance "butterfly_1"
  Butterfly_16 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_II, done_II, x11_II, x11j_II, x15_II, x15j_II, w4, w4j, x11_I, x11j_I, x15_I, x15j_I);
  -- instance "butterfly_1"
  Butterfly_17 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x0_III, x0j_III, x2_III, x2j_III, w0, w0j, x0_II, x0j_II, x2_II, x2j_II);
  -- instance "butterfly_1"
  Butterfly_18 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x1_III, x1j_III, x3_III, x3j_III, w0, w0j, x1_II, x1j_II, x3_II, x3j_II);
  -- instance "butterfly_1"
  Butterfly_19 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x4_III, x4j_III, x6_III, x6j_III, w4, w4j, x4_II, x4j_II, x6_II, x6j_II);
  -- instance "butterfly_1"
  Butterfly_20 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x5_III, x5j_III, x7_III, x7j_III, w4, w4j, x5_II, x5j_II, x7_II, x7j_II);
  -- instance "butterfly_1"
  Butterfly_21 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x8_III, x8j_III, x10_III, x10j_III, w2, w2j, x8_II, x8j_II, x10_II, x10j_II);
  -- instance "butterfly_1"
  Butterfly_22 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x9_III, x9j_III, x11_III, x11j_III, w2, w2j, x9_II, x9j_II, x11_II, x11j_II);
  -- instance "butterfly_1"
  Butterfly_23 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, open, x12_III, x12j_III, x14_III, x14j_III, w6, w6j, x12_II, x12j_II, x14_II, x14j_II);
  -- instance "butterfly_1"
  Butterfly_24 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_III, done_III, x13_III, x13j_III, x15_III, x15j_III, w6, w6j, x13_II, x13j_II, x15_II, x15j_II);
  -- instance "butterfly_1"
  Butterfly_25 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x0_IV, x0j_IV, x1_IV, x1j_IV, w0, w0j, x0_III, x0j_III, x1_III, x1j_III);
  -- instance "butterfly_1"
  Butterfly_26 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x2_IV, x2j_IV, x3_IV, x3j_IV, w4, w4j, x2_III, x2j_III, x3_III, x3j_III);
  -- instance "butterfly_1"
  Butterfly_27 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x4_IV, x4j_IV, x5_IV, x5j_IV, w2, w2j, x4_III, x4j_III, x5_III, x5j_III);
  -- instance "butterfly_1"
  Butterfly_28 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x6_IV, x6j_IV, x7_IV, x7j_IV, w6, w6j, x6_III, x6j_III, x7_III, x7j_III);
  -- instance "butterfly_1"
  Butterfly_29 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x8_IV, x8j_IV, x9_IV, x9j_IV, w1, w1j, x8_III, x8j_III, x9_III, x9j_III);
  -- instance "butterfly_1"
  Butterfly_30 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x10_IV, x10j_IV, x11_IV, x11j_IV, w5, w5j, x10_III, x10j_III, x11_III, x11j_III);
  -- instance "butterfly_1"
  Butterfly_31 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, open, x12_IV, x12j_IV, x13_IV, x13j_IV, w3, w3j, x12_III, x12j_III, x13_III, x13j_III);
  -- instance "butterfly_1"
  Butterfly_32 : butterfly
    generic map (
      N => N)
    port map (clock, reset, start_IV, done, x14_IV, x14j_IV, x15_IV, x15j_IV, w7, w7j, x14_III, x14j_III, x15_III, x15j_III);


  start_II  <= done_I;
  start_III <= done_II;
  start_IV  <= done_III;


  x0_out   <= x0_IV&"00000";
  x0j_out  <= x0j_IV&"00000";
  x1_out   <= x8_IV&"00000";
  x1j_out  <= x8j_IV&"00000";
  x2_out   <= x4_IV&"00000";
  x2j_out  <= x4j_IV&"00000";
  x3_out   <= x12_IV&"00000";
  x3j_out  <= x12j_IV&"00000";
  x4_out   <= x2_IV&"00000";
  x4j_out  <= x2j_IV&"00000";
  x5_out   <= x10_IV&"00000";
  x5j_out  <= x10j_IV&"00000";
  x6_out   <= x6_IV&"00000";
  x6j_out  <= x6j_IV&"00000";
  x7_out   <= x14_IV&"00000";
  x7j_out  <= x14j_IV&"00000";
  x8_out   <= x1_IV&"00000";
  x8j_out  <= x1j_IV&"00000";
  x9_out   <= x9_IV&"00000";
  x9j_out  <= x9j_IV&"00000";
  x10_out  <= x5_IV&"00000";
  x10j_out <= x5j_IV&"00000";
  x11_out  <= x13_IV&"00000";
  x11j_out <= x13j_IV&"00000";
  x12_out  <= x3_IV&"00000";
  x12j_out <= x3j_IV&"00000";
  x13_out  <= x11_IV&"00000";
  x13j_out <= x11j_IV&"00000";
  x14_out  <= x7_IV&"00000";
  x14j_out <= x7j_IV&"00000";
  x15_out  <= x15_IV&"00000";
  x15j_out <= x15j_IV&"00000";
end architecture str;

-------------------------------------------------------------------------------
