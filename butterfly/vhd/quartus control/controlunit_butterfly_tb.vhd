-------------------------------------------------------------------------------
-- Title      : Testbench for design "controlunit_butterfly"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : controlunit_butterfly_tb.vhd
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

entity controlunit_butterfly_tb is

end entity controlunit_butterfly_tb;

-------------------------------------------------------------------------------

architecture arch of controlunit_butterfly_tb is

  -- component ports
  signal status            : std_logic_vector (1 downto 0);
  signal clock             : std_logic;
  signal reset             : std_logic;
  signal datapath_commands : std_logic_vector (18 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT: entity work.controlunit_butterfly
    port map (
      status            => status,
      clock             => clock,
      reset             => reset,
      datapath_commands => datapath_commands);

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

configuration controlunit_butterfly_tb_arch_cfg of controlunit_butterfly_tb is
  for arch
  end for;
end controlunit_butterfly_tb_arch_cfg;

-------------------------------------------------------------------------------
