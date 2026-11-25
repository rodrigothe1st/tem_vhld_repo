library ieee;
use ieee.std_logic_1164.all;

entity flags_tb is
end entity;

architecture test of flags_tb is
    component flags
        port (
            iOV, iCB           : in  std_logic;
            OP                 : in  std_logic;
            R                  : in  std_logic_vector(3 downto 0);
            CY                 : in  std_logic;
            CBo, OV, Z, GE, BE : out std_logic
        );
    end component;

    signal iov, icb, op, cy    : std_logic := '0';
    signal r                   : std_logic_vector(3 downto 0) := "0000";
    signal cbo, ov, z, ge, be  : std_logic;
begin
    dut : flags
        port map (
            iOV => iov, iCB => icb, OP => op, R => r, CY => cy,
            CBo => cbo, OV => ov, Z => z, GE => ge, BE => be
        );

    stimulus : process
    begin
        r <= "0000"; wait for 10 ns;
        assert z = '1' report "flags_tb: Z should be 1 when R=0000" severity error;

        r <= "0001"; wait for 10 ns;
        assert z = '0' report "flags_tb: Z should be 0 when R/=0000" severity error;

        op <= '0'; icb <= '1'; cy <= '0'; wait for 10 ns;
        assert cbo = '1' report "flags_tb: CBo should follow iCB when OP=0" severity error;

        op <= '1'; icb <= '1'; cy <= '0'; wait for 10 ns;
        assert cbo = '0' report "flags_tb: CBo should follow CY when OP=1" severity error;

        iov <= '0'; r <= "0100"; wait for 10 ns;
        assert ge = '1' report "flags_tb: GE should be 1" severity error;

        r <= "1100"; wait for 10 ns;
        assert ge = '0' report "flags_tb: GE should be 0" severity error;

        icb <= '1'; r <= "0100"; wait for 10 ns;
        assert be = '1' report "flags_tb: BE should be 1 when iCB=1" severity error;

        report "flags_tb: All tests passed." severity note;
        wait;
    end process;
end architecture;
