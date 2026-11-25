library ieee;
use ieee.std_logic_1164.all;

entity decode_op is
    port (
        OP                           : in  std_logic_vector(2 downto 0);
        OPA, OPB, OPC, OPD, OPE, OPF : out std_logic
    );
end entity;

architecture rtl of decode_op is
begin
    -- Tabela das 8 operações (OP = OP(2) & OP(1) & OP(0)):
    --   OP = "000" -> Adição (X + Y + CBi)                 | OP = "100" -> Lógica: AND com negação
    --   OP = "001" -> Subtração (X - Y - CBi)              | OP = "101" -> Lógica: NAND (not (X and Y))
    --   OP = "010" -> Transferência/Incremento (Y + CBi)   | OP = "110" -> Deslocamento LSL (X <<< Y)
    --   OP = "011" -> Simétrico/Complemento (-Y - CBi)     | OP = "111" -> Deslocamento ASR (X >> 1)

    -- OPA = '1' força A = "0000" no xor0 (OP = 010 e 011); OPA = '0' deixa passar X (OP = 000 e 001).
    OPA <= (not OP(2)) and OP(1);

    -- OPB = '0' escolhe adição na AU (OP = 000, 010); OPB = '1' escolhe subtração (OP = 001, 011).
    OPB <= OP(0);

    -- OPC = '0' seleciona resultado aritmético no mux4 (000..011); OPC = '1' seleciona lógico (100..111).
    OPC <= OP(2);

    -- OPD (S0) e OPE (S1) escolhem qual das 4 operações executar no logic_module (quando OP = 100..111).
    OPD <= OP(0);
    OPE <= OP(1);

    -- OPF = '0' escolhe CBo da unidade aritmética (000..011); OPF = '1' escolhe CY do logic_module (100..111).
    OPF <= OP(2);
end architecture;
