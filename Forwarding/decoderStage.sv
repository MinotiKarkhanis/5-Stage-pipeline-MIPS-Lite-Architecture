`include "mipspkg.sv"
`include "immGenerator.sv"
`include "controller.sv"
`include "decoder.sv"
`include "registerFile.sv"
`include "hazardDetection.sv"
`include "waitStateUnit.sv"
`include "forwardingUnit.sv"

module decodeStage(clk,reset,branchTaken,pc,inputCntrl,inputRd, writeEnable, instruction, writeData, cntrl, immOut, readData1, readData2,pcOut, rs1,rs2,rd, hazardDetected,haltSignal, forward1, forward2,memForward1, memForward2,wbForward1, wbForward2,instrDec);
  import mips_pkg::*;
  
  input Instruct instruction;
  input logic clk;
  input logic reset;
  input logic branchTaken;
  input logic [ADDRESSWIDTH-1:0] pc;
  input logic [DATA-1:0] writeData;
  input logic writeEnable;
  input Control inputCntrl;
  input logic [REGISTERWIDTH-1:0] inputRd;
  output logic [DATA-1:0] immOut;
  output logic [DATA-1:0] readData1;
  output logic [DATA-1:0] readData2;
  output logic [ADDRESSWIDTH-1:0] pcOut;
  output Control cntrl;
  output logic [REGISTERWIDTH-1:0] rd;
  
  output logic [REGISTERWIDTH-1:0] rs1, rs2;
  output logic hazardDetected;
  output logic haltSignal;
  logic [1:0] count;
  logic hazard;
  output logic forward1, forward2, memForward1, memForward2, wbForward1, wbForward2;
  output Instruct instrDec;
  
  always_comb
    begin
      if(forward1=='0 && forward2=='0 && hazard =='1)
        begin
          dataHazards = dataHazards + 1;
        end
    end
  //Control cntrl;
  decoder DEC(instruction , haltSignal, branchTaken,rs1, rs2, rd);
  registerFile RF(clk,reset, inputCntrl.regWrite, rs1, rs2, inputRd, writeData, readData1, readData2);
  controller CON(instruction,branchTaken, cntrl, haltSignal);
  
  immGenerator IMMG(instruction,immOut);
  
  
  hazardDetection HZ(rs1, rs2,instruction, hazard, count);
  
  waitStateUnit WSU(clk,reset,count, hazard, forward1, forward2, hazardDetected);
  
  forwardingUnit FU(  rs1, rs2, instruction, forward1, forward2, memForward1, memForward2, wbForward1, wbForward2);
  
  assign pcOut = pc;
  assign instrDec = instruction;
 
    
  
endmodule