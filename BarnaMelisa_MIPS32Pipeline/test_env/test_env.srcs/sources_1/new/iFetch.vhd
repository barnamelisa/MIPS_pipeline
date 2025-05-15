----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2024 04:37:36 PM
-- Design Name: 
-- Module Name: iFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity IFetch is
Port (
      clk: in std_logic;
      en:in std_logic;
      rst: in std_logic;
      Jump: in std_logic;
      PCSrc: in std_logic;
      JumpAdr: in std_logic_vector(31 downto 0);
      BranchAdr: in std_logic_vector(31 downto 0);
      instruction: out std_logic_vector(31 downto 0);
      PC:out std_logic_vector(31 downto 0)
 );
end IFetch;

architecture Behavioral of IFetch is

signal PCplus4:std_logic_vector(31 downto 0):= (others => '0');
signal PCsum, NextAddr, AuxSgn, AuxSgn1: STD_LOGIC_VECTOR(31 downto 0);

type mem_rom is array(0 to 31)of std_logic_vector(31 downto 0);
signal rom: mem_rom:=(
      0=>b"000001_00010_00001_0000000000000001",--lw, X"04410001", lw $1, n (n: .word 10)
      1=>b"000010_00000_00010_0000000000000000",--addi, X"08020000", addi $2, $0, 0
      2=>b"000010_00000_00011_0000000000000000",--addi, X"08030000", addi $3, $0, 0
      3=>b"000010_00000_00100_0000000000000000",--addi, X"08040000", addi $4, $0, 0
      4=>b"000000_00000_00100_00101_00010_000100",--sll, X"00042884", sll $5, $4, 2
      5=>b"000000_00000_00000_00000_00000_000000", --NoOp
      6=>b"000001_00101_00110_0000000000000101",--lw, X"04A60005", lw $6, A_addr($5) (A_addr: .word 7, 2, 4, 1, 5, 3, 9, 6, 8, 0)
      7=>b"000000_00000_00000_00000_00000_000000", --NoOp
      8=>b"000000_00001_00110_00111_00000_100100",--and, X"00263824",  and $7, $6, 1
      9=>b"000110_00111_00000_0000000000001010",--beq, X"18E0000A", beq $7, $0, is_even
      10=>b"000000_00000_00000_00000_00000_000000", --NoOp
      11=>b"000000_00000_00000_00000_00000_000000", --NoOp
      12=>b"000000_00000_00000_00000_00000_000000", --NoOp
      13=>b"000000_00110_00100_00100_00000_100000",--add, X"00C42020", add $3, $3, $6 
      14=>b"000111_00000000000000000000001011",--j, X"1C00000B", j continue_loop
      15=>b"000000_00000_00000_00000_00000_000000", --NoOp
      16=>b"000000_00110_00011_00011_00000_100000",--add, X"00C31820", add $2, $2, $6
      17=>b"000010_00100_00100_0000000000000001",--addi, X"08840001", addi $4, $4, 1
      18=>b"000000_00000_00000_00000_00000_000000", --NoOp
      19=>b"000000_00001_00100_01000_00000_100000",--add, X"00244020",  add $8, $4, $1
      20=>b"001001_01000_00000_0000000000000100",--bne, X"25000004", bne $8, $0, loop
      21=>b"001010_00011_00010_0000000000000011",--sw, X"28620003",  sw $2, suma_pare (suma_pare: .word 0)
      22=>b"001010_00100_00011_0000000000000100",--sw, X"28830004",  sw $3, suma_impare (suma_impare: .word 0)
      others=>b"00000000000000000000000000000000" --X"00000000"
);

begin

process(clk,rst)
begin
if rst='1' then
   PC<=(others=>'0');
else
   if clk='1' and clk'event then
      if en='1'then
         PC<=NextAddr;
      end if;
   end if;
end if;
end process;

instruction<=rom(conv_integer(PCplus4(6 downto 2)));

PCsum<= PCplus4+4;
PC<=PCsum;

AuxSgn<=BranchAdr when PCSrc='1' else PCsum;
NextAddr<=JumpAdr when Jump='1' else AuxSgn;


end Behavioral;