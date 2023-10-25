`include "mipspkg.sv"
`include "dataMemory.sv"
module memStage(clk,reset,address, writeData, wbData, cntrl, memDataOut, writeBackData );
  import mips_pkg::*;
  input logic clk;
  input logic reset;
  input logic[ADDRESSWIDTH-1 :0 ] address;
  input Control cntrl;
  input logic[DATA-1:0] writeData;
  input logic [DATA-1:0]wbData;
  output logic[DATA-1:0] memDataOut;
  
  logic [DATA-1:0] dataOut;
  output logic [DATA-1:0] writeBackData;
  
  
  dataMemory DM(clk, reset, cntrl.memWriteEnable, writeData, address, dataOut);
  
  assign writeBackData = wbData;
  assign memDataOut = dataOut;
  
   
endmodule 