library ieee;
use ieee.std_logic_1164.all;

entity au_module is
    port (
        A, B : in  std_logic_vector(3 downto 0);
        CBi  : in  std_logic;
        sub  : in  std_logic;
        R    : out std_logic_vector(3 downto 0);
        CBo  : out std_logic;
        OV   : out std_logic
    );
end entity;

architecture rtl of au_module is
    -- Fios internos do somador/subtrator de 4 bits (Ripple-Carry Adder):
    --   b_xor: inverte B quando sub = '1' (para fazer complemento para 2)
    --   c:     carries internos de bit 0 até bit 4
    signal b_xor : std_logic_vector(3 downto 0);
    signal c     : std_logic_vector(4 downto 0);
begin
    -- Na adição (sub = '0'):  b_xor = B     e c(0) = CBi
    -- Na subtração (sub = '1'): b_xor = not B e c(0) = not CBi  (A - B - CBi = A + not(B) + not(CBi))
    b_xor(0) <= B(0) xor sub;
    b_xor(1) <= B(1) xor sub;
    b_xor(2) <= B(2) xor sub;
    b_xor(3) <= B(3) xor sub;
    c(0)     <= CBi xor sub;

    -- Somador completo bit 0
    R(0) <= A(0) xor b_xor(0) xor c(0);
    c(1) <= (A(0) and b_xor(0)) or (A(0) and c(0)) or (b_xor(0) and c(0));

    -- Somador completo bit 1
    R(1) <= A(1) xor b_xor(1) xor c(1);
    c(2) <= (A(1) and b_xor(1)) or (A(1) and c(1)) or (b_xor(1) and c(1));

    -- Somador completo bit 2
    R(2) <= A(2) xor b_xor(2) xor c(2);
    c(3) <= (A(2) and b_xor(2)) or (A(2) and c(2)) or (b_xor(2) and c(2));

    -- Somador completo bit 3
    R(3) <= A(3) xor b_xor(3) xor c(3);
    c(4) <= (A(3) and b_xor(3)) or (A(3) and c(3)) or (b_xor(3) and c(3));

    -- CBo: na adição é c(4); na subtração o borrow ocorre quando c(4) = '0' (logo not c(4))
    CBo <= c(4) xor sub;

    -- OV: overflow com sinal ocorre quando o carry que entra no último bit é diferente do que sai
    OV <= c(3) xor c(4);
end architecture;
