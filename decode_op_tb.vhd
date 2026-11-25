library ieee;
use ieee.std_logic_1164.all;

entity decode_op_tb is
end entity;

architecture test of decode_op_tb is
    component decode_op
        port (
            OP                           : in  std_logic_vector(2 downto 0);
            OPA, OPB, OPC, OPD, OPE, OPF : out std_logic
        );
    end component;

    signal op                           : std_logic_vector(2 downto 0) := "000";
    signal opa, opb, opc, opd, ope, opf : std_logic;
begin
    dut : decode_op
        port map (
            OP  => op,
            OPA => opa, OPB => opb, OPC => opc,
            OPD => opd, OPE => ope, OPF => opf
        );

    stimulus : process
    begin
        op <= "000"; wait for 10 ns;
        assert (opa = '0' and opb = '0' and opc = '0' and opf = '0') report "Error on OP=000" severity error;

        op <= "001"; wait for 10 ns;
        assert (opa = '0' and opb = '1' and opc = '0' and opf = '0') report "Error on OP=001" severity error;

        op <= "010"; wait for 10 ns;
        assert (opa = '1' and opb = '0' and opc = '0' and opf = '0') report "Error on OP=010" severity error;

        op <= "011"; wait for 10 ns;
        assert (opa = '1' and opb = '1' and opc = '0' and opf = '0') report "Error on OP=011" severity error;

        op <= "100"; wait for 10 ns;
        assert (opc = '1' and opd = '0' and ope = '0' and opf = '1') report "Error on OP=100" severity error;

        op <= "101"; wait for 10 ns;
        assert (opc = '1' and opd = '1' and ope = '0' and opf = '1') report "Error on OP=101" severity error;

        op <= "110"; wait for 10 ns;
        assert (opc = '1' and opd = '0' and ope = '1' and opf = '1') report "Error on OP=110" severity error;

        op <= "111"; wait for 10 ns;
        assert (opc = '1' and opd = '1' and ope = '1' and opf = '1') report "Error on OP=111" severity error;

        report "decode_op_tb: All tests passed." severity note;
        wait;
    end process;
end architecture;
