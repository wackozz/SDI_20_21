-------------------------------------------------------------------------------
-- Title      : butterfly
-- Project    : 
-------------------------------------------------------------------------------
-- File       : butterfly.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-11
-- Last update: 2021-01-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Butterfly
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-11  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity butterfly is

  generic (
    N : integer := 20
    );

  port (
    clock : in std_logic;
    reset : in std_logic;
    start     : in  std_logic;
    done      : out std_logic;
    fullspeed : in  std_logic;
    --OUT
    Ar_out : out std_logic_vector(N-1 downto 0);
    Aj_out : out std_logic_vector(N-1 downto 0);
    Br_out : out std_logic_vector(N-1 downto 0);
    Bj_out : out std_logic_vector(N-1 downto 0);
    -- IN
    Wr    : in std_logic_vector(N-1 downto 0);
    Wj    : in std_logic_vector(N-1 downto 0);
    Ar_in : in std_logic_vector(N-1 downto 0);
    Aj_in : in std_logic_vector(N-1 downto 0);
    Br_in : in std_logic_vector(N-1 downto 0);
    Bj_in : in std_logic_vector(N-1 downto 0));
    -- OUT

end entity butterfly;

-------------------------------------------------------------------------------

architecture str of butterfly is
  component butterfly_dp is
    generic (
      N : integer);
    port (
      clock            : in  std_logic;
      reset            : in  std_logic;
      Wr               : in  std_logic_vector(19 downto 0);
      Wj               : in  std_logic_vector(19 downto 0);
      Aj_in            : in  std_logic_vector(19 downto 0);
      Ar_in            : in  std_logic_vector(19 downto 0);
      Bj_in            : in  std_logic_vector(19 downto 0);
      Br_in            : in  std_logic_vector(19 downto 0);
      Aj_out           : out std_logic_vector(19 downto 0);
      Ar_out           : out std_logic_vector(19 downto 0);
      Bj_out           : out std_logic_vector(19 downto 0);
      Br_out           : out std_logic_vector(19 downto 0);
      s_mux_B_mpy      : in  std_logic;
      s_mux_A_mpy      : in  std_logic_vector(1 downto 0);
      s_mux_B_add_1    : in  std_logic;
      s_mux_B_add_2    : in  std_logic;
      s_mux_round_in   : in  std_logic;
      add_sub_1        : in  std_logic;
      add_sub_2        : in  std_logic;
      sh_mpy           : in  std_logic;
      Wr_enable        : in  std_logic;
      Wj_enable        : in  std_logic;
      Br_enable        : in  std_logic;
      Bj_enable        : in  std_logic;
      Ar_enable        : in  std_logic;
      Aj_enable        : in  std_logic;
      Br_out_enable    : in  std_logic;
      Bj_out_enable    : in  std_logic;
      Ar_out_enable    : in  std_logic;
      Aj_out_enable    : in  std_logic;
      add_reg_1_enable : in  std_logic;
      add_reg_2_enable : in  std_logic;
      mpy_reg_enable   : in  std_logic);
  end component butterfly_dp;

  component controlunit_butterfly is
    port (
      status            : in  std_logic_vector (1 downto 0);
      clock, reset      : in  std_logic;
      datapath_commands : out std_logic_vector (21 downto 0);
      done              : out std_logic);
  end component controlunit_butterfly;
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal status            : std_logic_vector(1 downto 0);
  signal datapath_commands : std_logic_vector(21 downto 0);
  signal s_mux_B_mpy       : std_logic;
  signal s_mux_A_mpy       : std_logic_vector(1 downto 0);
  signal s_mux_B_add_1     : std_logic;
  signal s_mux_B_add_2     : std_logic;
  signal s_mux_round_in    : std_logic;
  signal add_sub_1         : std_logic;
  signal add_sub_2         : std_logic;
  signal sh_mpy            : std_logic;
  signal Wr_enable         : std_logic;
  signal Wj_enable         : std_logic;
  signal Br_enable         : std_logic;
  signal Bj_enable         : std_logic;
  signal Ar_enable         : std_logic;
  signal Aj_enable         : std_logic;
  signal Br_out_enable     : std_logic;
  signal Bj_out_enable     : std_logic;
  signal Ar_out_enable     : std_logic;
  signal Aj_out_enable     : std_logic;
  signal add_reg_1_enable  : std_logic;
  signal add_reg_2_enable  : std_logic;
  signal mpy_reg_enable    : std_logic;
begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "controlunit_butterfly_1"
  controlunit_butterfly_1 : controlunit_butterfly
    port map (
      status            => status,
      clock             => clock,
      reset             => reset,
      datapath_commands => datapath_commands,
      done              => done);

  -- instance "butterfly_dp_1"
  butterfly_dp_1 : butterfly_dp
    generic map (
      N => N)
    port map (
      clock            => clock,
      reset            => reset,
      Wr               => Wr,
      Wj               => Wj,
      Aj_in            => Aj_in,
      Ar_in            => Ar_in,
      Bj_in            => Bj_in,
      Br_in            => Br_in,
      Aj_out           => Aj_out,
      Ar_out           => Ar_out,
      Bj_out           => Bj_out,
      Br_out           => Br_out,
      s_mux_B_mpy      => s_mux_B_mpy,
      s_mux_A_mpy      => s_mux_A_mpy,
      s_mux_B_add_1    => s_mux_B_add_1,
      s_mux_B_add_2    => s_mux_B_add_2,
      s_mux_round_in   => s_mux_round_in,
      add_sub_1        => add_sub_1,
      add_sub_2        => add_sub_2,
      sh_mpy           => sh_mpy,
      Wr_enable        => Wr_enable,
      Wj_enable        => Wj_enable,
      Br_enable        => Br_enable,
      Bj_enable        => Bj_enable,
      Ar_enable        => Ar_enable,
      Aj_enable        => Aj_enable,
      Br_out_enable    => Br_out_enable,
      Bj_out_enable    => Bj_out_enable,
      Ar_out_enable    => Ar_out_enable,
      Aj_out_enable    => Aj_out_enable,
      add_reg_1_enable => add_reg_1_enable,
      add_reg_2_enable => add_reg_2_enable,
      mpy_reg_enable   => mpy_reg_enable
      );
  status           <= start&fullspeed;
  s_mux_B_mpy      <= datapath_commands(6);
  s_mux_A_mpy      <= datapath_commands(8 downto 7);
  s_mux_B_add_1    <= datapath_commands(17);
  s_mux_B_add_2    <= datapath_commands(10);
  s_mux_round_in   <= datapath_commands(21);
  add_sub_1        <= datapath_commands(18);
  add_sub_2        <= datapath_commands(12);
  sh_mpy           <= datapath_commands(9);
  Wr_enable        <= datapath_commands(2);
  Wj_enable        <= datapath_commands(1);
  Br_enable        <= datapath_commands(4);
  Bj_enable        <= datapath_commands(3);
  Ar_enable        <= datapath_commands(0);
  Aj_enable        <= datapath_commands(5);
  Br_out_enable    <= datapath_commands(16);
  Bj_out_enable    <= datapath_commands(15);
  Ar_out_enable    <= datapath_commands(13);
  Aj_out_enable    <= datapath_commands(14);
  add_reg_1_enable <= datapath_commands(19);
  add_reg_2_enable <= datapath_commands(20);
  mpy_reg_enable   <= datapath_commands(11);

end architecture str;

-------------------------------------------------------------------------------
