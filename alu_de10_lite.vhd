library ieee;
use ieee.std_logic_1164.all;

entity ALU_DE10_Lite is
    port (
        SW   : in  std_logic_vector(9 downto 0);
        KEY  : in  std_logic_vector(1 downto 0);
        LEDR : out std_logic_vector(9 downto 0)
    );
end entity;

architecture structural of ALU_DE10_Lite is
    component ALU
        port (
            CBi                : in  std_logic;
            X, Y               : in  std_logic_vector(3 downto 0);
            OP                 : in  std_logic_vector(2 downto 0);
            R                  : out std_logic_vector(3 downto 0);
            CBo, OV, Z, GE, BE : out std_logic
        );
    end component;

    signal op_s               : std_logic_vector(2 downto 0);
    signal cbi_s              : std_logic;
    signal result             : std_logic_vector(3 downto 0);
    signal cbo, ov, z, ge, be : std_logic;
begin
    -- Os botões da placa DE10-Lite são ativos a nível baixo (active-low)
    op_s  <= (not KEY(0)) & SW(9 downto 8);
    cbi_s <= not KEY(1);

    U_alu : ALU
        port map (
            CBi => cbi_s,
            X   => SW(3 downto 0),
            Y   => SW(7 downto 4),
            OP  => op_s,
            R   => result,
            CBo => cbo,
            OV  => ov,
            Z   => z,
            GE  => ge,
            BE  => be
        );

    LEDR(3 downto 0) <= result;
    LEDR(4)          <= cbo;
    LEDR(5)          <= ov;
    LEDR(6)          <= z;
    LEDR(7)          <= ge;
    LEDR(8)          <= be;
    LEDR(9)          <= '0';
end architecture;
