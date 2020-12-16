LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
  
ENTITY ControlUnit_bus IS 
PORT        (  
                  RESET,CLOCK: IN STD_LOGIC;                      
                            CS_cu,R_Wn_cu: IN STD_LOGIC;                     
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
							  RX_DATA_IN: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
							  TX_DATA_OUT : OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0);
                               SEL_mux,ATN_cu,EN_regSTATUS,EN_regCTRL,EN_regDATARX,EN_regDATATX: OUT STD_LOGIC;                                                       
                              CLRatn_cu,TX_EN_cu,RX_EN_cu,TX_ack_cu,RX_ack_cu: OUT STD_LOGIC;
                               RX_FULL_cu,TX_EMPTY_cu,ERROR_cu: IN STD_LOGIC);
END ControlUnit_bus; 


ARCHITECTURE behav OF ControlUnit_bus IS


TYPE state_type IS (  IDLE,
                      WRITE_CTRL,
					  READ_STATUS,
					  EMPTY_STATE,
					  FULL_STATE,
					  WRITE_TXdata,
					  READ_RXdata
					  );

SIGNAL present_state: state_type;

BEGIN
state_update: process(CLOCK,RESET)
BEGIN  
 IF (RESET = '0') THEN 
   present_state<=IDLE; 
    
         ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
                               
           CASE present_state IS 
                                                       WHEN IDLE => 
                                
							                     IF ( CS_cu = '1') THEN 
                                
								                     IF (R_Wn_cu='0') THEN -- LETTURA 
													 
                                                        IF (ADD_cu(0) = '1') THEN
                                                            
															present_state <= WRITE_CTRL; 
                                                        
														END IF;
                                                    END IF;
                                                 END IF;         
                                                        
														
														WHEN WRITE_CTRL =>
												  IF ( CS_cu = '1') THEN
												    IF (R_Wn_cu = '1') THEN
													  IF(ADD_cu(0)= '0') THEN
													  
													  present_state <= READ_STATUS;
													  END IF;
													END IF;
                                                  END IF;

                                                        WHEN READ_STATUS =>
                                                   IF (TX_EMPTY_cu = '1') THEN
                                                       present_state <= EMPTY_STATE;
                                                    END IF;
   
                                                    IF (RX_FULL_cu = '1') THEN
                                                       present_state<= FULL_STATE;
                                                    END IF;

                                                      WHEN EMPTY_STATE =>
                                                    IF (CS_cu = '1') THEN
                                                       IF(R_Wn_cu= '0') THEN
                										IF (ADD_cu(0) = '0') THEN
														present_state <= WRITE_TXdata;
														END IF;
													  END IF;
                                                    END IF;

													WHEN FULL_STATE =>
													IF (CS_cu = '1') THEN
                                                       IF(R_Wn_cu= '1') THEN
                										IF (ADD_cu(0) = '1') THEN
														present_state <= READ_RXdata;
														END IF;
													  END IF;
                                                    END IF;
													
													WHEN WRITE_TXdata =>
													present_state <= IDLE;
													
													WHEN READ_RXdata =>
													present_state <= IDLE;
                                                    
													WHEN OTHERS =>
													present_state <= IDLE;
               END CASE;   
	   END IF;
END PROCESS; 


FSM_cu: process(present_state)
BEGIN



  --default values
 
        SEL_mux <= '0';
	EN_regSTATUS <= '0';
	EN_regCTRL <= '1';
	EN_regDATARX <= '0';
	EN_regDATATX <= '0';
	CLRatn_cu <= '0';
	TX_ack_cu  <= '0';
	RX_ack_cu <= '0';
    
CASE present_state IS
                              WHEN IDLE =>
							  EN_regCTRL <= '0';
							  
							  WHEN WRITE_CTRL =>
							  EN_regCTRL <= '1';
							
							  
							  WHEN READ_STATUS =>
							  EN_regSTATUS <= '1';
							  SEL_mux<= '1';
							  
							 WHEN EMPTY_STATE =>
							  RX_ack_cu <= '0';
							 
						       WHEN FULL_STATE =>
							  TX_ack_cu <= '0';
							   
							 WHEN WRITE_TXdata =>
							  EN_regDATATX <= '1';
							  TX_ack_cu <= '1';
							 
							 WHEN READ_RXdata =>
                                                         SEL_mux <= '1'; 
							 EN_regDATARX <= '1';
							 RX_ack_cu <= '1';
							  
							  
							 
							 
END CASE;							
END PROCESS;							 

END behav; 

