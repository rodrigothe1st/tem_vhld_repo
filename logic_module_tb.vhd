library ieee;
use ieee.std_logic_1164.all;

entity logic_module_tb is
end entity;

architecture test of logic_module_tb is
    component logic_module
        port (
            X, Y   : in  std_logic_vector(3 downto 0);
            S1, S0 : in  std_logic;
            R      : out std_logic_vector(3 downto 0);
            CY     : out std_logic
        );
    end component;

    signal x, y, r    : std_logic_vector(3 downto 0) := (others => '0');
    signal s1, s0, cy : std_logic := '0';
begin
    dut : logic_module
        port map (X => x, Y => y, S1 => s1, S0 => s0, R => r, CY => cy);

    stimulus : process
    begin
        x <= "1010";
        y <= "1100";

        -- 1. X and (not Y) (S1=0, S0=0): "1010" and "0011" = "0010"
        s1 <= '0'; s0 <= '0'; wait for 10 ns;
        assert r = "0010" report "logic_module_tb: Error in X AND NOT Y" severity error;

        -- 2. NAND (S1=0, S0=1)
        s1 <= '0'; s0 <= '1'; wait for 10 ns;
        assert r = "0111" report "logic_module_tb: Error in NAND" severity error;

        -- 3. LSL (S1=1, S0=0): X="1010", Y="0001" -> R="0100", CY='1'
        s1 <= '1'; s0 <= '0'; x <= "1010"; y <= "0001"; wait for 10 ns;
        assert (r = "0100" and cy = '1') report "logic_module_tb: Error in LSL by 1" severity error;

        -- 4. ASR (S1=1, S0=1): X="1011" -> R="1101", CY='1'
        s1 <= '1'; s0 <= '1'; x <= "1011"; wait for 10 ns;
        assert (r = "1101" and cy = '1') report "logic_module_tb: Error in ASR" severity error;

        report "logic_module_tb: All tests passed." severity note;
        wait;
    end process;
end architecture;
