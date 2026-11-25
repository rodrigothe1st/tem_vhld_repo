library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end entity;

architecture test of alu_tb is
    component ALU
        port (
            CBi                : in  std_logic;
            X, Y               : in  std_logic_vector(3 downto 0);
            OP                 : in  std_logic_vector(2 downto 0);
            R                  : out std_logic_vector(3 downto 0);
            CBo, OV, Z, GE, BE : out std_logic
        );
    end component;

    signal cbi                : std_logic := '0';
    signal x, y, r            : std_logic_vector(3 downto 0) := "0000";
    signal op                 : std_logic_vector(2 downto 0) := "000";
    signal cbo, ov, z, ge, be : std_logic;
begin
    dut : ALU
        port map (
            CBi => cbi, X => x, Y => y, OP => op,
            R   => r,   CBo => cbo, OV => ov, Z => z, GE => ge, BE => be
        );

    stimulus : process
    begin
        -- #1: OP=000 (X + Y + CBi)
        op <= "000"; cbi <= '0'; x <= "0000"; y <= "1111"; wait for 10 ns;
        assert (r = "1111" and cbo = '0' and ov = '0' and z = '0') report "alu_tb: FAIL row #1" severity error;

        -- #2: OP=000
        op <= "000"; cbi <= '1'; x <= "0000"; y <= "1111"; wait for 10 ns;
        assert (r = "0000" and cbo = '1' and ov = '0' and z = '1') report "alu_tb: FAIL row #2" severity error;

        -- #3: OP=000
        op <= "000"; cbi <= '1'; x <= "0010"; y <= "0101"; wait for 10 ns;
        assert (r = "1000" and cbo = '0' and ov = '1' and z = '0') report "alu_tb: FAIL row #3" severity error;

        -- #4: OP=000
        op <= "000"; cbi <= '1'; x <= "1111"; y <= "1010"; wait for 10 ns;
        assert (r = "1010" and cbo = '1' and ov = '0' and z = '0') report "alu_tb: FAIL row #4" severity error;

        -- #5: OP=001 (X - Y - CBi)
        op <= "001"; cbi <= '1'; x <= "0000"; y <= "1111"; wait for 10 ns;
        assert (r = "0000" and cbo = '1' and ov = '0' and z = '1' and ge = '1' and be = '1') report "alu_tb: FAIL row #5" severity error;

        -- #6: OP=001
        op <= "001"; cbi <= '1'; x <= "0001"; y <= "0101"; wait for 10 ns;
        assert (r = "1011" and cbo = '1' and ov = '0' and z = '0' and ge = '0' and be = '1') report "alu_tb: FAIL row #6" severity error;

        -- #7: OP=001
        op <= "001"; cbi <= '1'; x <= "0010"; y <= "1010"; wait for 10 ns;
        assert (r = "0111" and cbo = '1' and ov = '0' and z = '0' and ge = '1' and be = '1') report "alu_tb: FAIL row #7" severity error;

        -- #8: OP=010 (Y + CBi) — X is irrelevant, set to non-zero to verify it is ignored
        op <= "010"; cbi <= '0'; x <= "1010"; y <= "1111"; wait for 10 ns;
        assert (r = "1111" and cbo = '0' and ov = '0' and z = '0') report "alu_tb: FAIL row #8" severity error;

        -- #9: OP=010
        op <= "010"; cbi <= '1'; x <= "1010"; y <= "0001"; wait for 10 ns;
        assert (r = "0010" and cbo = '0' and ov = '0' and z = '0') report "alu_tb: FAIL row #9" severity error;

        -- #10: OP=010
        op <= "010"; cbi <= '1'; x <= "1010"; y <= "0111"; wait for 10 ns;
        assert (r = "1000" and cbo = '0' and ov = '1' and z = '0') report "alu_tb: FAIL row #10" severity error;

        -- #11: OP=010
        op <= "010"; cbi <= '1'; x <= "1010"; y <= "1111"; wait for 10 ns;
        assert (r = "0000" and cbo = '1' and ov = '0' and z = '1') report "alu_tb: FAIL row #11" severity error;

        -- #12: OP=011 (-Y - CBi) — X is irrelevant
        op <= "011"; cbi <= '0'; x <= "1010"; y <= "0000"; wait for 10 ns;
        assert (r = "0000" and cbo = '0' and ov = '0' and z = '1') report "alu_tb: FAIL row #12" severity error;

        -- #13: OP=011
        op <= "011"; cbi <= '0'; x <= "1010"; y <= "1000"; wait for 10 ns;
        assert (r = "1000" and cbo = '1' and ov = '1' and z = '0') report "alu_tb: FAIL row #13" severity error;

        -- #14: OP=011
        op <= "011"; cbi <= '1'; x <= "1010"; y <= "0110"; wait for 10 ns;
        assert (r = "1001" and cbo = '1' and ov = '0' and z = '0') report "alu_tb: FAIL row #14" severity error;

        -- #15: OP=011
        op <= "011"; cbi <= '1'; x <= "1010"; y <= "0111"; wait for 10 ns;
        assert (r = "1000" and cbo = '1' and ov = '0' and z = '0') report "alu_tb: FAIL row #15" severity error;

        -- #16: OP=100 (X and not Y)
        op <= "100"; cbi <= '1'; x <= "0001"; y <= "1100"; wait for 10 ns;
        assert (r = "0001" and z = '0') report "alu_tb: FAIL row #16" severity error;

        -- #17: OP=100 (X and not Y)
        op <= "100"; cbi <= '0'; x <= "1101"; y <= "1001"; wait for 10 ns;
        assert (r = "0100" and z = '0') report "alu_tb: FAIL row #17" severity error;

        -- #18: OP=101 (NAND)
        op <= "101"; cbi <= '0'; x <= "1010"; y <= "1110"; wait for 10 ns;
        assert (r = "0101" and z = '0') report "alu_tb: FAIL row #18" severity error;

        -- #19: OP=110 (LSL: X <<< Y(1..0))
        op <= "110"; cbi <= '0'; x <= "1001"; y <= "0110"; wait for 10 ns;
        assert (r = "0100" and cbo = '0' and z = '0') report "alu_tb: FAIL row #19" severity error;

        -- #20: OP=111 (ASR: X >> 1) — Y is irrelevant
        op <= "111"; cbi <= '1'; x <= "1111"; y <= "1010"; wait for 10 ns;
        assert (r = "1111" and cbo = '1' and z = '0') report "alu_tb: FAIL row #20" severity error;

        -- #21: Custom arithmetic (add with signed overflow)
        op <= "000"; cbi <= '0'; x <= "0100"; y <= "0101"; wait for 10 ns;
        assert (r = "1001" and cbo = '0' and ov = '1' and z = '0') report "alu_tb: FAIL row #21" severity error;

        -- #22: Custom arithmetic (sub with signed overflow)
        op <= "001"; cbi <= '0'; x <= "1010"; y <= "0111"; wait for 10 ns;
        assert (r = "0011" and cbo = '0' and ov = '1' and z = '0' and ge = '0' and be = '0') report "alu_tb: FAIL row #22" severity error;

        -- #23: Custom logic (NAND -> zero)
        op <= "101"; cbi <= '0'; x <= "1111"; y <= "1111"; wait for 10 ns;
        assert (r = "0000" and z = '1') report "alu_tb: FAIL row #23" severity error;

        -- #24: Custom logic/shift (LSL by 1 with CBo=1)
        op <= "110"; cbi <= '0'; x <= "1010"; y <= "0001"; wait for 10 ns;
        assert (r = "0100" and cbo = '1' and z = '0') report "alu_tb: FAIL row #24" severity error;

        report "All 24 ALU table test cases passed." severity note;
        wait;
    end process;
end architecture;
