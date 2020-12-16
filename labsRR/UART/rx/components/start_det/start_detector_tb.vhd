-------------------------------------------------------------------------------
-- Title      : Testbench for design "start_detector"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : start_detector_tb.vhd
-- Author     :   <Sabina@DESKTOP-IN9UA4D>
-- Company    : 
-- Created    : 2020-12-15
-- Last update: 2020-12-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-15  1.0      Sabina	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity start_detector_tb is

end entity start_detector_tb;

-------------------------------------------------------------------------------

architecture arch of start_detector_tb is

  -- component ports
  signal clock        : std_logic :='0';
  signal reset        : std_logic;
  signal start_det_en : std_logic;
  signal d            : std_logic_vector(7 downto 0);
  signal start        : std_logic;


begin  -- architecture arch

  -- component instantiation
  DUT: entity work.start_detector
    port map (
      clock        => clock,
      reset        => reset,
      start_det_en => start_det_en,
      d            => d,
      start        => start);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
  d <= "11111111";
  wait for 30 ns;
  d <="00001111";
 
  end process WaveGen_Proc;

  

end architecture arch;

-------------------------------------------------------------------------------

configuration start_detector_tb_arch_cfg of start_detector_tb is
  for arch
  end for;
end start_detector_tb_arch_cfg;

-------------------------------------------------------------------------------
