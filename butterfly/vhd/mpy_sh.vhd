-------------------------------------------------------------------------------
-- Title      : mpy_sh
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mpy_sh.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-23
-- Last update: 2021-01-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Blocco moltiplicazioni e shift
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-23  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity mpy_sh is

  generic (
    N : integer := 3);

  port (
    --I/O
    clock  : in  std_logic;
    reset  : in  std_logic;
    A      : in  std_logic_vector(N-1 downto 0);  -- ingresso per le operazioni di shift
    B      : in  std_logic_vector(N-1 downto 0);  -- secondo ingresso
    Y      : out std_logic_vector(2*N-1 downto 0);  -- uscita
    -- CONTROLLI
    sh_mpy : in  std_logic);            -- sh = low, mpy = high


end entity mpy_sh;

-------------------------------------------------------------------------------

architecture str of mpy_sh is
  signal y_sh : std_logic_vector(N downto 0);
  signal zeros : std_logic_vector(N-2 downto 0);
-----------------------------------------------------------------------------
-- Internal signal declarations
-----------------------------------------------------------------------------
begin  -- architecture str
  
    y_sh <= std_logic_vector(shift_left(resize(signed(A), y_sh'length),1));
  sh_mpy_pro : process(clock, reset, sh_mpy) is
  begin  -- process sh_mpy_pro
    if reset = '0' then
      Y <= (others => '0');
    elsif clock'event and clock = '1' then
      if sh_mpy = '1' then
        Y <= std_logic_vector(signed(A)*signed(B));  --A*B (mpy)
      else
        Y <= y_sh&zeros;                                   --A*2 (sh)
      end if;
    end if;
  end process sh_mpy_pro;

   zeros <= (others => '0');

end architecture str;

-------------------------------------------------------------------------------
