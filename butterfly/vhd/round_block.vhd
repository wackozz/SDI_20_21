-------------------------------------------------------------------------------
-- Title      : round_block
-- Project    : 
-------------------------------------------------------------------------------
-- File       : round_block.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-29
-- Last update: 2021-02-12
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
    M : integer := 40);                 --generic non implementato

  port (
    reset : in  std_logic;
    clock : in  std_logic;
    A     : in  std_logic_vector(39 downto 0);
    Y     : out std_logic_vector(19 downto 0));

end entity round_block;

-------------------------------------------------------------------------------

architecture str of round_block is
  signal round_addend : signed(21 downto 0);  --dimensione bit da scartare
  signal zerofive     : std_logic_vector(18 downto 0);  --metà dinamica dei
                                                        --bit da scartare
  signal y_tmp        : signed(21 downto 0);
begin

  round_to_even : process (clock, reset) is
  begin  -- process round_to_even
    if reset = '0' then                 -- asynchronous reset (active low)
      y_tmp <= (others => '0');
    elsif clock'event and clock = '1' then                -- rising clock edge
      if A(18 downto 0) = zerofive then  --controllo se parte decimale è
                                         --esattamente a metà della dinamica
        if(A(19) = '0') then
          --se il numero binario è pari
          y_tmp <= signed(A(39 downto 18));               --pari
        else
          y_tmp <= signed(A(39 downto 18))+round_addend;  --dispari
        end if;
      else
        y_tmp <= signed(A(39 downto 18))+round_addend;
      end if;
    end if;
  end process round_to_even;

  Y            <= std_logic_vector(resize(y_tmp(21 downto 2), 20));  --bit
                                                                     --extension, scalamento
  round_addend <= (0  => '1', others => '0');
  zerofive     <= (18 => '1', others => '0');
end architecture str;

-------------------------------------------------------------------------------
