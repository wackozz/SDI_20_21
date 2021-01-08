-------------------------------------------------------------------------------
-- Title      : UART
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-07
-- Last update: 2021-01-07
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: UART
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-07  1.0      wackoz	Created
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Title      : Uart
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : uart.vhd


library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity uart is

  port (
    clock  : in  std_logic;
    reset  : in  std_logic;
    RxD    : in  std_logic;
    TxD    : out std_logic;
    Dout   : out std_logic_vector(7 downto 0);
    Din    : in  std_logic_vector(7 downto 0);
    ATN    : out std_logic;
    ATNACK : in  std_logic;
    ADD    : in  std_logic_vector(2 downto 0);
    R_Wn   : in  std_logic;
    CS     : in  std_logic
    );

end uart;

-------------------------------------------------------------------------------

architecture str of uart is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal p_in         : std_logic_vector(7 downto 0);
  signal tx_empty_ack : std_logic;
  signal rx_full      : std_logic;
  signal flag_error   : std_logic;
  signal Pout         : std_logic_vector(7 downto 0);
  signal TX_out       : std_logic_vector(7 downto 0);
  signal RX_in        : std_logic_vector(7 downto 0);
  signal tx_empty     : std_logic;
  signal TX_ACK       : std_logic;
  signal RX_ENABLE    : std_logic;
  signal TX_ENABLE    : std_logic;
  signal CLRatn       : std_logic;
  signal SEL_MUX      : std_logic;
  signal FF_IN        : std_logic_vector(2 downto 0);
  signal FF_OUT       : std_logic_vector(2 downto 0);
  signal ENABLE_FF    : std_logic_vector(2 downto 0);
  signal FF_IN_tmp    : std_logic_vector(2 downto 0);


  component tx is
    port (
      clock        : in  std_logic;
      reset        : in  std_logic;
      p_in         : in  std_logic_vector(7 downto 0);
      TxD          : out std_logic;
      tx_empty     : out std_logic;
      tx_empty_ack : in  std_logic);
  end component tx;



  component rx is
    port (
      clock      : in  std_logic;
      reset      : in  std_logic;
      rxD        : in  std_logic;
      rx_full    : out std_logic;
      flag_error : out std_logic;
      Pout       : out std_logic_vector(7 downto 0));
  end component rx;


  component bus_interfaceDP is
    port (
      CLOCK                : in     std_logic;
      RESET                : in     std_logic;
      Dout                 : out    std_logic_vector(7 downto 0);
      TX_out               : out    std_logic_vector(7 downto 0);
      RX_in, Din           : in     std_logic_vector (7 downto 0);
      ADD                  : in     std_logic_vector (2 downto 0);
      R_Wn                 : in     std_logic;
      CS                   : in     std_logic;
      ATNack               : in     std_logic;
      ATN                  : out    std_logic;
      TX_ACK               : out    std_logic;
      RX_ENABLE, TX_ENABLE : buffer std_logic;
      CLRatn               : buffer std_logic;
      SEL_MUX              : buffer std_logic;
      FF_IN                : in     std_logic_vector(2 downto 0);
      ENABLE_FF            : buffer std_logic_vector(2 downto 0);
      FF_OUT               : out    std_logic_vector(2 downto 0));
  end component bus_interfaceDP;


begin

  trasmettitore : tx port map (
    clock        => clock,
    reset        => reset,
    p_in         => TX_out,
    tx_empty_ack => TX_ACK,             --vedi bene
    tx_empty     => tx_empty,
    TxD          => TxD);

  ricevitore : rx port map (
    clock      => clock,
    reset      => reset,
    rxD        => RxD,
    rx_full    => rx_full,
    flag_error => flag_error,
    Pout       => Pout);

  bus_interface : bus_interfaceDP port map (
    Dout      => Dout,
    TX_out    => TX_out,
    RX_in     => Pout,
    Din       => Din,
    ADD       => ADD,
    R_Wn      => R_Wn,
    CS        => CS,
    ATNack    => ATNACK,
    RESET     => reset,
    CLOCK     => clock,
    ATN       => ATN,
    TX_ACK    => TX_ACK,
    RX_ENABLE => RX_ENABLE,
    TX_ENABLE => TX_ENABLE,
    CLRatn    => CLRatn,
    SEL_MUX   => SEL_MUX,
    FF_IN     => FF_IN_tmp,             --FF_IN(0)=RX_full, FF_IN(1)=TX_empty,
    --FF_IN(2)=error; registro di stato
    FF_OUT    => FF_OUT);



  FF_IN_tmp <= (rx_full)&(tx_empty)&(flag_error);


end architecture str;

-------------------------------------------------------------------------------
