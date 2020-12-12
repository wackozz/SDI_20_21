-------------------------------------------------------------------------------
-- Title      : voter tb
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : tb_voter.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-11
-- Last update: 2020-12-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Voter TB for UART RX
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-11  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_voter is
end testbench_voter;

architecture BEH of testbench_voter is
  signal vote : std_logic;
  signal d    : std_logic_vector(2 downto 0);

  component voter_3bit is
    port (
      d    : in  std_logic_vector(2 downto 0);  -- input
      vote : out std_logic                      --output
      );
  end component;

begin

  inst1 : voter_3bit port map(
    vote => vote,
    d    => d
    );
end architecture;
