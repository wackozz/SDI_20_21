-------------------------------------------------------------------------------
-- Title      : butterfly_dp
-- Project    : 
-------------------------------------------------------------------------------
-- File       : butterfly_dp.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-23
-- Last update: 2020-12-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Datapath Butterfly
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-23  1.0      wackoz  Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity butterfly_dp is

  port (
    clock : in std_logic;
    reset : in std_logic;
    Wr : in std_logic_vector(19 downto 0);
    Wi : std_logic_vector(19 downto 0);
    Aj : std_logic_vector(19 downto 0);
    Ar : std_logic_vector(19 downto 0);
    Bj : std_logicc_vector(19 downto 0);
    Br : std_logic_vector(19 downto 0));

end entity butterfly_dp;

-------------------------------------------------------------------------------

architecture str of butterfly_dp is

  -----------------------------------------------------------------------------
  -- Dichiarazione segnali interni
  -----------------------------------------------------------------------------

  signal N       : integer := 20;       -- paralellismo
  signal mpy_out : std_logic_vector(2*N-1 downto 0);
  signal add_out : std_logic_vector(N downto 0);
  signal add_A   : std_logic_vector(30 downto 0);
  signal add_B   : std_logic_vector(30 downto 0);
  signal mpy_A   : std_logic_vector(30 downto 0);
  signal mpy_A   : std_logic_vector(30 downto 0);

  -----------------------------------------------------------------------------
  -- Dichiarazione component
  -----------------------------------------------------------------------------

  component mpy_sh is
    generic (
      N : integer);
    port (
      A      : in  std_logic_vector(N-1 downto 0);
      B      : in  std_logic_vector(N-1 downto 0);
      Y      : out std_logic_vector(2*N-1 downto 0);
      sh_mpy : in  std_logic);
  end component mpy_sh;

  component adder is
    generic (
      N : integer);
    port (
      add_sub : in  std_logic;
      A       : in  std_logic_vector(N-1 downto 0);
      B       : in  std_logic_vector(N-1 downto 0);
      Y       : out std_logic_vector(N downto 0));
  end component adder;

begin  -- architecture str

  butterfly : process (clock, reset) is
  begin  -- process butterfly
    if reset = '0' then                 -- asynchronous reset (active low)

    elsif clock'event and clock = '1' then  -- rising clock edge
      mpy_out <= and
    end if;
  end process butterfly;
  -----------------------------------------------------------------------------
  -- Component 
  -----------------------------------------------------------------------------
  -- Dichiarazione component
  -----------------------------------------------------------------------------

  component mpy_sh is
    generic (
      N : integer);
    port (
      A      : in  std_logic_vector(N-1 downto 0);
      B      : in  std_logic_vector(N-1 downto 0);
      Y      : out std_logic_vector(2*N-1 downto 0);
      sh_mpy : in  std_logic);
  end component mpy_sh;

  component adder is
    generic (
      N : integer);
    port (
      add_sub : in  std_logic;
      A       : in  std_logic_vector(N-1 downto 0);
      B       : in  std_logic_vector(N-1 downto 0);
      Y       : out std_logic_vector(N downto 0));
  end component adder;

  begin  -- architecture str

    butterfly : process (clock, reset) is
    begin  -- process butterfly
      if reset = '0' then               -- asynchronous reset (active low)

      elsif clock'event and clock = '1' then  -- rising clock edge
        mpy_out
      end if;
    end process butterfly;
    -----------------------------------------------------------------------------
    -- Component mapping
    -----------------------------------------------------------------------------

    mpy_sh_1 : mpy_sh
      generic map (
        N => N)
      port map (
        A      => A,
        B      => B,
        Y      => Y,
        sh_mpy => sh_mpy);

    -- instance "adder_1"
    adder_1 : adder
      generic map (
        N => N)
      port map (
        add_sub => add_sub,
        A       => A,
        B       => B,
        Y       => Y);


  end architecture str;

-------------------------------------------------------------------------------