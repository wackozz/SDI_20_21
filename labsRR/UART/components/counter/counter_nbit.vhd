-------------------------------------------------------------------------------
-- Title      : counter_nbit
-- Project    : Source files in a directory tree, multiple compilers in same directory
-------------------------------------------------------------------------------
-- File       : counter_nbit.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-08
-- Last update: 2020-12-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- This is a multi-line project description
-- that can be used as a project dependent part of the file header.
-------------------------------------------------------------------------------
-- Description: Simple n-bit counter
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-08  1.0      wackoz  Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_nbit is

  generic (
    N : integer := 3
    );                                  --

  port (
    clock : in  std_logic;
    clear : in  std_logic;
    en    : in  std_logic;
    ld    : in  std_logic;
    d     : in  std_logic_vector(N-1 downto 0);  -- in
    q     : out std_logic_vector(N-1 downto 0)   -- out
    );
end entity counter_nbit;

architecture arch of counter_nbit is

  signal data : unsigned(N-1 downto 0);
begin
  counter_pro : process (clock) is
  begin  -- process counter
    if clock'event and clock = '1' then  -- rising clock edge
    if clear = '1' then                     -- sync clear (active high)
      data <= (others => '0');
     else     
    if en = '1' then
        data <= data+1;
      end if;
      if ld = '1' then
        data <= unsigned(d);
      end if;
    end if;
end if;
  end process counter_pro;

  q <= std_logic_vector(data);

end architecture arch;
