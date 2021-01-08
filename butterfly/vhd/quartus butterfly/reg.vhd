-------------------------------------------------------------------------------
-- Title      : reg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : register.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-30
-- Last update: 2020-12-30
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: N bit register for butterfly
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-30  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity reg is

  generic (N : integer := 8);

  port (D : in std_logic_vector(N-1 downto 0);

        clock, reset, enable : in std_logic;

        Q : out std_logic_vector(N-1 downto 0));

end reg;

-------------------------------------------------------------------------------

architecture str of reg is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  register_proc : process (clock, reset) is
  begin  -- process register_proc
    if reset = '0' then                     -- asynchronous reset (active low)
      Q <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      if enable = '1' then
        Q <= D;
      end if;
    end if;
  end process register_proc;

end architecture str;

-------------------------------------------------------------------------------
