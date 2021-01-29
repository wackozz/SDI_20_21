-------------------------------------------------------------------------------
-- Title      : adder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : adder.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-26
-- Last update: 2021-01-29
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
    clock   : in  std_logic;
    reset   : in  std_logic;
    add_sub : in  std_logic_vector(1 downto 0);
    A       : in  std_logic_vector(N-1 downto 0);
    B       : in  std_logic_vector(N-1 downto 0);
    Y       : out std_logic_vector(N downto 0));

end entity adder;

-------------------------------------------------------------------------------

architecture str of adder is
  component mux4to1 is
    generic (
      N : integer);
    port (
      S  : in  std_logic_vector(1 downto 0);
      D1 : in  std_logic_vector(N-1 downto 0);
      D2 : in  std_logic_vector(N-1 downto 0);
      D3 : in  std_logic_vector(N-1 downto 0);
      D4 : in  std_logic_vector(N-1 downto 0);
      Y  : out std_logic_vector(N-1 downto 0));
  end component mux4to1;

  signal y_tmp      : std_logic_vector(N downto 0);
  signal D1, D2, D3 : std_logic_vector(N downto 0);
begin
  sum : process (clock, reset) is
  begin  -- process sum
    if reset = '0' then                     -- asynchronous reset (active low)
      Y <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      Y <= Y_tmp;
    end if;
  end process sum;

  -- instance "mux4to1_1"
  mux4to1_1 : mux4to1
    generic map (
      N => N+1)
    port map (
      S  => add_sub,
      D1 => D1,
      D2 => D2,
      D3 => D3,
      D4 => D3,
      Y  => Y_tmp);

      D1 <=  std_logic_vector(resize(signed(A), N+1)+resize(signed(B), N+1));
      D2 <=  std_logic_vector(resize(signed(A), N+1)+resize(signed(B), N+1));
      D3 <=  std_logic_vector(resize(signed(A), N+1)+resize(signed(B), N+1));
end architecture str;



-------------------------------------------------------------------------------
