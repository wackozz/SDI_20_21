-------------------------------------------------------------------------------
-- Title      : Testbench for design "FFT"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FFT_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-15
-- Last update: 2021-01-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-15  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.fixed_pkg.all;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity FFT_tb is

end entity FFT_tb;

-------------------------------------------------------------------------------

architecture arch of FFT_tb is

  -- component generics
  constant N : integer := 20;

  -- component ports
  signal clock             : std_logic :='1';
  signal reset             : std_logic;
  signal start             : std_logic;
  signal done              : std_logic;
  signal x0, x0j           : sfixed(0 downto -19);
  signal x1, x1j           : sfixed(0 downto -19);
  signal x2, x2j           : sfixed(0 downto -19);
  signal x3, x3j           : sfixed(0 downto -19);
  signal x4, x4j           : sfixed(0 downto -19);
  signal x5, x5j           : sfixed(0 downto -19);
  signal x6, x6j           : sfixed(0 downto -19);
  signal x7, x7j           : sfixed(0 downto -19);
  signal x8, x8j           : sfixed(0 downto -19);
  signal x9, x9j           : sfixed(0 downto -19);
  signal x10, x10j         : sfixed(0 downto -19);
  signal x11, x11j         : sfixed(0 downto -19);
  signal x12, x12j         : sfixed(0 downto -19);
  signal x13, x13j         : sfixed(0 downto -19);
  signal x14, x14j         : sfixed(0 downto -19);
  signal x15, x15j         : sfixed(0 downto -19);
  signal x0_out, x0j_out   : std_logic_vector(N+4 downto 0);
  signal x1_out, x1j_out   : std_logic_vector(N+4 downto 0);
  signal x2_out, x2j_out   : std_logic_vector(N+4 downto 0);
  signal x3_out, x3j_out   : std_logic_vector(N+4 downto 0);
  signal x4_out, x4j_out   : std_logic_vector(N+4 downto 0);
  signal x5_out, x5j_out   : std_logic_vector(N+4 downto 0);
  signal x6_out, x6j_out   : std_logic_vector(N+4 downto 0);
  signal x7_out, x7j_out   : std_logic_vector(N+4 downto 0);
  signal x8_out, x8j_out   : std_logic_vector(N+4 downto 0);
  signal x9_out, x9j_out   : std_logic_vector(N+4 downto 0);
  signal x10_out, x10j_out : std_logic_vector(N+4 downto 0);
  signal x11_out, x11j_out : std_logic_vector(N+4 downto 0);
  signal x12_out, x12j_out : std_logic_vector(N+4 downto 0);
  signal x13_out, x13j_out : std_logic_vector(N+4 downto 0);
  signal x14_out, x14j_out : std_logic_vector(N+4 downto 0);
  signal x15_out, x15j_out : std_logic_vector(N+4 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.FFT
    generic map (
      N => N)
    port map (
      clock    => clock,
      reset    => reset,
      start    => start,
      done     => done,
      x0       => to_slv(x1),
      x0j      => to_slv(x0j),
      x1       => to_slv(x1),
      x1j      => to_slv(x1j),
      x2       => to_slv(x2),
      x2j      => to_slv(x2j),
      x3       => to_slv(x3),
      x3j      => to_slv(x3j),
      x4       => to_slv(x4),
      x4j      => to_slv(x4j),
      x5       => to_slv(x5),
      x5j      => to_slv(x5j),
      x6       => to_slv(x6),
      x6j      => to_slv(x6j),
      x7       => to_slv(x7),
      x7j      => to_slv(x7j),
      x8       => to_slv(x8),
      x8j      => to_slv(x8j),
      x9       => to_slv(x9),
      x9j      => to_slv(x9j),
      x10      => to_slv(x10),
      x10j     => to_slv(x10j),
      x11      => to_slv(x11),
      x11j     => to_slv(x11j),
      x12      => to_slv(x12),
      x12j     => to_slv(x12j),
      x13      => to_slv(x13),
      x13j     => to_slv(x13j),
      x14      => to_slv(x14),
      x14j     => to_slv(x14j),
      x15      => to_slv(x15),
      x15j     => to_slv(x15j),
      x0_out   => x0_out,
      x0j_out  => x0j_out,
      x1_out   => x1_out,
      x1j_out  => x1j_out,
      x2_out   => x2_out,
      x2j_out  => x2j_out,
      x3_out   => x3_out,
      x3j_out  => x3j_out,
      x4_out   => x4_out,
      x4j_out  => x4j_out,
      x5_out   => x5_out,
      x5j_out  => x5j_out,
      x6_out   => x6_out,
      x6j_out  => x6j_out,
      x7_out   => x7_out,
      x7j_out  => x7j_out,
      x8_out   => x8_out,
      x8j_out  => x8j_out,
      x9_out   => x9_out,
      x9j_out  => x9j_out,
      x10_out  => x10_out,
      x10j_out => x10j_out,
      x11_out  => x11_out,
      x11j_out => x11j_out,
      x12_out  => x12_out,
      x12j_out => x12j_out,
      x13_out  => x13_out,
      x13j_out => x13j_out,
      x14_out  => x14_out,
      x14j_out => x14j_out,
      x15_out  => x15_out,
      x15j_out => x15j_out
      );

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    reset <= '1';
    wait for 15 ns;
    reset <= '0';
    wait for 12 ns;
    reset <= '1';
    start <= '1';
    wait for 100 ns;
start <= '0';
    wait;
  end process WaveGen_Proc;

  x0   <= To_sfixed(0.25, x0);
  x0j  <= to_sfixed(0, x0);
  x1   <= To_sfixed(0.25, x0);
  x1j  <= to_sfixed(0, x0);
  x2   <= To_sfixed(0.25, x0);
  x2j  <= to_sfixed(0, x0);
  x3   <= To_sfixed(0.25, x0);
  x3j  <= to_sfixed(0, x0);
  x4   <= To_sfixed(0.25, x0);
  x4j  <= to_sfixed(0, x0);
  x5   <= To_sfixed(0.25, x0);
  x5j  <= to_sfixed(0, x0);
  x6   <= To_sfixed(0.25, x0);
  x6j  <= to_sfixed(0, x0);
  x7   <= To_sfixed(0.25, x0);
  x7j  <= to_sfixed(0, x0);
  x8   <= To_sfixed(0.25, x0);
  x8j  <= to_sfixed(0, x0);
  x9   <= To_sfixed(-0.25, x0);
  x9j  <= to_sfixed(0, x0);
  x10  <= To_sfixed(-0.25, x0);
  x10j <= to_sfixed(0, x0);
  x11  <= To_sfixed(-0.25, x0);
  x11j <= to_sfixed(0, x0);
  x12  <= To_sfixed(-0.25, x0);
  x12j <= to_sfixed(0, x0);
  x13  <= To_sfixed(-0.25, x0);
  x13j <= to_sfixed(0, x0);
  x14  <= To_sfixed(-0.25, x0);
  x14j <= to_sfixed(0, x0);
  x15  <= To_sfixed(-0.25, x0);
  x15j <= to_sfixed(0, x0);

end architecture arch;



