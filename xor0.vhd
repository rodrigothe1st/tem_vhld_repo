library ieee;
use ieee.std_logic_1164.all;

entity xor0 is
    port (
        X          : in  std_logic_vector(3 downto 0);
        force_zero : in  std_logic;
        A          : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of xor0 is
begin
    -- Ligado ao sinal OPA do decode_op:
    --   force_zero = '1' (OP = 010 ou 011): força A = "0000" para calcular Y + CBi ou -Y - CBi.
    --   force_zero = '0' (OP = 000 ou 001): deixa passar X para calcular X + Y + CBi ou X - Y - CBi.
    A(0) <= X(0) and (not force_zero);
    A(1) <= X(1) and (not force_zero);
    A(2) <= X(2) and (not force_zero);
    A(3) <= X(3) and (not force_zero);
end architecture;
