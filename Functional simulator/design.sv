`include "instructionFetch.sv"
`include "decoderStage.sv"
`include "executionStage.sv"
`include "memStage.sv"
`include "writeBackStage.sv"
//`define DEBUG
module mipsLiteProcessor(clk,reset);
  import mips_pkg::*;
  input logic clk;
  input logic reset;
  
  Instruct instruction;
  logic [ADDRESSWIDTH-1:0] pcPlus4;
  logic [ADDRESSWIDTH-1:0] pc;
  
  logic writeEnable;
  logic [DATA-1:0]wbData;
  logic [DATA-1:0] immOut;
  logic [DATA-1:0] readData1;
  logic [DATA-1:0] readData2;
  Control cntrl;
  
  int clockCount;

  
  logic [DATA-1:0] aluOut;
  logic [ADDRESSWIDTH-1:0] branchAddress;
  logic branchTaken;
  logic [DATA-1:0] writeData;
  
  logic [DATA-1:0] dataOut;
  
  logic[DATA-1:0] memDataOut;
  logic [DATA-1:0] writeBackData;
  //logic [DATA-1:0] memDataOut;
  
  instructionFetch IF(clk, reset, branchAddress, branchTaken, pcPlus4, instruction,pc);
  
  decodeStage ID(clk,reset,writeEnable, instruction, wbData, cntrl, immOut, readData1, readData2);

  
  executionStage IE(readData1, readData2, immOut, pc ,cntrl,aluOut,branchAddress, branchTaken, writeData);
  
  memStage IM(clk,reset,aluOut, writeData, aluOut, cntrl, memDataOut, writeBackData);
  
  writeBackStage WB(writeBackData, memDataOut , cntrl, wbData);
  

  final
  begin
    $display("\n/////////////////////////////////////////////////////////////////////");
    $display("==================== Functional Simulator Output ====================");
    $display("/////////////////////////////////////////////////////////////////////");
    $display("\n==================== Instruction Counts ====================");
    $display("Toatl number of instructions = %0d", instructionCount);
    $display("Arithmetic Instructions = %0d", arithmeticInstrCount);
    $display("Logical Instructions = %0d", logicalInstrCount);
    $display("Memory access instruction = %0d", memoryInstrCount);
    $display("Control transfer instruction = %0d", branchInstrCount);
    $display("\n==================== Final Register Status ====================");
    $display("Program Counter = %0d", IF.PC.d);
    for (int i=11; i< 26; i++)
      begin
        $display("R%0d = %0d", i, $signed(ID.RF.registerFile[i]));
      end
      $display("\n==================== Final Memory State ====================");
    for(int i=0;i<MEMDEPTH-1; i=i+4)
      begin
        if(memWriteStatus[i]=='1)
          begin
        dataOut = {>>MEMWIDTH{IM.DM.dataMem[i +: BYTESPERINSTRUCTION]}};
                    $display("Address = %0d Contents =%0d",i,dataOut);

          end
      end
    
  end
  
  
endmodule