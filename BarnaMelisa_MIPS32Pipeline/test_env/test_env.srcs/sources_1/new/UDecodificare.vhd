----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 04:36:36 PM
-- Design Name: 
-- Module Name: UDecodificare - Behavioral
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

entity UDecodificare is
  Port(
       en: in std_logic;
           regWrite: in std_logic;
           instr: in std_logic_vector(25 downto 0);
           regDst: in std_logic;
           extOp: in std_logic; 
           clk: in std_logic;
           wd: in std_logic_vector(31 downto 0);
           rd1: out std_logic_vector(31 downto 0);
           rd2: out std_logic_vector(31 downto 0);
           extImm: out std_logic_vector(31 downto 0);
           func: out std_logic_vector(5 downto 0);
           sa: out std_logic_vector(10 downto 6);
           rt : out std_logic_vector(4 downto 0);
           rd : out std_logic_vector(4 downto 0));
end UDecodificare;

architecture Behavioral of UDecodificare is

signal writeAdress: std_logic_vector(4 downto 0);
type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (others => X"00000000");

begin

writeAdress<=instr(15 downto 11) when regDst='1' else instr(20 downto 16);

process(clk)
begin
  if rising_edge(clk) then
     if regWrite='1' and en='1' then
        reg_file(conv_integer(writeAdress))<=wd;
      end if;
   end if;
end process;

-- proces pt extUnit in functie de extOp
process(extOp)
begin
  case extOp is
    when '1' => extImm(31 downto 16) <= (others => instr(17));--? de ce instr(17)
    when '0' => extImm(31 downto 16) <= (others => '0'); 
    when others => extImm(31 downto 16) <= (others => '0');
  end case;
end process;


rd1 <= reg_file(conv_integer(instr(25 downto 21))); -- rs
rd2 <= reg_file(conv_integer(instr(20 downto 16))); -- rt
    
extImm(15 downto 0)<=instr(15 downto 0);
extImm(31 downto 16) <= (others => instr(15)) when extOp = '1' else (others => '0');   

rt<=instr(20 downto 16);
rd<=instr(15 downto 11);
sa<=instr(10 downto 6);
func<=instr(5 downto 0);

end Behavioral;