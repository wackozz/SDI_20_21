-------------------------------------------------------------------------------
-- Title      : butterfly_dp
-- Project    : 
-------------------------------------------------------------------------------
-- File       : butterfly_dp.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-23
-- Last update: 2021-01-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Datapath Butterfly
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-23  1.0      wackoz  Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity butterfly_dp is

  generic(
    N : integer := 20);
  port (
    clock       : in  std_logic;
    reset       : in  std_logic;
-- INPUT
    Wr          : in  std_logic_vector(19 downto 0);
    Wj          : in  std_logic_vector(19 downto 0);
    Aj_in       : in  std_logic_vector(19 downto 0);
    Ar_in       : in  std_logic_vector(19 downto 0);
    Bj_in       : in  std_logic_vector(19 downto 0);
    Br_in       : in  std_logic_vector(19 downto 0);
--OUTPUT
    Aj_out      : out std_logic_vector(19 downto 0);
    Ar_out      : out std_logic_vector(19 downto 0);
    Bj_out      : out std_logic_vector(19 downto 0);
    Br_out      : out std_logic_vector(19 downto 0);
-- MUX SEL SIGNALS
    s_mux_B_mpy : in  std_logic;
    s_mux_A_mpy : in  std_logic_vector(1 downto 0);
    s_mux_B_add : in  std_logic_vector(1 downto 0);
-- ADD/MPY CTRL
    add_sub     : in  std_logic;
    sh_mpy      : in  std_logic);
end entity butterfly_dp;

-------------------------------------------------------------------------------

architecture str of butterfly_dp is

  -----------------------------------------------------------------------------
  -- INTERNAL SIGNALS DECLARATION
  -----------------------------------------------------------------------------

-- REGISTERS
  -- D
  signal Br_D : std_logic_vector(N-1 downto 0);
  signal Bj_D : std_logic_vector(N-1 downto 0);
  signal Ar_D : std_logic_vector(N-1 downto 0);
  signal Aj_D : std_logic_vector(N-1 downto 0);
  -- Q
  signal Br_Q : std_logic_vector(N-1 downto 0);
  signal Bj_Q : std_logic_vector(N-1 downto 0);
  signal Ar_Q : std_logic_vector(N-1 downto 0);
  signal Aj_Q : std_logic_vector(N-1 downto 0);
  signal Wj_Q : std_logic_vector(N-1 downto 0);
  signal Wr_Q : std_logic_vector(N-1 downto 0);

  -- EN
  signal Wr_enable     : std_logic;
  signal Wj_enable     : std_logic;
  signal Br_enable     : std_logic;
  signal Bj_enable     : std_logic;
  signal Ar_enable     : std_logic;
  signal Aj_enable     : std_logic;
  signal Br_out_enable : std_logic;
  signal Bj_out_enable : std_logic;
  signal Ar_out_enable : std_logic;
  signal Aj_out_enable : std_logic;
--MUX
  signal temp_D1       : std_logic_vector(2*N+2 downto 0);
  signal temp_D2       : std_logic_vector(2*N+2 downto 0);
--MPY
  signal mpy_in_A      : std_logic_vector(N-1 downto 0);
  signal mpy_in_B      : std_logic_vector(N-1 downto 0);
  signal mpy_out       : std_logic_vector(2*N-1 downto 0);

--ADDER
  signal add_in_A : std_logic_vector(2*N+2 downto 0);
  signal add_in_B : std_logic_vector(2*N+2 downto 0);
  signal add_out  : std_logic_vector(2*N+3 downto 0);

--ROUND BLOCK
  signal round_in  : std_logic_vector(2*N+3 downto 0);
  signal round_out : std_logic_vector(N-1 downto 0);


-----------------------------------------------------------------------------
-- COMPONENT DECLARATION
-----------------------------------------------------------------------------

--REGISTER
  component reg is
    generic (
      N : integer);
    port (
      D                    : in  std_logic_vector(N-1 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector(N-1 downto 0));
  end component reg;

--MUX
  component mux4to1 is
    generic (
      N : integer);
    port (
      S  : in  std_logic_vector(1 downto 0);
      D1 : in  std_logic_vector(N-1 downto 0);
      D2 : in  std_logic_vector(N-1 downto 0);
      D3 : in  std_logic_vector(N-1 downto 0);
      D4 : in  std_logic_vector(N-1 downto 0);
      Y  : out std_logic_vector(N-1 downto 0));
  end component mux4to1;

--MPY
  component mpy_sh is
    generic (
      N : integer);
    port (
      clock  : in  std_logic;
      reset  : in  std_logic;
      A      : in  std_logic_vector(N-1 downto 0);
      B      : in  std_logic_vector(N-1 downto 0);
      Y      : out std_logic_vector(2*N-1 downto 0);
      sh_mpy : in  std_logic);
  end component mpy_sh;

--ADDER
  component adder is
    generic (
      N : integer);
    port (
      clock   : in  std_logic;
      reset   : in  std_logic;
      add_sub : in  std_logic;
      A       : in  std_logic_vector(N-1 downto 0);
      B       : in  std_logic_vector(N-1 downto 0);
      Y       : out std_logic_vector(N downto 0));
  end component adder;

--ROUND BLOCK
  component round_block is
    generic (
      N : integer;
      M : integer);
    port (
      reset : in  std_logic;
      clock : in  std_logic;
      A     : in  std_logic_vector(M-1 downto 0);
      Y     : out std_logic_vector(N-1 downto 0));
  end component round_block;

  -----------------------------------------------------------------------------

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- COMPONENT MAPPING
  -----------------------------------------------------------------------------

-- MPY/SH
  mpy_sh_1 : mpy_sh
    generic map (
      N => N)
    port map (
      clock  => clock,
      reset  => reset,
      A      => mpy_in_A,
      B      => mpy_in_B,
      Y      => mpy_out,
      sh_mpy => sh_mpy);


-- ADD/SUB

  -- instance "adder_1"
  adder_1 : adder
    generic map (
      N => 2*N+3)
    port map (
      clock   => clock,
      reset   => reset,
      add_sub => add_sub,
      A       => add_in_A,
      B       => add_in_B,
      Y       => add_out);

-- ROUND BLOCK

  -- instance "round_block_1"
  round_block_1 : round_block
    generic map (
      N => N,
      M => 2*N+4)
    port map (
      reset => reset,
      clock => clock,
      A     => round_in,
      Y     => round_out);

-- REGISTERS

  -- instance "reg_Wr"
  reg_Wr : reg
    generic map (
      N => N)
    port map (
      D      => Wr,
      clock  => clock,
      reset  => reset,
      enable => Wr_enable,
      Q      => Wr_Q);

  -- instance "reg_1"
  reg_Wi : reg
    generic map (
      N => N)
    port map (
      D      => Wj,
      clock  => clock,
      reset  => reset,
      enable => Wj_enable,
      Q      => Wj_Q);

  -- instance "reg_Ar"
  reg_Ar : reg
    generic map (
      N => N)
    port map (
      D      => Ar_in,
      clock  => clock,
      reset  => reset,
      enable => Ar_enable,
      Q      => Ar_Q);

  -- instance "reg_Aj"
  reg_Aj : reg
    generic map (
      N => N)
    port map (
      D      => Aj_in,
      clock  => clock,
      reset  => reset,
      enable => Aj_enable,
      Q      => Aj_Q);

  -- instance "reg_Br"
  reg_Br : reg
    generic map (
      N => N)
    port map (
      D      => Br_in,
      clock  => clock,
      reset  => reset,
      enable => Br_enable,
      Q      => Br_Q);

  -- instance "reg_Bj"
  reg_Bj : reg
    generic map (
      N => N)
    port map (

      D      => Bj_in,
      clock  => clock,
      reset  => reset,
      enable => Bj_enable,
      Q      => Bj_Q);

--OUT


  -- instance "reg_Br_out"
  reg_Br_out : reg
    generic map (
      N => N)
    port map (

      D      => round_out,
      clock  => clock,
      reset  => reset,
      enable => Bj_out_enable,
      Q      => Br_out);


  -- instance "reg_Bj_out"
  reg_Bj_out : reg
    generic map (
      N => N)
    port map (

      D      => round_out,
      clock  => clock,
      reset  => reset,
      enable => Bj_out_enable,
      Q      => Bj_out);


  -- instance "reg_Ar_out"
  reg_Ar_out : reg
    generic map (
      N => N)
    port map (

      D      => round_out,
      clock  => clock,
      reset  => reset,
      enable => Ar_out_enable,
      Q      => Ar_out);


  -- instance "reg_Ar_out"
  reg_Aj_out : reg
    generic map (
      N => N)
    port map (

      D      => round_out,
      clock  => clock,
      reset  => reset,
      enable => Aj_out_enable,
      Q      => Aj_out);

--MUX
  -- instance "mux4to1_1"
  mux4to1_1 : mux4to1
    generic map (
      N => N)
    port map (
      S  => s_mux_A_mpy,
      D1 => Wr_Q,
      D2 => Wj_Q,
      D3 => Ar_Q,
      D4 => Aj_Q,
      Y  => mpy_in_A);

-- instance "mux4to1_1"
  mux4to1_2 : mux4to1
    generic map (
      N => 43)
    port map (
      S  => s_mux_B_add,
      D1 => temp_D1,
      D2 => temp_D2,
      D3 => add_out(2*N+2 downto 0),
      D4 => add_out(2*N+2 downto 0),
      Y  => add_in_B);
-------------------------------------------------------------------------------
-- SIGNAL ASSIGNMENT
-------------------------------------------------------------------------------

  temp_D1 <= std_logic_vector(resize(signed(Ar_Q), 43));
  temp_D2 <= std_logic_vector(resize(signed(Aj_Q), 43));
--MUX2to1

  mpy_in_B <= Br_Q when s_mux_B_mpy = '0'else
              Bj_Q;

  round_in <= add_out;
  add_in_A <= std_logic_vector(resize(signed(mpy_out), 2*N+3));
end architecture str;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
