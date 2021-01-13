-------------------------------------------------------------------------------
-- Title      : mux4to1
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mux4to1.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-30
-- Last update: 2021-01-12
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

  process (D1, D2, D3, D4, S) is
  begin
    if (S(0) = '0' and S(1) = '0') then
      Y <= D1;
    elsif (S(0) = '1' and S(1) = '0') then
      Y <= D2;
    elsif (S(0) = '0' and S(1) = '1') then
      Y <= D3;
    else
      Y <= D4;
    end if;

  end process;
end architecture str;
-------------------------------------------------------------------------------
