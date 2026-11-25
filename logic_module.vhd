library ieee;
use ieee.std_logic_1164.all;

entity logic_module is
    port (
        X, Y   : in  std_logic_vector(3 downto 0);
        S1, S0 : in  std_logic;
        R      : out std_logic_vector(3 downto 0);
        CY     : out std_logic
    );
end entity;

architecture rtl of logic_module is
    signal r_op0, r_op1, r_lsl, r_asr : std_logic_vector(3 downto 0);
    signal cy_lsl, cy_asr             : std_logic;
    signal sh0, sh1, sh2, sh3         : std_logic;
    signal sel00, sel01, sel10, sel11 : std_logic;
begin
    -- OP = "100" (S1='0', S0='0'): AND com negação -> X and (not Y)
    r_op0 <= X and (not Y);

    -- OP = "101" (S1='0', S0='1'): NAND -> not (X and Y)
    r_op1 <= not (X and Y);

    -- OP = "110" (S1='1', S0='0'): Deslocamento lógico à esquerda (LSL: X <<< Y(1..0))
    sh0 <= (not Y(1)) and (not Y(0)); -- Y(1..0) = "00" (desloca 0)
    sh1 <= (not Y(1)) and Y(0);       -- Y(1..0) = "01" (desloca 1)
    sh2 <= Y(1) and (not Y(0));       -- Y(1..0) = "10" (desloca 2)
    sh3 <= Y(1) and Y(0);             -- Y(1..0) = "11" (desloca 3)

    r_lsl(3) <= (X(3) and sh0) or (X(2) and sh1) or (X(1) and sh2) or (X(0) and sh3);
    r_lsl(2) <= (X(2) and sh0) or (X(1) and sh1) or (X(0) and sh2);
    r_lsl(1) <= (X(1) and sh0) or (X(0) and sh1);
    r_lsl(0) <= (X(0) and sh0);
    cy_lsl   <= (X(3) and sh1) or (X(2) and sh2) or (X(1) and sh3);

    -- OP = "111" (S1='1', S0='1'): Deslocamento aritmético à direita de 1 bit (ASR: X >> 1)
    r_asr  <= X(3) & X(3 downto 1);
    cy_asr <= X(0);

    -- Multiplexador 4-para-1 para selecionar a operação com S1 e S0
    sel00 <= (not S1) and (not S0);
    sel01 <= (not S1) and S0;
    sel10 <= S1 and (not S0);
    sel11 <= S1 and S0;

    R(3) <= (r_op0(3) and sel00) or (r_op1(3) and sel01) or (r_lsl(3) and sel10) or (r_asr(3) and sel11);
    R(2) <= (r_op0(2) and sel00) or (r_op1(2) and sel01) or (r_lsl(2) and sel10) or (r_asr(2) and sel11);
    R(1) <= (r_op0(1) and sel00) or (r_op1(1) and sel01) or (r_lsl(1) and sel10) or (r_asr(1) and sel11);
    R(0) <= (r_op0(0) and sel00) or (r_op1(0) and sel01) or (r_lsl(0) and sel10) or (r_asr(0) and sel11);

    CY <= (cy_lsl and sel10) or (cy_asr and sel11);
end architecture;
