-------------------------------------------------------------------------------
-- Title      : stop detector
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : stop_detector.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-11
-- Last update: 2020-12-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Stop detector for UART RX
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

entity stop_detector is
  port (
    clock       : in  std_logic;                     --clock
    reset       : in  std_logic;                     -- reset
    stop_det_en : in  std_logic;                     --enable for voter reg
    d           : in  std_logic_vector(7 downto 0);  -- input
    stop        : out std_logic                      --output
    );
end stop_detector;

architecture arch of stop_detector is
begin
  stop : process (clock, reset) is
  begin  -- process stop
    if reset = '1' then                     -- asynchronous reset (active high)
      stop <= '0';
    elsif clock'event and clock = '1' then  -- rising clock edge
      if stop_det_en = '1' then
        stop <= d and "11111111";
      end if;
    end if;
  end process stop;


end architecture;
