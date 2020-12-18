-------------------------------------------------------------------------------
-- Title      : rx_cu
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : rx_cu.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-16
-- Last update: 2020-12-18
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
    clr_start         : out std_logic;
    flag_error        : out std_logic;
    clear_c_shift     : out std_logic;
    clear_c_rxfull    : out std_logic;
    flag_rxfull       : in  std_logic;
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
  signal start_en_tmp              : std_logic;
  signal stop_en_tmp               : std_logic;
  type State_type is (idle, reset_s, sh_data, sh_sample, start_off, stop_on, res_cnt, error_s);
  signal present_state, next_state : State_type;

begin  -- architecture str

  state_update : process (clock, reset) is
  begin  -- process state_update
    if reset = '1' then                     -- asynchronous reset (active high)
      present_state <= reset_s;
    elsif clock'event and clock = '1' then  -- rising clock edge
      present_state <= next_state;
    end if;
  end process state_update;

  next_state_gen : process (flag_68, flag_rxfull, flag_shift_data,
                            flag_shift_sample, present_state, start,
                            start_en_tmp, stop) is
  begin  -- process next_state_gen
    case present_state is

      when reset_s =>
        next_state <= idle;

      when idle =>
        if flag_shift_data = '1' then
          if stop = '1' then
            next_state <= reset_s;
          else
            if flag_rxfull = '1' then
              next_state <= error_s;
            else
              next_state <= sh_data;
            end if;
          end if;
        elsif flag_shift_sample = '1' then
          next_state <= sh_sample;
        elsif flag_68 = '1' then
          if start = '1' then
            next_state <= res_cnt;
          else
            next_state <= sh_sample;
          end if;
        elsif start_en_tmp = '1' then
          if start = '1' then
            next_state <= start_off;
          else
            next_state <= idle;
          end if;
        end if;
        
      when error_s =>
        next_state <= reset_s;

      when sh_data =>
        next_state <= idle;

      when sh_sample =>
        if flag_rxfull = '1' then
          next_state <= stop_on;
        else
          next_state <= idle;
        end if;

      when start_off =>
        next_state <= idle;

      when res_cnt =>
        next_state <= idle;

      when stop_on =>
        next_state <= idle;

      when others => null;
    end case;
  end process next_state_gen;


--idle, idle_start, force_'1', force_0, load, shift
  output_decode : process (present_state) is
  begin  -- process output_decode
    count_en_sh     <= '0';
    count_en_rxfull <= '0';
    clear_c_rxfull  <= '0';
    clear_c_shift   <= '0';
    sh_en_data      <= '0';
    sh_en_samples   <= '0';
    flag_error      <= '0';
    clr_start       <= '0';
   
    
    case present_state is
      when reset_s =>
        stop_en_tmp     <= '0';
        start_en_tmp   <= '1';
        flag_error     <= '0';
        clear_c_rxfull <= '1';
        clear_c_shift  <= '1';
      when idle =>
        count_en_sh <= '1';
      when sh_data =>
        sh_en_data      <= '1';
        count_en_rxfull <= '1';
        sh_en_samples   <= '1';
      when error_s =>
        flag_error <= '1';
      when sh_sample =>
        sh_en_samples <= '1';
      when start_off =>
        clear_c_shift <= '1';
        start_en_tmp  <= '0';
      when stop_on =>
        stop_en_tmp     <= '1';
        count_en_rxfull <= '0';
      when res_cnt =>
        clear_c_shift <= '1';
        clr_start     <= '1';
      when others => null;
    end case;

  end process output_decode;

  start_en <= start_en_tmp;
  stop_en  <= stop_en_tmp;
end architecture str;

