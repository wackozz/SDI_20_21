-------------------------------------------------------------------------------
-- Title      : rx_cu
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : rx_cu.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-16
-- Last update: 2020-12-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: CU for UART Receiver
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-16  1.0      wackoz  Created
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity rx_cu is

  port (
    clock             : in  std_logic;
    reset             : in  std_logic;
    clear_c_shift     : out std_logic;
    clear_c_rxfull    : out std_logic;
    flag_rxfull       : in  std_logic;
    flag_shift_data   : in  std_logic;
    flag_shift_sample : in  std_logic;
    flag_68           : in  std_logic;
    rxd               : out std_logic;
    voter_en          : out std_logic;
    sh_en_samples     : out std_logic;
    sh_en_data        : out std_logic;
    ld_en_samples     : out std_logic;
    ld_en_data        : out std_logic;
    start_en          : out std_logic;
    start             : in  std_logic;
    stop_en           : out std_logic;
    stop              : in  std_logic;
    count_en_sh       : out std_logic;
    count_en_rxfull   : out std_logic;
    Pout              : in  std_logic_vector(7 downto 0));

end entity rx_cu;

------------------------------------------------  -------------------------------

architecture str of rx_cu is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  type State_type is (idle, idle_start, reset, sh_data, sh_sample, start_off, stop_en, res_cnt, error_on);
  signal present_state, next_state : State_type;

begin  -- architecture str

  state_update : process (clock, reset) is
  begin  -- process state_update
    if reset = '1' then                     -- asynchronous reset (active high)
      present_state <= reset;
    elsif clock'event and clock = '1' then  -- rising clock edge
      present_state <= next_state;
    end if;
  end process state_update;

  next_state_gen : process (present_state, term_count, tx_empty) is
  begin  -- process next_state_gen
    case present_state is

      when reset =>
        next_state <= idle;

      when idle =>
        if flag_shift_data = 1 then
          if stop = 1 then
            next_state <= reset;
          else
            if rx_full = 1 then
              next_state <= error_s;
            else
              next_state <= sh_data;
            end if;
          end if;
        elsif flag_shift_sample = 1 then
          next_state <= sh_sample;
        else
          next_state <= idle;
        end if;

      when error_s =>
        next_state <= reset;

      when sh_data =>
        next_state <= idle;

        when sh_sample
        if start_en = 1 then
          if start = 1 then
            next_state <= start_off;
          else
            next_state <= idle;
          end if;
        else
          if flag_rxfull = 1 then
            next_state <= stop_en;
          else
            next_state <= idle;
          end if;
        end if;

      when start_off =>
        next_state <= idle_2;

      when idle_2 =>
        if flag_68 = 1 then
          next_state <= res_cnt;
        else
          next_state <= idle_2;
        end if;

      when res_cnt =>
        next_state <= idle;

      when stop_en =>
        next_state <= idle;

      when others => null;
    end case;
  end process next_state_gen;


--idle, idle_start, force_1, force_0, load, shift
  output_decode : process (present_state) is
  begin  -- process output_decode
    case present_state is
      when idle =>
        force_one <= '1';
      when load =>
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
    end case;
  end process output_decode;

end architecture str;
