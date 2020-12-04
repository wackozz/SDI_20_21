LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY shift_register_8bit IS
  PORT (
    clock : IN STD_LOGIC; --clock
    --controls
    sh_en : IN STD_LOGIC; --shift enable
    ld_en : IN STD_LOGIC; --load enable
    --input
    s_in : IN STD_LOGIC; -- serial in
    s_out : OUT STD_LOGIC; -- serial out
    --output
    p_in : STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel in
    p_out : STD_LOGIC_VECTOR(7 DOWNTO 0) -- parallel out
  );
END shift_register_8bit;

ARCHITECTURE arch OF shift_register_8bit IS

  SIGNAL data : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

  load : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock) AND ld_en = '1') THEN
      data <= p_in;
    END IF;
  END PROCESS; -- load

  shift : PROCESS (clock)
  BEGIN
    IF (rising_edge(clock) AND sh_en = '1') THEN
      data(7) <= s_in;
      FOR i IN 0 TO 6 LOOP
        data(i) <= data(i + 1);
      END LOOP;
    END IF;
  END PROCESS; -- shift

  s_out <= data(7);
  p_out <= data;

END ARCHITECTURE;