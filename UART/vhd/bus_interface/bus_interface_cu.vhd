library ieee;
use ieee.std_logic_1164.all;

entity bus_interface_cu is
  port (RESET, CLOCK                                               : in  std_logic;
        CS_cu, R_Wn_cu                                             : in  std_logic;
        EN_STATE                                                   : out std_logic_vector (2 downto 0);
        ADD_cu                                                     : in  std_logic_vector (2 downto 0);
        SEL_mux_cu, ATN_cu, EN_regCTRL, EN_regDATARX, EN_regDATATX : out std_logic;
        TX_ack_cu                                                  : out std_logic;
        CLRatn_cu                                                  : in  std_logic;
        RX_FULL_cu, TX_EMPTY_cu, ERROR_cu, ATNack_cu               : in  std_logic);
end bus_interface_cu;


architecture behav of bus_interface_cu is


  type state_type is (IDLE,
                      WRITE_CTRL,
                      READ_STATUS,
                      WRITE_TXdata,
                      READ_RXdata,
                      NEXT_STATE,
                      ATNack_STATE
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
            if (R_Wn_cu = '0') then
              if (ADD_cu(0) = '1') then

                present_state <= WRITE_CTRL;
              else
                present_state <= IDLE;
              end if;
            end if;
          end if;



        when WRITE_CTRL =>

          if (CS_cu = '1') then
            if (R_Wn_cu = '1') then
              if(ADD_cu(0) = '0') then

                present_state <= READ_STATUS;

              else
                present_state <= IDLE;
              end if;
            end if;
          end if;

        when READ_STATUS =>

          if (TX_EMPTY_cu = '1'and CS_cu = '1' and R_Wn_cu = '0'
              and ADD_cu (0) = '0') then
            present_state <= WRITE_TXdata;

          end if;

          if (RX_FULL_cu = '1'and CS_cu = '1'
              and R_Wn_cu = '1' and ADD_cu(0) = '1') then
            present_state <= READ_RXdata;

          end if;





        when WRITE_TXdata =>
          present_state <= NEXT_STATE;


        when READ_RXdata =>
          present_state <= NEXT_STATE;

        when NEXT_STATE =>
          if (CLRatn_cu = '1') then  -- ATN DISATTIVATO INUTILE MANDARE ATNack
            present_state <= IDLE;
          else
            present_state <= ATNack_STATE;  -- VADO NELLO STATO DI ATTESA DELL'ATNack
          end if;

        when ATNack_STATE =>

          if(ATNack_cu = '1') then
            present_state <= IDLE;

          elsif (TX_EMPTY_cu = '1') then  --controllo che nel frattempo non siano arrivati
                                          -- nuovi segnali senza che ci sia stata risposta dall'esterno
            present_state <= WRITE_TXdata;

          elsif (RX_FULL_cu = '1') then
            present_state <= READ_RXdata;
          else
            present_state <= IDLE;
          end if;

        when others =>
          present_state <= IDLE;
      end case;
    end if;
  end process;


  FSM_cu : process(present_state)
  begin



    --default values

    SEL_mux_cu   <= '0';  --LO LASCIO DI DEFAULT A ZERO COSI DA POTER MANDARE SEMPRE L'ERRORE SU DOUT
    EN_regCTRL   <= '0';
    EN_regDATARX <= '0';
    EN_regDATATX <= '0';
    TX_ack_cu    <= '0';
    EN_STATE(0)  <= '0';
    EN_STATE(1)  <= '0';
    EN_STATE(2)  <= '1';  --LO LASCIO SEMPRE ALTO COSI DA POTER SEMPRE SENTIRE L'ERRORE
    ATN_cu       <= '0';

    case present_state is
      when IDLE =>
        if(ERROR_cu = '1') then
          EN_STATE(2) <= '1';
        end if;

      when WRITE_CTRL =>
        EN_regCTRL  <= '1';
        EN_STATE(2) <= '1';

      when READ_STATUS =>
        SEL_MUX_cu <= '0';
        if (TX_EMPTY_cu = '1') then
          EN_STATE(1) <= '1';
          EN_STATE(2) <= '1';
          Tx_ack_cu   <= '0';
          ATN_cu      <= '1';
        end if;

        if (RX_FULL_cu = '1') then
          EN_STATE(0) <= '1';
          EN_STATE(2) <= '1';
          Tx_ack_cu   <= '0';
          ATN_cu      <= '1';
        end if;



      when READ_RXdata =>               -- LEGGO RX_DATA
        SEL_mux_cu   <= '1';
        EN_regDATARX <= '1';
        ATN_cu       <= '1';            --MANDO ATN
        EN_STATE(2)  <= '1';
        TX_ack_cu    <= '0';

      when WRITE_TXdata =>              -- SCRIVO SU TX_DATA
        EN_regDATATX <= '1';
        ATN_cu       <= '1';            --MANDO ATN
        EN_STATE(2)  <= '1';
        TX_ack_cu    <= '1';

      when NEXT_STATE =>
        if(CLRatn_cu = '1') then
          ATN_cu      <= '0';
          EN_STATE(2) <= '1';
        else
          ATN_cu <= '1';
        end if;

      when ATNack_STATE =>
        ATN_cu       <= '1';
        SEL_MUX_cu   <= '0';  -- lo lascio in modalità lettura dello stato
        EN_STATE(2)  <= '1';
        EN_STATE (1) <= '1';  --ABILITO ENABLE DI RX FULL E TX EMPTY COSI DA POTERLI
                                      --MENTRE SONO NELLO STATO ATNack
        EN_STATE(0)  <= '1';
        if(ATNack_cu = '1') then
          ATN_cu <= '0';                --DISABILITO ATN

        end if;



    end case;
  end process;

end behav;
