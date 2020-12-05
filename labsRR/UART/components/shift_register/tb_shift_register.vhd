LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench_sr IS
END testbench_sr;

ARCHITECTURE BEH OF testbench_sr IS
    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL sh_en : STD_LOGIC := '0';
    SIGNAL ld_en : STD_LOGIC := '0';
    SIGNAL s_in : STD_LOGIC := '0';
    SIGNAL s_out : STD_LOGIC;
    SIGNAL p_in : STD_LOGIC_VECTOR(7 DOWNTO 0) := "10101010";
    SIGNAL p_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

    COMPONENT shift_register_8bit IS
        PORT (
            clock : IN STD_LOGIC := '0'; --clock
            --controls
            sh_en : IN STD_LOGIC; --shift enable
            ld_en : IN STD_LOGIC; --load enable
            --input
            s_in : IN STD_LOGIC; -- serial in
            s_out : OUT STD_LOGIC; -- serial out
            --output
            p_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel in
            p_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- parallel out
        );
    END COMPONENT;

BEGIN

    clock <= NOT(clock) AFTER 10 ns;

    load : PROCESS
    begin
        ld_en <= '0';
        WAIT FOR 10 ns;
        ld_en <= '1';
        WAIT FOR 50 ns;
        ld_en <= '0';
        WAIT;
    END PROCESS;
    sh_en <= '1' AFTER 100 ns;
    inst1 : shift_register_8bit PORT MAP(
        clock => clock,
        sh_en => sh_en,
        ld_en => ld_en,
        p_in => p_in,
        p_out => p_out,
        s_in => s_in,
        s_out => s_out
    );
END ARCHITECTURE;