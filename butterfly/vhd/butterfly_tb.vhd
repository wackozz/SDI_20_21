-------------------------------------------------------------------------------
-- Title      : Testbench for design "butterfly"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : butterfly_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-11
-- Last update: 2021-02-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-11  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity butterfly_tb is

end entity butterfly_tb;

-------------------------------------------------------------------------------

architecture str of butterfly_tb is

  -- component generics
  constant N : integer := 20;

  -- component ports
  signal clock  : std_logic := '1';
  signal reset  : std_logic;
  signal start  : std_logic;
  signal done   : std_logic;
  signal Wj_in  : std_logic_vector(N-1 downto 0);
  signal Wr_in  : std_logic_vector(N-1 downto 0);
  signal Ar_in  : std_logic_vector(N-1 downto 0);
  signal Aj_in  : std_logic_vector(N-1 downto 0);
  signal Br_in  : std_logic_vector(N-1 downto 0);
  signal Bj_in  : std_logic_vector(N-1 downto 0);
  signal Ar_out : std_logic_vector(N-1 downto 0);
  signal Aj_out : std_logic_vector(N-1 downto 0);
  signal Br_out : std_logic_vector(N-1 downto 0);
  signal Bj_out : std_logic_vector(N-1 downto 0);

begin  -- architecture str

  -- component instantiation
  DUT : entity work.butterfly
    generic map (
      N => N)
    port map (
      clock  => clock,
      reset  => reset,
      Ar_in  => Ar_in,
      Aj_in  => Aj_in,
      Br_in  => Br_in,
      Bj_in  => Bj_in,
      Wr     => Wr_in,
      Wj     => Wj_in,
      start  => start,
      done   => done,
      Ar_out => Ar_out,
      Aj_out => Aj_out,
      Br_out => Br_out,
      Bj_out => Bj_out);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    start <= '0';
    reset <= '1';
    wait for 50 ns;
    reset <= '0';
    wait for 50 ns;
    reset <= '1';
    wait for 100 ns;
    start <= '1';
    wait for 1000 ns;
    start <= '0';
    -- insert signal assignments here
    wait;
  end process WaveGen_Proc;

  input_pro : process is
  begin  -- process input_pro
    Wr_in <= X"7fffb";
    Wj_in <= X"0A0D0";
    Ar_in <= X"40070";
    Aj_in <= X"13000";
    Br_in <= X"F0020";
    Bj_in <= X"0D100";
    wait for 220ns;
    Ar_in <= X"70006";
    Aj_in <= X"D3B00";
    Br_in <= X"C0020";
    Bj_in <= X"0010D";
    wait for 280ns;
    Ar_in <= X"80400";
    Aj_in <= X"93040";
    Br_in <= X"0F020";
    Bj_in <= X"A0100";
    wait for 280ns;
    Ar_in <= X"40070";
    Aj_in <= X"13000";
    Br_in <= X"F0020";
    Bj_in <= X"0D100";
    wait;
  end process input_pro;



end architecture str;
