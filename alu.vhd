library ieee;
use ieee.std_logic_1164.all;

entity ALU is
    port (
        CBi                : in  std_logic;
        X, Y               : in  std_logic_vector(3 downto 0);
        OP                 : in  std_logic_vector(2 downto 0);
        R                  : out std_logic_vector(3 downto 0);
        CBo, OV, Z, GE, BE : out std_logic
    );
end entity;

architecture structural of ALU is
    component decode_op
        port (
            OP                           : in  std_logic_vector(2 downto 0);
            OPA, OPB, OPC, OPD, OPE, OPF : out std_logic
        );
    end component;

    component xor0
        port (
            X          : in  std_logic_vector(3 downto 0);
            force_zero : in  std_logic;
            A          : out std_logic_vector(3 downto 0)
        );
    end component;

    component au_module
        port (
            A, B : in  std_logic_vector(3 downto 0);
            CBi  : in  std_logic;
            sub  : in  std_logic;
            R    : out std_logic_vector(3 downto 0);
            CBo  : out std_logic;
            OV   : out std_logic
        );
    end component;

    component logic_module
        port (
            X, Y   : in  std_logic_vector(3 downto 0);
            S1, S0 : in  std_logic;
            R      : out std_logic_vector(3 downto 0);
            CY     : out std_logic
        );
    end component;

    component mux4
        port (
            A, B : in  std_logic_vector(3 downto 0);
            S    : in  std_logic;
            R    : out std_logic_vector(3 downto 0)
        );
    end component;

    component flags
        port (
            iOV, iCB           : in  std_logic;
            OP                 : in  std_logic;
            R                  : in  std_logic_vector(3 downto 0);
            CY                 : in  std_logic;
            CBo, OV, Z, GE, BE : out std_logic
        );
    end component;

    signal opa, opb, opc, opd, ope, opf : std_logic;
    signal a_au, r_au, r_logic, r_i     : std_logic_vector(3 downto 0);
    signal cbo_au, ov_au, cy_logic      : std_logic;
begin
    U_decoder    : decode_op    port map (OP, opa, opb, opc, opd, ope, opf);
    U_input_a    : xor0         port map (X, opa, a_au);
    U_arithmetic : au_module    port map (a_au, Y, CBi, opb, r_au, cbo_au, ov_au);
    U_logical    : logic_module port map (X, Y, ope, opd, r_logic, cy_logic);
    U_result_mux : mux4         port map (r_au, r_logic, opc, r_i);
    U_status     : flags        port map (ov_au, cbo_au, opf, r_i, cy_logic, CBo, OV, Z, GE, BE);

    R <= r_i;
end architecture;
