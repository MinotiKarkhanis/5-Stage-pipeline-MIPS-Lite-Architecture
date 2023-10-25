`include "mipspkg.sv"
`include "dataMemory.sv"
module memStage(clk,reset,instruction, address, writeData, wbData, cntrl, memDataOut, writeBackData, instrMem );
  import mips_pkg::*;
  input logic clk;
  input logic reset;
  input Instruct instruction;
  input logic[ADDRESSWIDTH-1 :0 ] address;
  input Control cntrl;
  input logic[DATA-1:0] writeData;
  input logic [DATA-1:0]wbData;
  output logic[DATA-1:0] memDataOut;
  output Instruct instrMem;
  
  logic [DATA-1:0] dataOut;
  output logic [DATA-1:0] writeBackData;
  
  assign instrMem = instruction;
  
  dataMemory DM(clk, reset, cntrl.memWriteEnable, writeData, address, dataOut);
  
  assign writeBackData = wbData;
  assign memDataOut = dataOut;
  
   
endmodule 