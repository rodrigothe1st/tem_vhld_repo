library ieee;
use ieee.std_logic_1164.all;

entity flags is
    port (
        iOV, iCB           : in  std_logic;
        OP                 : in  std_logic;
        R                  : in  std_logic_vector(3 downto 0);
        CY                 : in  std_logic;
        CBo, OV, Z, GE, BE : out std_logic
    );
end entity;

architecture rtl of flags is
    signal zero_i : std_logic;
begin
    -- Z = '1' quando todos os 4 bits de R são zero (porta NOR de 4 entradas)
    zero_i <= not (R(3) or R(2) or R(1) or R(0));

    -- CBo escolhe iCB da aritmética (OP='0') ou CY dos shifts (OP='1')
    CBo <= (iCB and (not OP)) or (CY and OP);

    OV  <= iOV;
    Z   <= zero_i;
    -- Comparações válidas na subtração (OP = 001):
    GE  <= not (R(3) xor iOV);
    BE  <= iCB or zero_i;
end architecture;
