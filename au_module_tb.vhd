library ieee;
use ieee.std_logic_1164.all;

entity au_module_tb is
end entity;

architecture test of au_module_tb is
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

    signal a, b, r          : std_logic_vector(3 downto 0) := (others => '0');
    signal cbi, sub, cbo, ov : std_logic := '0';
begin
    dut : au_module
        port map (A => a, B => b, CBi => cbi, sub => sub, R => r, CBo => cbo, OV => ov);

    stimulus : process
    begin
        -- 1. Soma simples: 3 + 4 = 7
        sub <= '0'; cbi <= '0'; a <= "0011"; b <= "0100"; wait for 10 ns;
        assert (r = "0111" and cbo = '0' and ov = '0') report "au_module_tb: Error in simple addition" severity error;

        -- 2. Soma com Carry-Out: 10 + 7 = 17 -> R=0001, CBo=1
        sub <= '0'; cbi <= '0'; a <= "1010"; b <= "0111"; wait for 10 ns;
        assert (r = "0001" and cbo = '1') report "au_module_tb: Error in carry-out addition" severity error;

        -- 3. Soma com Overflow com sinal: (+5) + (+6) = +11 -> R=1011 (-5), OV=1
        sub <= '0'; cbi <= '0'; a <= "0101"; b <= "0110"; wait for 10 ns;
        assert (r = "1011" and ov = '1') report "au_module_tb: Error in signed overflow addition" severity error;

        -- 4. Subtração simples: 7 - 3 = 4
        sub <= '1'; cbi <= '0'; a <= "0111"; b <= "0011"; wait for 10 ns;
        assert (r = "0100" and cbo = '0' and ov = '0') report "au_module_tb: Error in simple subtraction" severity error;

        -- 5. Subtração com Borrow: 2 - 5 = -3 -> R=1101 (13), CBo=1
        sub <= '1'; cbi <= '0'; a <= "0010"; b <= "0101"; wait for 10 ns;
        assert (r = "1101" and cbo = '1') report "au_module_tb: Error in borrow subtraction" severity error;

        report "au_module_tb: All tests passed." severity note;
        wait;
    end process;
end architecture;
