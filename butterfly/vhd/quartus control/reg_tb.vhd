-------------------------------------------------------------------------------
-- Title      : Testbench for design "reg"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : reg_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-04
-- Last update: 2021-01-04
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-04  1.0      wackoz	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity reg_tb is

end entity reg_tb;

-------------------------------------------------------------------------------

architecture arch of reg_tb is

  -- component generics
  constant N : integer := 8;

  -- component ports
  signal D                    : std_logic_vector(N-1 downto 0);
  signal clock, reset, enable : std_logic;
  signal Q                    : std_logic_vector(N-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT: entity work.reg
    generic map (
      N => N)
    port map (
      D      => D,
      clock  => clock,
      reset  => reset,
      enable => enable,
      Q      => Q);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture arch;

-------------------------------------------------------------------------------

configuration reg_tb_arch_cfg of reg_tb is
  for arch
  end for;
end reg_tb_arch_cfg;

-------------------------------------------------------------------------------
