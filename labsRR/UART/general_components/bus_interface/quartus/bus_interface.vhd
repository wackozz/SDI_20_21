LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY BUS_INTERFACE IS
PORT ( Dout: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
TX_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
RX_in,Din:IN STD_LOGIC_VECTOR (7 DOWNTO 0);
CLOCK,RESET: IN STD_LOGIC;
RX_ENABLE,TX_ENABLE: OUT STD_LOGIC;
ATNack : IN STD_LOGIC;
ATN,TX_ACK : OUT STD_LOGIC;
FF_IN_B : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
ADD : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
R_Wn,CS : IN STD_LOGIC);
END BUS_INTERFACE;

ARCHITECTURE STR OF BUS_INTERFACE IS

COMPONENT bus_interfaceDP IS
PORT(Dout: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
TX_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
RX_in,Din:IN STD_LOGIC_VECTOR (7 DOWNTO 0);
RESET,CLOCK: IN STD_LOGIC;
RX_ENABLE,TX_ENABLE,CLRatn: OUT STD_LOGIC;
EN_CTRL,EN_DATARx,EN_DATATx : IN STD_LOGIC;
SEL_MUX: IN STD_LOGIC;
FF_IN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
ENABLE_FF: IN STD_LOGIC_VECTOR (2 DOWNTO 0)
);
END COMPONENT;


COMPONENT ControlUnit_bus IS 
PORT        (  
                  RESET,CLOCK: IN STD_LOGIC;                      
                            CS_cu,R_Wn_cu: IN STD_LOGIC; 
                            EN_STATE: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);									 
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
                           SEL_mux_cu,ATN_cu,EN_regCTRL,EN_regDATARX,EN_regDATATX: OUT STD_LOGIC;                                                       
                             TX_ack_cu: OUT STD_LOGIC;
									  CLRatn_cu : in STD_LOGIC;
                               RX_FULL_cu,TX_EMPTY_cu,ERROR_cu,ATNack_cu: IN STD_LOGIC);
END COMPONENT;


SIGNAL CLRatn_s : STD_LOGIC;
SIGNAL SEL_MUX_s : STD_LOGIC;
SIGNAL ENABLE_FF_s : STD_LOGIC_VECTOR (2 DOWNTO 0);
SIGNAL EN_CTRL_s,EN_DATARX_S,EN_DATATX_s : STD_LOGIC;


BEGIN 

DATAPATH:
bus_interfaceDP PORT MAP ( Dout => Dout, TX_out => TX_out, RX_in => RX_in, Din => Din,                             
									RESET => RESET, CLOCK => CLOCK, RX_ENABLE => RX_ENABLE, 
									TX_ENABLE => TX_ENABLE, CLRatn => CLRatn_s, EN_CTRL => EN_CTRL_s,
									EN_DATARx => EN_DATARX_s, EN_DATATx => EN_DATATX_s, 
									 SEL_MUX => SEL_MUX_s,FF_IN => FF_IN_B,
									ENABLE_FF => ENABLE_FF_s);
									

CONTROLUNIT: ControlUnit_bus PORT MAP ( RESET => RESET, CLOCK => CLOCK, CS_cu => CS,
                                        R_Wn_cu => R_Wn, EN_STATE => ENABLE_FF_s, ADD_cu => ADD,
													 SEL_MUX_cu => SEL_MUX_s, ATN_cu => ATN, EN_regCTRL => EN_CTRL_s,
													 EN_regDATARX => EN_DATARX_s, EN_regDATATX => EN_DATATX_s,
													 TX_ack_cu => TX_ACK,  
													 CLRatn_cu => CLRatn_s, RX_FULL_cu => FF_IN_B(0),
													 TX_EMPTY_cu => FF_IN_B(1), ERROR_cu => FF_IN_B(2),
													 ATNack_cu => ATNack);
													 
END str;


