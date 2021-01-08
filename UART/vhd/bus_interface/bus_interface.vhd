library ieee;
use ieee.std_logic_1164.all;

entity BUS_INTERFACE is
  port (Dout                 : out std_logic_vector (7 downto 0);
        TX_out               : out std_logic_vector (7 downto 0);
        RX_in, Din           : in  std_logic_vector (7 downto 0);
        CLOCK, RESET         : in  std_logic;
        RX_ENABLE, TX_ENABLE : out std_logic;
        ATNack               : in  std_logic;
        ATN, TX_ACK          : out std_logic;
        FF_IN_B              : in  std_logic_vector (2 downto 0);
        ADD                  : in  std_logic_vector (2 downto 0);
        R_Wn, CS             : in  std_logic);
end BUS_INTERFACE;

architecture STR of BUS_INTERFACE is

  component bus_interface_dp is
    port(Dout                          : out std_logic_vector (7 downto 0);
         TX_out                        : out std_logic_vector (7 downto 0);
         RX_in, Din                    : in  std_logic_vector (7 downto 0);
         RESET, CLOCK                  : in  std_logic;
         RX_ENABLE, TX_ENABLE, CLRatn  : out std_logic;
         EN_CTRL, EN_DATARx, EN_DATATx : in  std_logic;
         SEL_MUX                       : in  std_logic;
         FF_IN                         : in  std_logic_vector(2 downto 0);
         ENABLE_FF                     : in  std_logic_vector (2 downto 0)
         );
  end component;


  component bus_interface_cu is
    port (
      RESET, CLOCK                                               : in  std_logic;
      CS_cu, R_Wn_cu                                             : in  std_logic;
      EN_STATE                                                   : out std_logic_vector (2 downto 0);
      ADD_cu                                                     : in  std_logic_vector (2 downto 0);
      SEL_mux_cu, ATN_cu, EN_regCTRL, EN_regDATARX, EN_regDATATX : out std_logic;
      TX_ack_cu                                                  : out std_logic;
      CLRatn_cu                                                  : in  std_logic;
      RX_FULL_cu, TX_EMPTY_cu, ERROR_cu, ATNack_cu               : in  std_logic);
  end component;


  signal CLRatn_s                            : std_logic;
  signal SEL_MUX_s                           : std_logic;
  signal ENABLE_FF_s                         : std_logic_vector (2 downto 0);
  signal EN_CTRL_s, EN_DATARX_S, EN_DATATX_s : std_logic;


begin

  DATAPATH :
    bus_interface_dp port map (Dout      => Dout, TX_out => TX_out, RX_in => RX_in, Din => Din,
                              RESET     => RESET, CLOCK => CLOCK, RX_ENABLE => RX_ENABLE,
                              TX_ENABLE => TX_ENABLE, CLRatn => CLRatn_s, EN_CTRL => EN_CTRL_s,
                              EN_DATARx => EN_DATARX_s, EN_DATATx => EN_DATATX_s,
                              SEL_MUX   => SEL_MUX_s, FF_IN => FF_IN_B,
                              ENABLE_FF => ENABLE_FF_s);


  CONTROLUNIT : bus_interface_cu port map (RESET        => RESET, CLOCK => CLOCK, CS_cu => CS,
                                          R_Wn_cu      => R_Wn, EN_STATE => ENABLE_FF_s, ADD_cu => ADD,
                                          SEL_MUX_cu   => SEL_MUX_s, ATN_cu => ATN, EN_regCTRL => EN_CTRL_s,
                                          EN_regDATARX => EN_DATARX_s, EN_regDATATX => EN_DATATX_s,
                                          TX_ack_cu    => TX_ACK,
                                          CLRatn_cu    => CLRatn_s, RX_FULL_cu => FF_IN_B(0),
                                          TX_EMPTY_cu  => FF_IN_B(1), ERROR_cu => FF_IN_B(2),
                                          ATNack_cu    => ATNack);

end str;


