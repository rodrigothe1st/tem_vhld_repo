library ieee;
use ieee.std_logic_1164.all;

entity xor0_tb is
end entity;

architecture test of xor0_tb is
    component xor0
        port (
            X          : in  std_logic_vector(3 downto 0);
            force_zero : in  std_logic;
            A          : out std_logic_vector(3 downto 0)
        );
    end component;

    signal x          : std_logic_vector(3 downto 0) := (others => '0');
    signal force_zero : std_logic := '0';
    signal a          : std_logic_vector(3 downto 0);
begin
    dut : xor0
        port map (X => x, force_zero => force_zero, A => a);

    stimulus : process
    begin
        force_zero <= '0';
        x <= "1010"; wait for 10 ns;
        assert a = "1010" report "Error: X should pass when force_zero=0" severity error;

        x <= "0101"; wait for 10 ns;
        assert a = "0101" report "Error: X should pass when force_zero=0" severity error;

        force_zero <= '1';
        x <= "1010"; wait for 10 ns;
        assert a = "0000" report "Error: A must be 0000 when force_zero=1" severity error;

        x <= "1111"; wait for 10 ns;
        assert a = "0000" report "Error: A must be 0000 when force_zero=1" severity error;

        report "xor0_tb: All tests passed." severity note;
        wait;
    end process;
end architecture;
