-------------------------------------------------------------------------------
-- Title      : Testbench for design "round_block"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : round_block_tb.vhd
-- Author     : wackoz  <wackoz@wT14>
-- Company    : 
-- Created    : 2021-02-12
-- Last update: 2021-02-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-02-12  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity round_block_tb is

end entity round_block_tb;

-------------------------------------------------------------------------------

architecture arch of round_block_tb is

  -- component generics
  constant N : integer := 20;
  constant M : integer := 40;

  -- component ports
  signal reset : std_logic;
  signal clock : std_logic := '1';
  signal A     : std_logic_vector(39 downto 0);
  signal Y     : std_logic_vector(20-1 downto 0);

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.round_block
    generic map (
      N => N,
      M => M)
    port map (
      reset => reset,
      clock => clock,
      A     => A,
      Y     => Y);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    reset <= '0';
    wait for 5 ns;
    reset <= '1';
    -- insert signal assignments here
    wait for 10 ns;

    A <= "00"&"0000000000000000000"&"1000000000000000000";
    wait for 20 ns;
    A <= "00"&"0000000000000000001"&"1000000000000000000";
    wait for 20 ns;
    A <= "00"&"0000000000000000011"&"0010100000000000000";
    wait for 20 ns;
    A <= "01"&"0000000000000000001"&"1100000000000000000";
    wait;
  end process WaveGen_Proc;

end architecture arch;

-------------------------------------------------------------------------------

configuration round_block_tb_arch_cfg of round_block_tb is
  for arch
  end for;
end round_block_tb_arch_cfg;

-------------------------------------------------------------------------------
