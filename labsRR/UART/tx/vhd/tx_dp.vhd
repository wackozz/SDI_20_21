-------------------------------------------------------------------------------
-- Title      : tx datapath
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tx_dp.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2020-12-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: transmitter for UART project
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-09  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_dp is

  port (
    clock      : in  std_logic;
    reset      : in  std_logic;
    force_one  : in  std_logic;
    force_zero : in  std_logic;
    tx_empty_ack: in std_logic;
    --counter
    count_en   : in  std_logic;
    tx_empty   : out std_logic;
    term_count : out std_logic;
    --shift r
    p_in       : in  std_logic_vector(7 downto 0);  --input (SR)
    ld_en      : in  std_logic;                     -- paraellel load shift reg
    sh_en      : in  std_logic;                     -- shift reg shift en
    TxD        : out std_logic                      --output
    );

end entity tx_dp;

architecture arch of tx_dp is
  --signal declaration

  --counter
  constant N            : integer := 8;
  signal ld             : std_logic := '0';  --parallel load for counter                   
  signal term_count_bus : std_logic;
  signal d              : std_logic_vector(N-1 downto 0);
  signal q_txempty      : std_logic_vector(N-1 downto 0);
  signal q_c_shift      : std_logic_vector(N-1 downto 0);
  --register
  signal s_in           : std_logic := '1';
  signal s_out          : std_logic;
  signal p_out          : std_logic_vector(7 downto 0);


  -- component inst

  component counter_nbit is
    generic (
      N : integer);
    port (
      clock : in  std_logic;
      clear : in  std_logic;
      tc  : in  std_logic_vector(N-1 downto 0);
      en    : in  std_logic;
      ld    : in  std_logic;
      d     : in  std_logic_vector(N-1 downto 0);
      q     : out std_logic_vector(N-1 downto 0));
  end component counter_nbit;

  component shift_register_8bit is
    port (
      clock : in  std_logic;
      ld_en : in  std_logic;
      sh_en : in  std_logic;
      s_in  : in  std_logic;
      s_out : out std_logic;
      p_in  : in  std_logic_vector(N-1 downto 0);
      p_out : out std_logic_vector(N-1 downto 0));
  end component shift_register_8bit;

begin  -- architecture arch

  --port map: shift register

  shift_reg : shift_register_8bit
    port map (
      clock => clock,
      ld_en => ld_en,
      sh_en => sh_en,
      s_in  => s_in,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out
      );
  -- port map: counter

  counter_shift : counter_nbit
    generic map (N => N)
    port map (
      clock => clock,
      clear => reset,
      tc    => std_logic_vector(to_unsigned(139,N)),
      en    => count_en,
      ld    => ld,
      d     => d,
      q     => q_c_shift
      );

  counter_txempty : counter_nbit
    generic map (N => N)
    port map (
      clock => clock,
      clear => reset,
      tc    => std_logic_vector(to_unsigned(7,N)),
      en    => term_count_bus,
      ld    => ld,
      d     => d,
      q     => q_txempty
      );


  terminal_counter : process (clock, reset) is
  begin  -- process terminal_counter

    if reset = '1' then
      tx_empty   <= '1';  -- important to set tx_empty to 1 during idle stage
      term_count_bus <= '0';
    elsif clock'event and clock = '1' then  -- rising clock edge
      if tx_empty_ack = '1' then
	tx_empty <= '0';
       end if;
      if(unsigned(q_c_shift) = 139) then
        term_count_bus <= '1';
      else
        term_count_bus <= '0';
      end if;

      if unsigned(q_txempty) = 7 then
        tx_empty <= '1';
      else
        tx_empty <= '0';
      end if;
    end if;
  end process terminal_counter;

  --TxD        <= s_out and not(force_zero) and force_one;
  TxD        <= (force_one and not(force_zero)) or (s_out and force_zero);
  term_count <= term_count_bus;
end architecture arch;
