-------------------------------------------------------------------------------
-- Title      : rx_cu
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : rx_cu.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-16
-- Last update: 2021-01-07
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: CU for UART Receiver
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2020-12-16  1.0      wackoz          Created
-- 2021-01-07  2.0      wackoz,sabi     v2, rm interferred latches
-------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity rx_cu is

  port (
    clock             : in  std_logic;
    reset             : in  std_logic;
    clr_start         : out std_logic;
    flag_error        : out std_logic;
    clear_c_shift     : out std_logic;
    clear_c_rxfull    : out std_logic;
    flag_rxfull       : in  std_logic;
    rx_full           : out std_logic;
    ld_en             : out std_logic;  --load enable for shift_registers init.
    flag_shift_data   : in  std_logic;
    flag_shift_sample : in  std_logic;
    flag_68           : in  std_logic;
    sh_en_samples     : out std_logic;
    sh_en_data        : out std_logic;
    start_en          : out std_logic;
    start             : in  std_logic;
    stop_en           : out std_logic;
    stop              : in  std_logic;
    count_en_sh       : out std_logic;
    count_en_rxfull   : out std_logic);

end entity rx_cu;

------------------------------------------------  -------------------------------

architecture str of rx_cu is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  type State_type is (idle_start_on, idle_start_off, reset_s, wait_tc_flag_68, sh_data, sh_sample_start_on, sh_sample_start_off, sh_smp_rxfull, start_en_off, res_cnt, rxfull_s, error_s);
  signal next_state : State_type;
begin  -- architecture str


  next_state_gen : process (clock, reset) is
  begin  -- process next_state_gen

    if reset = '0' then                     -- asynchronous reset (active low)
      next_state <= reset_s;
    elsif clock'event and clock = '1' then  -- rising clock edge

      case next_state is
        when reset_s => next_state <= idle_start_on;

        when idle_start_on =>
          if start = '0' then
            if flag_shift_sample = '0' then
              next_state <= idle_start_on;
            else
              next_state <= sh_sample_start_on;
            end if;
          else
            next_state <= start_en_off;
          end if;

        when idle_start_off =>
          if flag_shift_sample = '0' then
            if flag_shift_data = '0' then
              next_state <= idle_start_off;
            else
              if flag_rxfull = '0' then
                next_state <= sh_data;
              else
                next_state <= sh_smp_rxfull;
              end if;
            end if;
          else
            next_state <= sh_sample_start_off;
          end if;

        when res_cnt => next_state <= idle_start_off;

        when start_en_off => next_state <= wait_tc_flag_68;

        when wait_tc_flag_68 =>
          if flag_68 = '0' then
            next_state <= wait_tc_flag_68;
          else
            next_state <= res_cnt;
          end if;

        when sh_sample_start_on  => next_state <= idle_start_on;
        when sh_sample_start_off => next_state <= idle_start_off;
        when sh_data             => next_state <= idle_start_off;
        when sh_smp_rxfull =>
          if stop = '0' then
            next_state <= error_s;
          else
            next_state <= rxfull_s;
          end if;
        when error_s => next_state <= reset_s;

        when rxfull_s => next_state <= reset_s;

        when others => null;
      end case;
    end if;
  end process next_state_gen;


--idle, idle_start, force_'1', force_0, load, shift
  output_decode : process (next_state) is
  begin  -- process output_decode
    count_en_sh     <= '0';
    count_en_rxfull <= '0';
    clear_c_rxfull  <= '0';
    clear_c_shift   <= '0';
    sh_en_data      <= '0';
    sh_en_samples   <= '0';
    flag_error      <= '0';
    clr_start       <= '0';
    ld_en           <= '0';
    stop_en         <= '1';
    start_en        <= '0';
    rx_full         <= '0';

    case next_state is
      when idle_start_on =>
        count_en_sh <= '1';
        start_en    <= '1';
      when idle_start_off =>
        count_en_sh <= '1';
        start_en    <= '0';
      when reset_s =>
        ld_en          <= '1';
        clear_c_shift  <= '1';
        clear_c_rxfull <= '1';
        start_en       <= '1';
      when wait_tc_flag_68 =>
        count_en_sh <= '1';
      when sh_data =>
        sh_en_data      <= '1';
        count_en_rxfull <= '1';
        sh_en_samples   <= '1';
      when sh_sample_start_off =>
        sh_en_samples <= '1';
      when sh_sample_start_on =>
        sh_en_samples <= '1';
        start_en      <= '1';
      when sh_smp_rxfull =>
        sh_en_samples <= '1';
      when start_en_off =>
        start_en      <= '0';
        clear_c_shift <= '1';
      when res_cnt =>
        clear_c_rxfull <= '1';
        clear_c_shift  <= '1';
        clr_start      <= '1';
      when rxfull_s =>
        rx_full <= '1';
      when error_s =>
        flag_error <= '1';
      when others => null;
    end case;

  end process output_decode;
end architecture str;
