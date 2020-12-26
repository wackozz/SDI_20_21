-------------------------------------------------------------------------------
-- Title      : mpy_sh
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mpy_sh.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-23
-- Last update: 2020-12-26
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
    A      : in  std_logic_vector(N-1 downto 0);  -- ingresso per le operazioni di shift
    B      : in  std_logic_vector(N-1 downto 0);  -- secondo ingresso
    Y      : out std_logic_vector(2*N-1 downto 0);  -- uscita
    -- CONTROLLI
    sh_mpy : in  std_logic);            -- sh = low, mpy = high


end entity mpy_sh;

-------------------------------------------------------------------------------

architecture str of mpy_sh is
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
begin  -- architecture str
  sh_mpy_pro : process(sh_mpy) is
  begin  -- process sh_mpy_pro
    if sh_mpy = '1' then
      Y <= std_logic_vector(signed(A)*signed(B));       --A*B (mpy)
    else
      Y <= std_logic_vector(resize(shift_left(signed(A), 1),Y'length));  --A*2 (sh)
    end if;

  end process sh_mpy_pro;
end architecture str;

-------------------------------------------------------------------------------
