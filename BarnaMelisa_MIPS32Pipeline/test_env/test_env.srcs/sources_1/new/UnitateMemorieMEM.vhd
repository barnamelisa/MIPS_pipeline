----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 05:37:42 PM
-- Design Name: 
-- Module Name: UnitateMemorieMEM - Behavioral
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

entity UnitateMemorieMEM is
Port(
      en: in std_logic;
      clk: in std_logic;
      memWrite: in std_logic;
      rd2: in std_logic_vector(31 downto 0);
      aluResin: in std_logic_vector(31 downto 0);
      memData: out std_logic_vector(31 downto 0);
      aluResout: out std_logic_vector(31 downto 0));
end UnitateMemorieMEM;

architecture Behavioral of UnitateMemorieMEM is

type mem_ram is array(0 to 63)of std_logic_vector(31 downto 0);
signal ram: mem_ram:=(
    X"0000000A",
    X"0000000B",
    X"0000000C",
    X"0000000D",
    X"0000000E",
    X"0000000F",
    X"00000009",
    X"00000008",
    others=>X"00000000");

begin

process(clk)
begin
  if rising_edge(clk) then
    if memWrite='1' and en='1' then
       ram(conv_integer(aluResin(7 downto 2)))<=rd2;
    end if;
  end if;
end process;

memData<=ram(conv_integer(aluResin(7 downto 2)));
aluResout<=aluResin;

end Behavioral;
