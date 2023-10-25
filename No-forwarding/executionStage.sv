`include "mipspkg.sv"
`include "mux2x1.sv"
`include "alu.sv"
`include "adder.sv"
module executionStage(clk, instruction, decoderRd,readData1, readData2, immOut, pcPlus4 ,cntrl,aluOut,newAddress, branchTaken, writeData, executionRd);
  import mips_pkg::*;
   input logic clk;
  input Instruct instruction;
  input logic [DATA-1:0] readData1;
  input logic [DATA-1:0] readData2;
  input logic [DATA-1:0] immOut;
  input logic [ADDRESSWIDTH-1:0] pcPlus4;
  input Control cntrl;
  input logic[REGISTERWIDTH-1:0] decoderRd;
  
  output logic [DATA-1:0] aluOut;
  output logic [DATA-1:0] newAddress;
  logic [DATA-1:0] branchAddress;
  output logic [DATA-1:0] writeData;
  
  logic zero;
  output logic branchTaken;
  output logic [REGISTERWIDTH-1:0]  executionRd;
  
  logic [DATA-1:0] aluIn1;
  logic addressOutOfBound;
  logic [DATA-1:0] aluIn2;
  logic [DATA-1:0] leftShiftedImm;
  
  assign writeData = readData2;
  assign executionRd = decoderRd;
  //mux2x1 OP1(readData1, pc , cntrl.rs1, aluIn1);
  mux2x1 OP2(readData2, immOut, cntrl.rs2, aluIn2);
  
  alu  ALU(readData1, aluIn2, cntrl.aluop, cntrl.jump, aluOut, zero, branchTaken);
  
  //assign leftShiftedImm = immOut << 2;
  adder ADDBRANCH($signed(pcPlus4), $signed(immOut<<2), '0, branchAddress, addressOutOfBound);
  
  mux2x1 BRANCHANDJUMP(readData1, branchAddress, cntrl.jump, newAddress);
  
endmodule