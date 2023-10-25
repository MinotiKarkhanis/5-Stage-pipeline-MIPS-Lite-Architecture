`include "mipspkg.sv"
`include "mux2x1.sv"
`include "alu.sv"
`include "adder.sv"
module executionStage(clk, instruction, readData1, readData2, immOut, pcPlus4 ,cntrl,aluOut,newAddress, branchTaken, writeData, forward1, forward2,memForward1, memForward2,wbForward1, wbForward2, memDataOut,wbData, instr);
  import mips_pkg::*;
   input logic clk;
  input Instruct instruction;
  input logic [DATA-1:0] readData1;
  input logic [DATA-1:0] readData2;
  input logic [DATA-1:0] immOut;
  input logic [ADDRESSWIDTH-1:0] pcPlus4;
  input Control cntrl;
  input logic forward1, forward2, memForward1, memForward2,wbForward1,wbForward2;
  input logic[DATA-1:0] memDataOut;
  input logic [DATA-1:0] wbData;
  
  output logic [DATA-1:0] aluOut;
  output logic [DATA-1:0] newAddress;
  logic [DATA-1:0] branchAddress;
  output logic [DATA-1:0] writeData;
  output Instruct instr;
  
  logic zero;
  output logic branchTaken;
  logic [4:0] testrd;
  
  logic [DATA-1:0] aluIn1;
  logic addressOutOfBound;
  logic [DATA-1:0] aluIn2;
  logic [DATA-1:0] leftShiftedImm;
  
  assign writeData = readData2;
  
  logic [DATA-1:0] source1,source2,forwardEx1,forwardEx2, forwardMem1, forwardMem2, forwardWb1, forwardWb2;
  Instruct testInstr;
  //mux2x1 OP1(readData1, pc , cntrl.rs1, aluIn1);
  
  assign testrd = rdBuffer[0].rd;
  assign testInstr = instructionBuffer[0].instruction;
  
  assign instr = instruction;
  
  mux2x1 OP2(readData2, immOut, cntrl.rs2, aluIn2);
  
  mux2x1 FW1EU(executionBuffer.aluOut, readData1,forward1, source1);
  
  mux2x1 FW1MU(memDataOut, source1, memForward1, forwardMem1);
  
  mux2x1 FW1WB(wbData, forwardMem1, wbForward1, forwardWb1); 
  
  alu  ALU(source1, source2, cntrl.aluop, cntrl.jump, aluOut, zero, branchTaken);
  
  //assign leftShiftedImm = immOut << 2;
  adder ADDBRANCH($signed(pcPlus4), $signed(immOut<<2), '0, branchAddress, addressOutOfBound);
  
  mux2x1 BRANCHANDJUMP(readData1, branchAddress, cntrl.jump, newAddress);
  
  mux2x1 FW2EU(executionBuffer.aluOut, aluIn2, forward2 , source2);
  
  mux2x1 FW2MU(memDataOut, source2, memForward2, forwardMem2);
  
  mux2x1 FW2WB(wbData, forwardMem2, wbForward2, forwardWb2); 
endmodule