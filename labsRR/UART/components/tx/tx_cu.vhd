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

  port (
    clock : in std_logic;
    reset : in std_logic;

    ld_en      : out std_logic;
    sh_en      : out std_logic;         -- enable for sr
    count_en   : out std_logic;         -- enable for counter
    term_count : in  std_logic;         -- HIGH if counter output shift  == 139
    tx_empty   : in  std_logic;         -- HIGH if counter output txempty == 7

    force_one  : out std_logic;
    force_zero : out std_logic);
end entity tx_cu;

-------------------------------------------------------------------------------

architecture str of tx_cu is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  type State_type is (idle, idle_start, force_1, force_0, load, shift);
  signal present_state, next_state : State_type;

begin  -- architecture str

  state_update : process (clock, reset) is
  begin  -- process state_update
    if reset = '0' then                     -- asynchronous reset (active low)
      present_state <= load;
    elsif clock'event and clock = '1' then  -- rising clock edge
      present_state <= next_state;
    end if;
  end process state_update;

  next_state_gen : process (present_state, term_count, tx_empty) is
  begin  -- process next_state_gen
    case present_state is

      when idle_start =>
        if tx_empty = '1' then
          next_state <= idle_start;
        else
          next_state <= load;
        end if;

      when load =>
        next_state <= force_1;

      when force_1 =>
        if term_count = '1' then
          if tx_empty = '1' then
            next_state <= load;
          else
            next_state <= force_0;
          end if;
        else
          next_state <= force_1;
        end if;

      when force_0 =>
        if term_count = '1' then
          next_state <= idle;
        else
          next_state <= force_0;
        end if;

      when idle =>
        if term_count = '1' then
          next_state <= shift;
        else
          next_state <= idle;
        end if;

      when shift =>
        if tx_empty = '1' then
          next_state <= force_1;
        else
          next_state <= idle;
        end if;

      when others => null;
    end case;
  end process next_state_gen;


  --idle, idle_start, force_1, force_0, load, shift
  output_decode : process (present_state) is
  begin  -- process output_decode
    case present_state is
      when load =>
        ld_en <= '1';
      when force_1 =>
        force_one <= '1';
        count_en <= '1';
      when force_0 =>
        force_zero <= '1';
        count_en <= '1';
      when shift =>
        sh_en  <= '1';
        count_en <= '1';
      when others =>
        ld_en <= '0';
        sh_en <= '0';
        force_one <= '0';
        force_zero <= '0';
        count_en <= '0';
    end case;
  end process output_decode;

end architecture str;

-------------------------------------------------------------------------------
