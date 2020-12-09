-------------------------------------------------------------------------------
-- Title      : tx_cu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tx_cu.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2020-12-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: control unit for tx
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-09  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity tx_cu is

  generic (
    );

  port (
    clock : in std_logic;
    reset : in std_logic;

    sh_en      : out std_logic;         -- enable for sr
    count_en   : out std_logic;         -- enable for counter
    term_count : in  std_logic);        -- HIGH if counter output == 7

end entity tx_cu;

-------------------------------------------------------------------------------

architecture str of tx_cu is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  type State_type is (A,B,C);
  signal present_state, next_state : State_type;

begin  -- architecture str

  next_state_gen : process (w, present_state) is
  begin  -- process next_state_gen
  --case present_state is
  --when A =>
  -- if ...
  end process next_state_gen;

  state_update : process (clock, reset) is
  begin  -- process state_update
  
  end process state_update;
  
end architecture str;

-------------------------------------------------------------------------------
