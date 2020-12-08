-------------------------------------------------------------------------------
-- Title      : Testbench for design "counter_nbit"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : counter_nbit_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2020-12-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-09  1.0      wackoz	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity counter_nbit_tb is

end entity counter_nbit_tb;

-------------------------------------------------------------------------------

architecture arch of counter_nbit_tb is

  -- component generics
  constant N : integer := 3;

  -- component ports
  signal clock : std_logic := '0';
  signal clear : std_logic;
  signal en    : std_logic;
  signal ld    : std_logic;
  signal d     : std_logic_vector(N-1 downto 0);
  signal q     : std_logic_vector(N-1 downto 0);

begin  -- architecture arch

  -- component instantiation
  DUT: entity work.counter_nbit
    generic map (
      N => N)
    port map (
      clock => clock,
      clear => clear,
      en    => en,
      ld    => ld,
      d     => d,
      q     => q);

  -- clock generation
  clock <= not clock after 10 ns;
  -- din assignment
  d <= "010";
  -- waveform generation
  WaveGen_Proc: process
  begin
    en <= '1';
    clear <= '1';
    wait for 50 ns;   
-- insert signal assignments here
    clear <= '0';
    wait for 50 ns;
    clear <= '1';
    wait for 10 ns;
    clear <= '0';
    ld <= '1';
    wait;
  end process WaveGen_Proc;

  

end architecture arch;

-------------------------------------------------------------------------------

configuration counter_nbit_tb_arch_cfg of counter_nbit_tb is
  for arch
  end for;
end counter_nbit_tb_arch_cfg;

-------------------------------------------------------------------------------
