LIBRARY ieee; 
USE ieee.std_logic_1164.all; 

ENTITY bus_interfaceDP IS
PORT(Dout,TX_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
RX_out,Din:IN STD_LOGIC_VECTOR (7 DOWNTO 0);
ADD: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
R/Wn,CS,ATNack : IN STD_LOGIC;
ATN: OUT STD_LOGIC;
END bus_interfaceDP;


ARCHITECTURE behav OF bus_interfaceDP IS

component bus_reg IS   

GENERIC (N : integer:=8);   

PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);    

Clock, Reset, Enable : IN  STD_LOGIC;    

Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END component;


component  mux_2_to_1 IS

PORT ( x1, y1, s : IN std_logic;

m_out :OUT std_logic); 
END component;


component ControlUnit_bus IS 
PORT (RESET,CLOCK,CS_cu,R/Wn_cu: IN STD_LOGIC;  
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
                               SEL_mux,ATN_cu: OUT STD_LOGIC                               
                              RX_DATA,TX_DATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); 
                              RX_FULL,TX_EMPTY,CLRatn,ERROR,TX_EN,RX_EN: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); 
END component;


SIGNAL 	SEL_mux_s,ENABLE_regCTRL,ENABLE_regSTATUS,ENABLE_regTX,ENABLE_regRX,
SIGNAL  Q_out_s3,Q_out_s4,
SIGNAL  
SIGNAL 


SEL_mux_s<= NOT(ADD(0))AND(ADD(1));
ENABLE_regCTRL<= ((ADD(0) AND ADD(1))AND (CS_S) AND (NOT(R/Wn)));
ENABLE_regSTATUS <= (R/Wn) AND (CS);
ENABLE_regTX <= ((NOT(ADD(0)) AND NOT(ADD(1))) AND (CS) AND (NOT(R/Wn)));
ENABLE_regRX <=(R/Wn) AND (CS);

BEGIN

mux:mux_2_to_1 port map (x1 => Q_out_s3, y1=> Q_out_s4, s=> SEL_mux_s, m_out => Dout);

reg_TX_Data: bus_reg port map (R=> Din, Q=> TX_out, RESET=> RESET,CLOCK=>CLOCK, Enable=> ENABLE_regTX);
reg_CTRL :bus_reg port map (R=> Din, Q=>TX_out,RESET=> RESET,CLOCK=>CLOCK, Enable=>ENABLE_regCTRL);
reg_Rx_Data: bus_reg port map (R=>  RX_out , Q=>Q_out_s3, RESET=> RESET,CLOCK=>CLOCK, Enable=>ENABLE_regRX);
reg_STATUS : bus_reg port map (R=> RX_out,Q=>Q_out_s4,RESET=> RESET,CLOCK=>CLOCK, Enable=>ENABLE_regSTATUS);

control: ControlUnit_bus port map (ADD_cu => ADD,CS_cu => CS, R/Wn_cu=> R/Wn,SEL_mux => SEL_mux_s, RESET=> RESET,CLOCK=>CLOCK
						            ATN_cu=> ATN, RX_FULL=> RX_out, TX_EMPTY =>RX_out, ERROR=> RX_out,CLRatn=>TX_out,TX_EN=>TX_out,RX_EN=>TX_out,
									 RX_DATA=> RX_out,TX_DATA=>TX_out);
	

END behav;	