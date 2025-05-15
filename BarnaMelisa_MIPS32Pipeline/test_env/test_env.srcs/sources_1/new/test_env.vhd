----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 04:47:53 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));    
end test_env;

architecture Behavioral of test_env is

signal digits:std_logic_vector(31 downto 0):=(others=>'0');

signal JumpAddress, ALURes, ALUres1, branchAdress, MemData: STD_LOGIC_VECTOR(31 downto 0);
signal pcPlus4, rd1, rd2, WD, instruction, extImm: STD_LOGIC_VECTOR(31 downto 0);

signal sa: std_logic_vector(4 downto 0);
signal func: std_logic_vector(5 downto 0);
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0);

signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite : STD_LOGIC;
signal en, zero, rst, pcSrc: std_logic;

signal writeAdress: std_logic_vector(4 downto 0);
signal rt: std_logic_vector(4 downto 0);
signal rd: std_logic_vector(4 downto 0);
signal rWa: std_logic_vector(4 downto 0);

--aici pun registrii pentru pipeline
signal reg_if_id: std_logic_vector(63 downto 0);
signal ref_id_ex: std_logic_vector(162 downto 0);
signal reg_ex_mem: std_logic_vector(110 downto 0);
signal reg_mem_wb: std_logic_vector(72 downto 0);

--if_id
signal pc_if_id: std_logic_vector(31 downto 0);
signal instruction_if_id: std_logic_vector(31 downto 0);

--id_ex
signal pc_id_ex: std_logic_vector(31 downto 0);
signal rd1_id_ex: std_logic_vector(31 downto 0);
signal rd2_id_ex: std_logic_vector(31 downto 0);
signal extImm_id_ex: std_logic_vector(31 downto 0);
signal memToReg_id_ex: std_logic;
signal regWrite_id_ex: std_logic;
signal memWrite_id_ex: std_logic;
signal branch_id_ex: std_logic;
signal aluOp_id_ex: std_logic_vector(2 downto 0);
signal aluSrc_id_ex: std_logic;
signal regDst_id_ex: std_logic;
signal sa_id_ex: std_logic_vector(4 downto 0);
signal func_id_ex: std_logic_vector(5 downto 0);
signal rt_id_ex, rd_id_ex: std_logic_vector(4 downto 0);

--ex_mem
signal memToReg_ex_mem: std_logic;
signal regWrite_ex_mem: std_logic;
signal memWrite_ex_mem: std_logic;
signal branch_ex_mem: std_logic;
signal zero_ex_mem: std_logic;
signal aluIesire_ex_mem: std_logic_vector(31 downto 0);
signal out_ex_mem: std_logic_vector(4 downto 0);--rd_ex_mem
signal rd2_ex_mem: std_logic_vector(31 downto 0);
signal branchAddr_ex_mem: std_logic;--iesire alu

--mem_wb
signal rd_mem_wb: std_logic_vector(4 downto 0);
signal memToReg_mem_wb: std_logic;
signal regWrite_mem_wb: std_logic;
signal aluIesire_mem_wb: std_logic_vector(31 downto 0);
signal memData_mem_wb: std_logic_vector(31 downto 0);

component reg_file is
     Port ( 
  clk : in std_logic;
  ra1 : in std_logic_vector(4 downto 0);
  ra2 : in std_logic_vector(4 downto 0);
  wa : in std_logic_vector(4 downto 0);
  wd : in std_logic_vector(31 downto 0);
  regwr : in std_logic;
  rd1 : out std_logic_vector(31 downto 0);
  rd2 : out std_logic_vector(31 downto 0));
end component reg_file;

component debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component debouncer;

component SSD is 
    Port (
           clk: in std_logic;
           data: in std_logic_vector(31 downto 0);
           cat: out std_logic_vector(6 downto 0);
           an: out std_logic_vector(7 downto 0));
end component SSD;

component IFetch is
    Port (
           clk: in std_logic;
           en:in std_logic;
           rst: in std_logic;
           Jump: in std_logic;
           PCSrc: in std_logic;
           JumpAdr: in std_logic_vector(31 downto 0);
           BranchAdr: in std_logic_vector(31 downto 0);
           instruction: out std_logic_vector(31 downto 0);
           PC:out std_logic_vector(31 downto 0));
end component IFetch;

component UDecodificare is
    Port (
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
end component UDecodificare;

component UnitateControl is
    Port (
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
end component UnitateControl;

component unitateExecutie is
    Port (
          rd1: in std_logic_vector(31 downto 0);
          rd2: in std_logic_vector(31 downto 0);
          aluSrc: in std_logic;
          extImm: in std_logic_vector(31 downto 0);
          sa: in std_logic_vector(4 downto 0);
          func: in std_logic_vector(5 downto 0);
          aluOp: in std_logic_vector(2 downto 0);
          pcPlus4: in std_logic_vector(31 downto 0);
          zero: out std_logic;
          aluRes: out std_logic_vector(31 downto 0);
          branchAdress: out std_logic_vector(31 downto 0));
end component unitateExecutie;

component UnitateMemorieMEM is
    Port ( 
          en: in std_logic;
          clk: in std_logic;
          memWrite: in std_logic;
          rd2: in std_logic_vector(31 downto 0);
          aluResin: in std_logic_vector(31 downto 0);
          memData: out std_logic_vector(31 downto 0);
          aluResout: out std_logic_vector(31 downto 0));
end component UnitateMemorieMEM;

begin

reggisterFile: reg_file port map
(
  clk=>clk,
  ra1=>instruction(25 downto 21),
  ra2=>instruction(20 downto 16),
  wa=>writeAdress,
  wd=>wd,
  regwr=>regWrite,
  rd1=>rd1,
  rd2=>rd2
);

btn1: debouncer port map
( 
   clk=>clk,
   btn=>btn(0),
   en=>en);

InstructionFetch:IFetch port map
(
  clk=>clk,
  en=>en,
  rst=>btn(1),
  Jump=>Jump,
  PCSrc=>pcSrc,
  JumpAdr=>JumpAddress,
  BranchAdr=>branchAdress,
  instruction=>instruction,
  PC=>pcPlus4
);

udecod:UDecodificare port map
( 
   en=>en,
   regWrite=>RegWrite,
   instr=>instruction(25 downto 0),
   regDst=>RegDst, 
   extOp=>ExtOp, 
   clk=>clk,
   wd=>WD,
   rd1=>rd1, 
   rd2=>rd2,
   extImm=>extImm, 
   func=>func, 
   sa=>sa,
   rt=>rt,
   rd=>rd
);

unitateCtrl:UnitateControl port map
(
   instr=>instruction(31 downto 26),
   regDst=>RegDst,
   extOp=>ExtOp,
   aluSrc=>ALUSrc,
   branch=>Branch,
   jump=>Jump,
   aluOp=>ALUOp,
   memWrite=>MemWrite,
   memToReg=>MemtoReg,
   regWrite=>RegWrite
);

unitateExecutie1: unitateExecutie port map
(
  rd1=>rd1,
  rd2=>rd2,
  aluSrc=>ALUSrc,
  extImm=>extImm,
  sa=>sa,
  func=>func,
  aluOp=>ALUOp,
  pcPlus4=>pcPlus4,
  zero=>zero,
  aluRes=>ALURes,
  branchAdress=>branchAdress
 );
 
unitateMem: UnitateMemorieMEM port map
 (
   en=>en,
   clk=>clk, 
   memWrite=>MemWrite,
   rd2=>rd2,
   aluResin=>ALURes,
   memData=>MemData, 
   aluResout=>ALURes1
 );
 
process(clk)
begin
  if clk'event and clk='1' then
      if en='1' then 
      --if_id
        reg_if_id(31 downto 0) <= pcPlus4;
        reg_if_id(63 downto 32) <= instruction;
        pc_if_id<= pcPlus4;
        instruction_if_id <= instruction;
        
      --id_ex
        pc_id_ex <= pc_if_id;
        rd1_id_ex <= rd1;
        rd2_id_ex <= rd2;
        extImm_id_ex <= extImm;
        memToReg_id_ex<= memtoReg;
        regWrite_id_ex <= regWrite;
        memWrite_id_ex <= memWrite;
        branch_id_ex <= branch;
        aluOp_id_ex <= aluOp;
        aluSrc_id_ex <= aluSrc;
        regDst_id_ex <= regDst;
        sa_id_ex <= sa;
        func_id_ex <= func;
        rt_id_ex <= rt;
        rd_id_ex <= rd;
        
      --ex_mem
        memToReg_ex_mem <= memToReg_id_ex;
        regWrite_ex_mem <= regWrite_id_ex;
        memWrite_ex_mem <= memWrite_id_ex;
        branch_ex_mem <= branch_id_ex;
        zero_ex_mem <= zero;
        rd2_ex_mem <= rd2_id_ex;
        aluIesire_ex_mem <= AluRes;
        out_ex_mem <= rWa;
        
       --mem_wb
       rd_mem_wb <=  out_ex_mem;
       memToReg_mem_wb <=  memToReg_ex_mem;
       regWrite_mem_wb <=  regWrite_ex_mem;
       aluIesire_mem_wb <= ALUres1;
       memData_mem_wb <= MemData;
      end if;
  end if;
end process;
  

  -- write-Back unit 
   WD <= MemData when MemtoReg = '1' else ALURes1; 

  -- branch control
   pcSrc <= zero and branch;

   JumpAddress <= PCplus4(31 downto 28) & Instruction(25 downto 0) & "00";

  -- dispaly pt ssd
   with sw(7 downto 5) select
   digits <= instruction when "000",
          pcPlus4 when "001",
          rd1 when "010",
          rd2 when "011",
          extImm when "100",
          ALURes when "101",
          MemData when "110",
          WD when "111",
          (others => 'X') when others;
          
ssd1: SSD port map
 (
   clk=>clk,
   data=>digits,
   an=>an,
   cat=>cat
);
   
   led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
   
end Behavioral;