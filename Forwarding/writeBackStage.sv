`include "mipspkg.sv"
`include "mux2x1.sv"
module writeBackStage(clk,writeBackData, memDataOut , cntrl, wbData ,haltSignal);
  import mips_pkg::*;
  input logic clk;
  input logic [DATA-1:0] writeBackData;
  input logic [DATA-1:0] memDataOut;
  input Control cntrl;
  input logic haltSignal;
  output logic [DATA-1:0] wbData;
  
  mux2x1 WB(writeBackData, memDataOut, cntrl.wbMux, wbData);
  always_comb
    begin
      if(haltSignal)
        $finish;
    end
endmodule