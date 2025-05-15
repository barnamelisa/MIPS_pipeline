----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 05:12:40 PM
-- Design Name: 
-- Module Name: unitateControl - Behavioral
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

entity unitateControl is
   Port(
        instr: in std_logic_vector(5 downto 0);
        regDst: out std_logic;
        extOp: out std_logic;
        aluSrc: out std_logic;
        branch: out std_logic;
        jump: out std_logic;
        aluOp: out std_logic_vector(2 downto 0);
        memWrite: out std_logic;
        memToReg: out std_logic;
        regWrite: out std_logic);
end unitateControl;

architecture Behavioral of unitateControl is
begin

process(instr)
begin
  case instr is
    -- instructiuni de tip R pt ca ele au opcode=000000  
    when"000000" => regDst<='1'; 
                    regWrite<='1';
                    aluSrc<='0';
                    extOp<='0'; --pot pune orice ca nu conteaza x
                    aluOp<="000"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                    
    -- instructiuni de tip I
    --ADDI 
    when"000010" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='1';
                    extOp<='1'; 
                    aluOp<="100"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                    
    --ORI
     when"010000" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='1';
                    extOp<='1'; 
                    aluOp<="010"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                  
     --BEQ
      when"000110" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='1';
                    extOp<='1'; 
                    aluOp<="110"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                    
     --BNE
      when"001001" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='1';
                    extOp<='1';
                    aluOp<="101"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                    
      --SW
       when"001010" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='1';
                    extOp<='1'; 
                    aluOp<="001"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                    
      --LW
       when"000001" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='1';
                    extOp<='1'; 
                    aluOp<="011"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='0';
                    
       --J
        when "000111" => regDst<='0'; 
                    regWrite<='0';
                    aluSrc<='0';
                    extOp<='0'; 
                    aluOp<="110"; 
                    memWrite<='0';
                    memToReg<='0';
                    branch<='0';
                    jump<='1';
                    
        when others => regDst<='X'; 
                    regWrite<='X';
                    aluSrc<='X';
                    extOp<='X'; 
                    aluOp<="XXX"; 
                    memWrite<='X';
                    memToReg<='X';
                    branch<='X';
                    jump<='X';
                  
   end case;
end process;

end Behavioral;
