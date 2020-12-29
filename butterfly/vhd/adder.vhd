-------------------------------------------------------------------------------
-- Title      : adder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adder.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-26
-- Last update: 2020-12-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: adder/subtractor Nbit
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-26  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity adder is

  generic (
    N : integer := 4);

  port (
    add_sub : in  std_logic;
    A       : in  std_logic_vector(N-1 downto 0);
    B       : in  std_logic_vector(N-1 downto 0);
    Y       : out std_logic_vector(N downto 0));

end entity adder;

-------------------------------------------------------------------------------

architecture str of adder is

begin
  Y <= std_logic_vector(signed(A)+signed(B)) when add_sub = '0' else std_logic_vector(signed(A)-signed(B));

end architecture str;

-------------------------------------------------------------------------------
