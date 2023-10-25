`include "mipspkg.sv"
`include "mux2x1.sv"
module writeBackStage(writeBackData, memDataOut , cntrl, wbData);
  import mips_pkg::*;
  input logic [DATA-1:0] writeBackData;
  input logic [DATA-1:0] memDataOut;
  input Control cntrl;
  output logic [DATA-1:0] wbData;
  
  mux2x1 WB(writeBackData, memDataOut, cntrl.wbMux, wbData);
endmodule