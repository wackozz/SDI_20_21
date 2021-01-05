-------------------------------------------------------------------------------
-- Title      : shift_register_8bit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : shift_register_8bit.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2021-01-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Generic 8 bit shift register with parallel load
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-11  1.0      wackoz  Created
-------------------------------------------------------------------------------
c

  library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register_8bit is
  port (
    clock : in  std_logic;                     --clock
    --controls
    sh_en : in  std_logic;                     --shift enable
    ld_en : in  std_logic;                     --load enable
    --input
    s_in  : in  std_logic;                     -- serial in
    s_out : out std_logic;                     -- serial out
    --output
    p_in  : in  std_logic_vector(7 downto 0);  -- parallel in
    p_out : out std_logic_vector(7 downto 0)   -- parallel out
    );
end shift_register_8bit;

architecture arch of shift_register_8bit is

  signal data : std_logic_vector(7 downto 0);
begin
  s_out <= data(7);
  p_out <= data;

  load : process (clock)
  begin

    if (rising_edge(clock)) then
      if ld_en = '1' then
        data <= p_in;
      end if;
      if sh_en = '1' then
        data(0) <= s_in;
        for i in 1 to 7 loop
          data(i) <= data(i - 1);
        end loop;
      end if;
    end if;
  end process;  -- load

end architecture;
