library ieee;
use ieee.std_logic_1164.all;

entity mux4_tb is
end entity;

architecture test of mux4_tb is
    component mux4
        port (
            A, B : in  std_logic_vector(3 downto 0);
            S    : in  std_logic;
            R    : out std_logic_vector(3 downto 0)
        );
    end component;

    signal a, b : std_logic_vector(3 downto 0) := (others => '0');
    signal s    : std_logic := '0';
    signal r    : std_logic_vector(3 downto 0);
begin
    dut : mux4
        port map (A => a, B => b, S => s, R => r);

    stimulus : process
    begin
        a <= "1100";
        b <= "0011";

        s <= '0'; wait for 10 ns;
        assert r = "1100" report "mux4_tb: Failed selecting A" severity error;

        s <= '1'; wait for 10 ns;
        assert r = "0011" report "mux4_tb: Failed selecting B" severity error;

        report "mux4_tb: All tests passed." severity note;
        wait;
    end process;
end architecture;
