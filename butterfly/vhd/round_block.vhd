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
    M : integer := 30);

  port (
    reset : in  std_logic;
    clock : in  std_logic;
    A     : in  std_logic_vector(M-1 downto 0);
    Y     : out std_logic_vector(N-1 downto 0));

end entity round_block;

-------------------------------------------------------------------------------

architecture str of round_block is
  signal round_addend : std_logic_vector(M-1 downto 0);
  signal zerofive     : std_logic_vector(M-3 downto 0);  --solo bit dopo la virgola
  signal y_tmp        : std_logic_vector(N-1 downto 0);
begin

  round_to_even : process (clock, reset) is
    variable round : std_logic_vector(M-1 downto 0);
  begin  -- process round_to_even
    if reset = '0' then                 -- asynchronous reset (active low)
      y_tmp <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      if A(M-3 downto 0) = zerofive then  --controllo se parte decimale è pari
                                          --a 0.5
        y_tmp <= A(N-1 downto 0);
      else
        round := std_logic_vector((signed(A) + signed(round_addend)));
        y_tmp <= round(N-1 downto 0);
      end if;
    end if;
  end process round_to_even;

  round_addend <= (N+1 => '1', others => '0');
  zerofive     <= (2   => '1', others => '0');
  Y            <= std_logic_vector(shift_right(signed(y_tmp), 1));
end architecture str;

-------------------------------------------------------------------------------
