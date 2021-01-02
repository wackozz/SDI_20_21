-------------------------------------------------------------------------------
-- Title      : mux4to1
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mux4to1.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-30
-- Last update: 2020-12-30
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: MUX 4 to 1
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-30  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity mux4to1 is

  generic (
    N : integer := 2
    );

  port (
    S  : in  std_logic_vector(1 downto 0);    --mux selector
    D1 : in  std_logic_vector(N-1 downto 0);  --D1
    D2 : in  std_logic_vector(N-1 downto 0);  --D2
    D3 : in  std_logic_vector(N-1 downto 0);  --D3
    D4 : in  std_logic_vector(N-1 downto 0);  --D4
    Y  : out std_logic_vector(N-1 downto 0)   --OUT
    );

end entity mux4to1;

-------------------------------------------------------------------------------

architecture str of mux4to1 is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  with S select
    Y <=
    D1 when "00",
    D2 when "01",
    D3 when "10",
    D4 when "11";
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
