library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
    port (
        A, B : in  std_logic_vector(3 downto 0);
        S    : in  std_logic;
        R    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of mux4 is
begin
    -- Multiplexador 2-para-1 feito com portas AND, OR e NOT:
    --   S = '0' (OP = 000..011): seleciona A (resultado aritmético).
    --   S = '1' (OP = 100..111): seleciona B (resultado lógico/deslocamento).
    R(0) <= (A(0) and (not S)) or (B(0) and S);
    R(1) <= (A(1) and (not S)) or (B(1) and S);
    R(2) <= (A(2) and (not S)) or (B(2) and S);
    R(3) <= (A(3) and (not S)) or (B(3) and S);
end architecture;
