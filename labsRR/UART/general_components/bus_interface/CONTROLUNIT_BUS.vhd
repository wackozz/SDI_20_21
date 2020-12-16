library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit_bus is
  port (
    RESET, CLOCK                                                          : in  std_logic;
    CS_cu, R_Wn_cu                                                        : in  std_logic;
    ADD_cu                                                                : in  std_logic_vector (2 downto 0);
    RX_DATA_IN                                                            : in  std_logic_vector (7 downto 0);
    TX_DATA_OUT                                                           : out std_logic_vector (7 downto 0);
    SEL_mux, ATN_cu, EN_regSTATUS, EN_regCTRL, EN_regDATARX, EN_regDATATX : out std_logic;
    CLRatn_cu, TX_EN_cu, RX_EN_cu, TX_ack_cu, RX_ack_cu                   : out std_logic;
    RX_FULL_cu, TX_EMPTY_cu, ERROR_cu                                     : in  std_logic);
end ControlUnit_bus;


architecture behav of ControlUnit_bus is


  type state_type is (IDLE,
                      WRITE_CTRL,
                      READ_STATUS,
                      EMPTY_STATE,
                      FULL_STATE,
                      WRITE_TXdata,
                      READ_RXdata
                      );

  signal present_state : state_type;

begin
  state_update : process(CLOCK, RESET)
  begin
    if (RESET = '0') then
      present_state <= IDLE;

    elsif (CLOCK'event and CLOCK = '1') then

      case present_state is
        when IDLE =>

          if (CS_cu = '1') then

            if (R_Wn_cu = '0') then     -- LETTURA 

              if (ADD_cu(0) = '1') then

                present_state <= WRITE_CTRL;

              end if;
            end if;
          end if;


        when WRITE_CTRL =>
          if (CS_cu = '1') then
            if (R_Wn_cu = '1') then
              if(ADD_cu(0) = '0') then

                present_state <= READ_STATUS;
              end if;
            end if;
          end if;

        when READ_STATUS =>
          if (TX_EMPTY_cu = '1') then
            present_state <= EMPTY_STATE;
          end if;

          if (RX_FULL_cu = '1') then
            present_state <= FULL_STATE;
          end if;

        when EMPTY_STATE =>
          if (CS_cu = '1') then
            if(R_Wn_cu = '0') then
              if (ADD_cu(0) = '0') then
                present_state <= WRITE_TXdata;
              end if;
            end if;
          end if;

        when FULL_STATE =>
          if (CS_cu = '1') then
            if(R_Wn_cu = '1') then
              if (ADD_cu(0) = '1') then
                present_state <= READ_RXdata;
              end if;
            end if;
          end if;

        when WRITE_TXdata =>
          present_state <= IDLE;

        when READ_RXdata =>
          present_state <= IDLE;

        when others =>
          present_state <= IDLE;
      end case;
    end if;
  end process;


  FSM_cu : process(present_state)
  begin



    --default values

    SEL_mux      <= '0';
    EN_regSTATUS <= '0';
    EN_regCTRL   <= '1';
    EN_regDATARX <= '0';
    EN_regDATATX <= '0';
    CLRatn_cu    <= '0';
    TX_ack_cu    <= '0';
    RX_ack_cu    <= '0';

    case present_state is
      when IDLE =>
        EN_regCTRL <= '0';

      when WRITE_CTRL =>
        EN_regCTRL <= '1';


      when READ_STATUS =>
        EN_regSTATUS <= '1';
        SEL_mux      <= '1';

      when EMPTY_STATE =>
        RX_ack_cu <= '0';

      when FULL_STATE =>
        TX_ack_cu <= '0';

      when WRITE_TXdata =>
        EN_regDATATX <= '1';
        TX_ack_cu    <= '1';

      when READ_RXdata =>
        SEL_mux      <= '1';
        EN_regDATARX <= '1';
        RX_ack_cu    <= '1';




    end case;
  end process;

end behav;

