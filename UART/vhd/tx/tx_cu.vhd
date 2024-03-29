-------------------------------------------------------------------------------
-- Title      : tx_cu
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : tx_cu.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2021-01-31
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: control unit for tx
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version  Author  Description
-- 2020-12-09   1.0      wackoz  Created
-- 2020-15-12   1.1      sabi    bug correction
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity tx_cu is

  port (
    clock            : in  std_logic;
    reset            : in  std_logic;
    term_count       : in  std_logic;   -- HIGH if counter output shift  == 139
    tx_enable : in std_logic;
    tx_empty         : out std_logic;   -- HIGH if tx is empty
    tx_empty_ack     : in  std_logic;
    tx_empty_dp      : in  std_logic;
     tc_flag_txempty : in std_logic;
    ld_en            : out std_logic;
    sh_en            : out std_logic;   -- enable for sr
    count_en_tc      : out std_logic;   -- enable for counter tc
    count_en_txempty : out std_logic;   -- enable for counter txempty    
    clear            : out std_logic;   -- clear for counters
    force_one        : out std_logic;
    force_zero       : out std_logic);
end entity tx_cu;

-------------------------------------------------------------------------------

architecture str of tx_cu is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  type State_type is (reset_s, idle, res_cnt, idle_start, force_0, load, shift,shift_stop,  stop);
  signal present_state, next_state : State_type;

begin  -- architecture str

  state_update : process (clock, reset) is
  begin  -- process state_update
    if reset = '0' then                     -- asynchronous reset (active low)
      present_state <= reset_s;
    elsif clock'event and clock = '1' then  -- rising clock edge
      present_state <= next_state;
    end if;
  end process state_update;

  next_state_gen : process (present_state, tx_enable, tc_flag_txempty, term_count,
                            tx_empty_ack, tx_empty_dp) is
  begin  -- process next_state_gen
    case present_state is

      when reset_s =>
        if tx_enable ='1' then
          if tx_empty_ack ='1' then
          next_state <= load;
        else
          next_state <=idle_start;
        end if;
          else
            next_state <= reset_s;
            end if;
        
      when idle_start =>
         if tx_enable = '0' then
          next_state <= reset_s;
        elsif tx_empty_ack = '1' then
          next_state <= load;
          end if;

      when load =>
        next_state <= force_0;

      when force_0 =>
        if term_count = '1' then
          next_state <= res_cnt;
        else
          next_state <= force_0;
        end if;

      when res_cnt =>
        next_state <= idle;

      when idle =>
        if tx_empty_dp = '1' then
          next_state <= stop;
        elsif term_count = '1' then
          next_state <= shift;
        else
          next_state <= idle;
        end if;

      when shift =>
        next_state <= idle;

      when stop =>
        if tc_flag_txempty='1' then
          next_state <= idle_start;
        elsif term_count = '1' then
          next_state <= shift_stop;
        else
          next_state <= stop;
        end if;
        
      when shift_stop =>
        next_state <= stop;
        

      when others => null;
    end case;
  end process next_state_gen;


  --idle, idle_start, force_1, force_0, load, shift
  output_decode : process (present_state) is
  begin  -- process output_decode
    ld_en            <= '0';
    sh_en            <= '0';
    force_one        <= '0';
    force_zero       <= '0';
    count_en_tc      <= '0';
    count_en_txempty <= '0';
    clear            <= '0';
    tx_empty <= '0';

    case present_state is
      when reset_s =>
        tx_empty <= '0';
      when idle_start =>
        tx_empty <='1';
        force_one <= '1';
      when load =>
        clear     <= '1';
        ld_en     <= '1';
        force_one <= '1';
      when res_cnt =>
        clear <= '1';
      when idle =>
        count_en_tc <= '1';
        sh_en       <= '0';
      when force_0 =>
        force_zero  <= '1';
        count_en_tc <= '1';
      when shift =>
        count_en_txempty <= '1';
        sh_en            <= '1';
        count_en_tc      <= '0';
      when stop =>
        force_one <= '1';
        count_en_tc <= '1';
      when shift_stop =>
        count_en_txempty <= '1';
        count_en_tc      <= '0';
        force_one <= '1';
 
    end case;
  end process output_decode;

 
end architecture str;

-------------------------------------------------------------------------------
