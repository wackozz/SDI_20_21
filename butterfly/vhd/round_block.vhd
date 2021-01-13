-------------------------------------------------------------------------------
-- Title      : round_block
-- Project    : 
-------------------------------------------------------------------------------
-- File       : round_block.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-29
-- Last update: 2021-01-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Round block for Butterfly
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-29  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity round_block is

  generic (
    N : integer := 20;
    M : integer := 41);

  port (
    reset : in  std_logic;
    clock : in  std_logic;
    A     : in  std_logic_vector(M-1 downto 0);
    Y     : out std_logic_vector(N-1 downto 0));

end entity round_block;

-------------------------------------------------------------------------------

architecture str of round_block is
  signal round_addend : signed(M-1 downto 0);
  signal zerofive     : std_logic_vector(M-3 downto 0);  --solo bit dopo la virgola
  signal  y_tmp        : signed(M-1 downto 0);
begin

  round_to_even : process (clock, reset) is
  begin  -- process round_to_even
    if reset = '0' then                 -- asynchronous reset (active low)
      y_tmp <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      if A(M-3 downto 0) = zerofive then  --controllo se parte decimale è pari
                                          --a 0.5
        y_tmp <= signed(A);
      else
        y_tmp <= signed(A)+round_addend;
      end if;
    end if;
  end process round_to_even;

  Y <=std_logic_vector(y_tmp(2*N-1 downto N));
  round_addend <= (N-1 => '1', others => '0');
  zerofive     <= (2   => '1', others => '0');
end architecture str;

-------------------------------------------------------------------------------
