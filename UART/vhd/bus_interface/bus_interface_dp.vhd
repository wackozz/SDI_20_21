library ieee;
use ieee.std_logic_1164.all;

entity bus_interface_dp is
  port(
    Dout, TX_out                  : out std_logic_vector (7 downto 0);
    Din, RX_in                    : in  std_logic_vector (7 downto 0);
    RESET, CLOCK                  : in  std_logic;
    RX_ENABLE, TX_ENABLE, CLRatn  : out std_logic;
    EN_CTRL, EN_DATARx, EN_DATATx : in  std_logic;
    SEL_MUX                       : in  std_logic;
    FF_IN                         : in  std_logic_vector(2 downto 0);
    ENABLE_FF                     : in  std_logic_vector (2 downto 0)
    );
end bus_interface_dp;


architecture behav of bus_interface_dp is

  component bus_reg is

    generic (N : integer := 8);

    port (R : in std_logic_vector(N-1 downto 0);

          Clock, Reset, Enable : in std_logic;

          Q : out std_logic_vector(N-1 downto 0));
  end component;


  component mux_2_to_1 is

    port (x1, y1 : in  std_logic_vector(7 downto 0);
          s      : in  std_logic;
          m_out  : out std_logic_vector(7 downto 0));
  end component;



  signal Q_out_s3, Q_out_s4, CTRL_REGout : std_logic_vector (7 downto 0);
  signal FF_OUT                          : std_logic_vector (2 downto 0);


begin



-- FLIP FLOP PER I 3 SEGNALI DI STATO:RX_FULL,TX_EMPTY,ERROR
  process (CLOCK, RESET)
  begin

    if (RESET = '0') then

      FF_OUT(0) <= '0';
      FF_OUT(1) <= '0';
      FF_OUT(2) <= '0';

    else
      if(CLOCK'event and CLOCK = '1') then

        if (ENABLE_FF(0) = '1') then

          FF_OUT(0) <= FF_IN(0);        --RX FULL

        end if;

        if(ENABLE_FF(1) = '1') then

          FF_OUT(1) <= FF_IN(1);        -- TX EMPTY
        end if;

        if(ENABLE_FF(2) = '1') then

          FF_OUT(2) <= FF_IN(2);        -- ERROR

        end if;
      end if;
    end if;
  end process;




--STATUS REGISTER
  --bit 0 RX FULL
  --bit 1 TX EMPTY
  --bit 2 ERROR

  Q_out_s4 <= "00000" & FF_OUT(2) & FF_OUT(1) & FF_OUT(0);  -- ingresso multiplexer



-- REGISTRO CTRL
  --bit 0 ENABLE_RX
  --bit 1 ENABLE_TX
  --bit 2 CLRatn


  RX_ENABLE <= CTRL_REGout(0);
  TX_ENABLE <= CTRL_REGout(1);
  CLRatn    <= CTRL_REGout(2);






--PORT MAP MUX
  mux : mux_2_to_1 port map (x1 => Q_out_s3, y1 => Q_out_s4, s => SEL_MUX, m_out => Dout);

-- PORT MAP REGISTRI
  reg_TX_Data : bus_reg port map (R => Din, Q => TX_out, RESET => RESET, CLOCK => CLOCK, Enable => EN_DATATx);
  reg_CTRL    : bus_reg port map (R => Din, Q => CTRL_REGout, RESET => RESET, CLOCK => CLOCK, Enable => EN_CTRL);
  reg_Rx_Data : bus_reg port map (R => RX_in, Q => Q_out_s3, RESET => RESET, CLOCK => CLOCK, Enable => EN_DATARx);

end behav;

