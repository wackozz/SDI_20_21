library ieee;
use ieee.std_logic_1164.all;

entity bus_interfaceDP is
  port(Dout, TX_out, CTRL_out                            : out std_logic_vector (7 downto 0);
       RX_in, Din, STATUS_out                            : in  std_logic_vector (7 downto 0);
       ADD                                               : in  std_logic_vector (2 downto 0);
       R_Wn, CS, ATNack, RESET, CLOCK, DONE_TX, DONE_RX  : in  std_logic;
       ATN, RX_ENABLE, TX_ENABLE, CLRatn, RX_ACK, TX_ACK : out std_logic;
       error, TX_EMPTY, RX_FULL                          : in  std_logic);
end bus_interfaceDP;


architecture behav of bus_interfaceDP is

  component bus_reg is

    generic (N : integer := 8);

    port (R : in std_logic_vector(N-1 downto 0);

          Clock, Reset, Enable : in std_logic;

          Q : out std_logic_vector(N-1 downto 0));
  end component;


  component mux_2_to_1 is

    port (x1, y1 : in  std_logic_vector(7 downto 0);
          s      :in   std_logic;
          m_out  : out std_logic_vector(7 downto 0));
  end component;


  component ControlUnit_bus is
    port (
      RESET, CLOCK                                                          : in  std_logic;
      CS_cu, R_Wn_cu                                                        : in  std_logic;
      ADD_cu                                                                : in  std_logic_vector (2 downto 0);
      RX_DATA_IN                                                            : in  std_logic_vector (7 downto 0);
      TX_DATA_OUT                                                           : out std_logic_vector (7 downto 0);
      SEL_mux, ATN_cu, EN_regSTATUS, EN_regCTRL, EN_regDATARX, EN_regDATATX : out std_logic;
      CLRatn_cu, TX_EN_cu, RX_EN_cu, TX_ack_cu, RX_ack_cu                   : out std_logic;
      RX_FULL_cu, TX_EMPTY_cu, ERROR_cu                                     : in  std_logic);
  end component;


  signal SEL_mux_s, ENABLE_regCTRL, ENABLE_regSTATUS, ENABLE_regTX, ENABLE_regRX : std_logic;
  signal Q_out_s3, Q_out_s4, CTRL_REGout                                         : std_logic_vector (7 downto 0);


begin

  SEL_mux_s <= not(ADD(0))and(ADD(1));

--STATUS REGISTER
  --bit 0 rxfull
  --bit 1 txempty
  --bit 2 error
  Q_out_s4 <= "00000" & error & TX_EMPTY & RX_FULL;  --status

--CTRL
  --bit 0 ENABLE_RX
  --bit 1 ENABLE_TX
  --bit 2 CLRatn

  RX_ENABLE <= CTRL_REGout(0);
  TX_ENABLE <= CTRL_REGout(1);
  CLRatn    <= CTRL_REGout (2);


  mux : mux_2_to_1 port map (x1 => Q_out_s3, y1 => Q_out_s4, s => SEL_mux_s, m_out => Dout);

  reg_TX_Data : bus_reg port map (R => Din, Q => TX_out, RESET => RESET, CLOCK => CLOCK, Enable => ENABLE_regTX);
  reg_CTRL    : bus_reg port map (R => Din, Q => CTRL_REGout, RESET => RESET, CLOCK => CLOCK, Enable => ENABLE_regCTRL);
  reg_Rx_Data : bus_reg port map (R => RX_in, Q => Q_out_s3, RESET => RESET, CLOCK => CLOCK, Enable => ENABLE_regRX);
  reg_STATUS  : bus_reg port map (R => STATUS_out, Q => Q_out_s4, RESET => RESET, CLOCK => CLOCK, Enable => ENABLE_regSTATUS);

  control : CONTROLUnit_bus port map (ADD_cu       => ADD, CS_cu => CS, R_Wn_cu => R_Wn, SEL_mux => SEL_mux_s, RESET => RESET, CLOCK => CLOCK,
                                      ATN_cu       => ATN, RX_FULL_cu => RX_FULL, TX_EMPTY_cu => TX_EMPTY, ERROR_cu => error,
                                      RX_DATA_IN   => RX_in, TX_DATA_OUT => TX_out,
                                      CLRatn_cu    => CLRatn, TX_EN_cu => TX_ENABLE, RX_EN_cu => RX_ENABLE,
                                      EN_regCTRL   => ENABLE_regCTRL, EN_regDATARX => ENABLE_regRX,
                                      EN_regSTATUS => ENABLE_regSTATUS, EN_regDATATX => ENABLE_regTX, TX_ack_cu => TX_ACK, RX_ack_cu => RX_ACK);

end behav;
