`include "mipspkg.sv"
`include "immGenerator.sv"
`include "controller.sv"
`include "decoder.sv"
`include "registerFile.sv"
module decodeStage(clk,reset,writeEnable, instruction, writeData, cntrl, immOut, readData1, readData2);
  import mips_pkg::*;
  
  input Instruct instruction;
  input logic clk;
  input logic reset;
  input logic [DATA-1:0] writeData;
  input logic writeEnable;
  output logic [DATA-1:0] immOut;
  output logic [DATA-1:0] readData1;
  output logic [DATA-1:0] readData2;
  output Control cntrl;
  
  logic [REGISTERWIDTH-1:0] rs1, rs2, rd;
  
  
  //Control cntrl;
  decoder DEC(instruction , rs1, rs2, rd);
  registerFile RF(clk,reset, cntrl.regWrite, rs1, rs2, rd, writeData, readData1, readData2);
  controller CON(instruction, cntrl);
  immGenerator IMMG(instruction,immOut);
  
endmodule