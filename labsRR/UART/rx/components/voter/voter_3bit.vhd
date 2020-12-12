-------------------------------------------------------------------------------
-- Title      : voter
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : voter_3bit.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-11
-- Last update: 2020-12-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Voter for UART
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

entity voter_3bit is
  port (
    clock    : in  std_logic;                     --clock
    reset    : in  std_logic;                     -- reset
    voter_en : in  std_logic;                     --enable for voter reg
    d        : in  std_logic_vector(2 downto 0);  -- input
    vote     : out std_logic                      --output
    );
end voter_3bit;

architecture arch of voter_3bit is
begin
  vote : process (clock, reset) is
  begin  -- process vote
    if reset = '1' then                     -- asynchronous reset (active high)
      vote <= '0';
    elsif clock'event and clock = '1' then  -- rising clock edge
      if voter_en = '1' then
        vote <= ((d(0) and (d(1) or d(2))) or ((d(1) and d(2))));
      end if;
    end if;
  end process vote;


end architecture;
