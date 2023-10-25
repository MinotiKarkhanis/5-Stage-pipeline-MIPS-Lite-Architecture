`include "mipspkg.sv"
`include "mux2x1.sv"
module writeBackStage(clk, instruction, memRd, writeBackData, memDataOut , cntrl, wbData ,haltSignal, wbRd);
  import mips_pkg::*;
  input logic clk;
  input Instruct instruction;
  input logic [REGISTERWIDTH-1:0] memRd;
  input logic [DATA-1:0] writeBackData;
  input logic [DATA-1:0] memDataOut;
  input Control cntrl;
  input logic haltSignal;
  output logic [DATA-1:0] wbData;
  output logic [REGISTERWIDTH-1:0] wbRd;
  mux2x1 WB(writeBackData, memDataOut, cntrl.wbMux, wbData);
  assign wbRd = memRd;
  always_comb
    begin
      if(haltSignal)
        $finish;
       
    end
endmodule