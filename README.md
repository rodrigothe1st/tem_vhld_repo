# LSD - Trabalho Laboratorial 2 (ALU 4-bit — DE10-Lite)

Autores: Rodrigo Gentil, Dinis Daskalyuk  
ISEL — LEIC (Lógica e Sistemas Digitais 2026/2027)

## Como abrir no Quartus Prime

1. Clonar o repositório:
   ```bash
   git clone <URL_DO_REPO>
   ```
2. Abrir `Tlab.qpf` no **Intel Quartus Prime**.
3. O top-level já está configurado para `ALU_DE10_Lite` (com os pinos da placa DE10-Lite em `Tlab.qsf`).
4. Clicar em **Start Compilation** e depois programar a placa em **Tools → Programmer**.

## Mapeamento na Placa DE10-Lite

| Sinal ALU | Placa DE10-Lite | Notas |
| :--- | :--- | :--- |
| `X(3..0)` | `SW(3..0)` | Operando X |
| `Y(3..0)` | `SW(7..4)` | Operando Y |
| `OP(1..0)` | `SW(9..8)` | Bits 1..0 de OP |
| `OP(2)` | `KEY(0)` | Premido = `1`, solto = `0` (active-low invertido) |
| `CBi` | `KEY(1)` | Premido = `1`, solto = `0` (active-low invertido) |
| `R(3..0)` | `LEDR(3..0)` | Resultado |
| `CBo` | `LEDR(4)` | Carry / Borrow / Shift-out |
| `OV` | `LEDR(5)` | Overflow (relativos) |
| `Z` | `LEDR(6)` | Zero |
| `GE` | `LEDR(7)` | Greater or Equal (relativos) |
| `BE` | `LEDR(8)` | Below or Equal (naturais) |

## Simulação no ModelSim

```bash
vlib work
vcom decode_op.vhd xor0.vhd au_module.vhd logic_module.vhd mux4.vhd flags.vhd alu.vhd alu_tb.vhd
vsim -c work.alu_tb -do "run -all; quit -f"
```
