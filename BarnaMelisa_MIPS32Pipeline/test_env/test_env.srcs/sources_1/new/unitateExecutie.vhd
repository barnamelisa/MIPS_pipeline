----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2024 02:43:40 PM
-- Design Name: 
-- Module Name: unitateExecutie - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unitateExecutie is
Port ( 
     rd1: in std_logic_vector(31 downto 0);
     aluSrc: in std_logic;
     rd2: in std_logic_vector(31 downto 0);
     extImm: in std_logic_vector(31 downto 0);
     sa: in std_logic_vector(4 downto 0);
     func: in std_logic_vector(5 downto 0);
     aluOp: in std_logic_vector(2 downto 0);
     pcPlus4: in std_logic_vector(31 downto 0);
     rt : in std_logic_vector(4 downto 0);
     rd : in std_logic_vector(4 downto 0);
     RegDst : in std_logic;
     zero: out std_logic;
     aluRes: out std_logic_vector(31 downto 0);
     rWa : out std_logic_vector(4 downto 0);
     branchAdress: out std_logic_vector(31 downto 0));
end unitateExecutie;

architecture Behavioral of unitateExecutie is

signal aluIn1, aluIn2, aluResIesire : STD_LOGIC_VECTOR(31 downto 0);
signal aluCtrl: std_logic_vector(3 downto 0);

begin

-- alu control
process(aluOp,func)
begin
  case aluOp is
  when "000" =>
      case func is
         when "000000"=> aluCtrl<="0000"; --tip R
         when "000010"=> aluCtrl<="0001"; --addi
         when "010000"=> aluCtrl<="0010"; --ori
         when "000110"=> aluCtrl<="0011"; --beq
         when "001001"=> aluCtrl<="0100"; --bne
         when "001010"=> aluCtrl<="0101"; --sw
         when "000001"=> aluCtrl<="0110"; --lw
         when "000111"=> aluCtrl<="0111"; --j
         when others => aluCtrl <= (others => '0'); 
      end case;
  when "001" => aluCtrl <= "0000"; -- +
  when "010" => aluCtrl <= "0011"; -- -
  when "101" => aluCtrl <= "0100"; -- &
  when "110" => aluCtrl <= "0101"; -- |
  when others => aluCtrl <= (others => '0'); 
  end case;
end process;

--alu
process(aluCtrl,sa,aluIn1,aluIn2)
begin
case aluCtrl is
   when "0000" => aluResIesire<=aluIn1+aluIn2; --add
   when "0001" => aluResIesire<=aluIn1-aluIn2; --sub
   when "0010" => aluResIesire<=to_stdlogicvector(to_bitvector(aluIn2) sll conv_integer(sa)); --sll
   when "0011" => aluResIesire<=to_stdlogicvector(to_bitvector(aluIn2) srl conv_integer(sa)); -- srl
  -- when "110000" => aluResIesire <= std_logic_vector(unsigned(aluIn1) * unsigned(aluIn2)); -- mult

   when "0101" => aluResIesire<=aluIn1 and aluIn2; --and	
   when "0110" => aluResIesire<=aluIn1 or aluIn2; --or
   when "0111" => aluResIesire<=aluIn1 xor aluIn2; --xor 
   
    when "1000" =>  -- beq
        if aluIn1 = aluIn2 then
            aluResIesire <= X"00000001";
        else
            aluResIesire <= X"00000000";
        end if;
   
   when "1001" => -- bne
       if aluIn1 /= aluIn2 then
             aluResIesire <= X"00000001";
        else
             aluResIesire <= X"00000000";
         end if;
            
    when "1111" =>  aluResIesire <= X"00000001"; -- jump 
    when others => aluResIesire<= (others => '0');  
end case;
end process;

-- mux regDst
process(RegDst)
begin
    case RegDst is
        when '0' => rWa <= rt;
        when '1' => rWa <= rd;
        when others => rWa <= (others => 'X');
    end case;
end process;
   
-- detector zero      
zero<='1' when aluResIesire=0 else '0';

-- alu rezultat
aluRes<=aluResIesire;

--generate branch address
branchAdress<= pcPlus4 + (extImm(29 downto 0) & "00");

end Behavioral;
