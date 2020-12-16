LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY bus_interfaceDP IS
PORT(Dout,TX_out,CTRL_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
RX_in,Din,STATUS_out:IN STD_LOGIC_VECTOR (7 DOWNTO 0);
ADD: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
R_Wn,CS,ATNack,RESET,CLOCK,DONE_TX,DONE_RX : IN STD_LOGIC;
ATN,RX_ENABLE,TX_ENABLE,CLRatn,RX_ACK,TX_ACK: OUT STD_LOGIC;
ERROR,TX_EMPTY,RX_FULL : IN STD_LOGIC);
END bus_interfaceDP;


ARCHITECTURE behav OF bus_interfaceDP IS

component bus_reg IS   

GENERIC (N : integer:=8);   

PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);    

Clock, Reset, Enable : IN  STD_LOGIC;    

Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END component;


component  mux_2_to_1 IS

PORT ( x1, y1 : IN std_logic_vector(7 downto 0);
        s:IN std_logic;
m_out :OUT std_logic_vector(7 downto 0)); 
END component;


component ControlUnit_bus IS 
PORT        (  
                  RESET,CLOCK: IN STD_LOGIC;                      
                            CS_cu,R_Wn_cu: IN STD_LOGIC;                     
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
							  RX_DATA_IN: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
							  TX_DATA_OUT : OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0);
                               SEL_mux,ATN_cu,EN_regSTATUS,EN_regCTRL,EN_regDATARX,EN_regDATATX: OUT STD_LOGIC;                                                       
                              CLRatn_cu,TX_EN_cu,RX_EN_cu,TX_ack_cu,RX_ack_cu: OUT STD_LOGIC;
                               RX_FULL_cu,TX_EMPTY_cu,ERROR_cu: IN STD_LOGIC);
END component;


SIGNAL 	SEL_mux_s,ENABLE_regCTRL,ENABLE_regSTATUS,ENABLE_regTX,ENABLE_regRX :STD_LOGIC;
SIGNAL  Q_out_s3,Q_out_s4, CTRL_REGout :STD_LOGIC_vector (7 downto 0);


BEGIN 

SEL_mux_s<= NOT(ADD(0))AND(ADD(1));

--STATUS REGISTER
		--bit 0 rxfull
		--bit 1 txempty
		--bit 2 error
Q_out_s4 <= "00000" & ERROR & TX_EMPTY & RX_FULL;  --status

--CTRL
        --bit 0 ENABLE_RX
		--bit 1 ENABLE_TX
		--bit 2 CLRatn

RX_ENABLE <= CTRL_REGout(0);
TX_ENABLE <= CTRL_REGout(1);
CLRatn <= CTRL_REGout (2);


mux:mux_2_to_1 port map (x1 => Q_out_s3, y1=> Q_out_s4, s=> SEL_mux_s, m_out => Dout);

reg_TX_Data: bus_reg port map (R=> Din, Q=> TX_out, RESET=> RESET,CLOCK=>CLOCK, Enable=> ENABLE_regTX);
reg_CTRL :bus_reg port map (R=> Din, Q=>CTRL_REGout,RESET=> RESET,CLOCK=>CLOCK, Enable=>ENABLE_regCTRL);
reg_Rx_Data: bus_reg port map (R=>  RX_in , Q=>Q_out_s3, RESET=> RESET,CLOCK=>CLOCK, Enable=>ENABLE_regRX);
reg_STATUS : bus_reg port map (R=> STATUS_out,Q=>Q_out_s4,RESET=> RESET,CLOCK=>CLOCK, Enable=>ENABLE_regSTATUS);

control: CONTROLUnit_bus port map (ADD_cu => ADD,CS_cu => CS, R_Wn_cu=> R_Wn,SEL_mux => SEL_mux_s, RESET=> RESET,CLOCK=>CLOCK,
						            ATN_cu=> ATN, RX_FULL_cu=> RX_FULL, TX_EMPTY_cu =>TX_EMPTY, ERROR_cu=> ERROR,
									RX_DATA_IN => RX_in, TX_DATA_OUT=> TX_out,
                                                            CLRatn_cu=>CLRatn,TX_EN_cu=>TX_ENABLE,RX_EN_cu=>RX_ENABLE,
									 EN_regCTRL=>ENABLE_regCTRL, EN_regDATARX=> ENABLE_regRX, 
	                              EN_regSTATUS=>ENABLE_regSTATUS, EN_regDATATX=> ENABLE_regTX,TX_ack_cu=> TX_ACK,RX_ack_cu=>RX_ACK );

END behav;	
