-------------------------------------------------------------------------------
-- Title      : start detector
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : start_detector.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-11
-- Last update: 2020-12-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Start detector for UART RX
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

entity start_detector is
  port (
    clock        : in  std_logic;                     --clock
    reset        : in  std_logic;                     -- reset
    start_det_en : in  std_logic;                     --enable for voter reg
    d            : in  std_logic_vector(7 downto 0);  -- input
    start        : out std_logic                      --output
    );
end start_detector;

architecture arch of start_detector is
begin
  start : process (clock, reset) is
  begin  -- process vote
    if reset = '1' then                     -- asynchronous reset (active high)
      start <= '0';
    elsif clock'event and clock = '1' then  -- rising clock edge
      if start_det_en = '1' then
        start <= d and "00001111";
      end if;
    end if;
  end process start;


end architecture;