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
  logic [ADDRESSWIDTH-1:0] pcOut;

  logic writeEnable;
  logic [DATA-1:0]wbData;
  logic [DATA-1:0] immOut;
  logic [DATA-1:0] readData1;
  logic [DATA-1:0] readData2;
  Control cntrl;




  logic [DATA-1:0] aluOut;
  logic [ADDRESSWIDTH-1:0] branchAddress;
  logic branchTaken;
  logic [DATA-1:0] writeData;

  logic [DATA-1:0] dataOut;

  logic[DATA-1:0] memDataOut;
  logic [DATA-1:0] writeBackData;
  
  //logic [DATA-1:0] memDataOut;
  string TEST;
  logic [REGISTERWIDTH-1:0] rd,rs1,rs2,decoderRd, executionRd,wbRd;
  logic hazardDetected;
  logic haltSignal;
  int count;
  initial 
    begin
      if($value$plusargs("TEST = %s",TEST))
        $display("string = %s",TEST);
    end

  //instruction Fetch stage
  instructionFetch IF(clk, reset, haltSignal, hazardDetected, branchAddress, branchTaken, pcPlus4, instruction,pc);

  //IF AND DECODE Buffer
  always_ff@(posedge clk)
    begin
      if(reset)
        begin
        clockCount<=0;
          stalls<=0;
        end
      else
        begin
          clockCount<= clockCount+1;
          if(!hazardDetected && !branchTaken)
            begin
          fetchBuffer.instruction <=instruction;
          fetchBuffer.pc <= pc;
            end
          if(branchTaken )
          begin
            fetchBuffer.pc <= pc;
          fetchBuffer.instruction <='x;
             clockCount <= clockCount-1;
            count =count+1;
            end
        end
    end
always_comb
  begin
    if(haltSignal)
    finalClockCount = clockCount + 3;
  end

  decodeStage ID(clk,reset,branchTaken,fetchBuffer.pc,controlBuffer[2].cntrl, wbRd , writeEnable, fetchBuffer.instruction, wbData, cntrl, immOut, readData1, readData2,pcOut, rs1, rs2, rd,hazardDetected,haltSignal);

  always_ff@(posedge clk)
    begin
      if(!hazardDetected && !branchTaken)
        begin
      decodeBuffer.instruction <= fetchBuffer.instruction;
      decodeBuffer.readData1 <= readData1;
      decodeBuffer.readData2 <= readData2;
      decodeBuffer.immOut <= immOut;
      decodeBuffer.pc <= pcOut;
      decodeBuffer.haltSignal<=haltSignal;
          decodeBuffer.rd <= rd;
      //decodeBuffer.cntrl <= cntrl;
      controlBuffer[0].cntrl<= cntrl;
      rdBuffer[0].rd <= rd;
      rdBuffer[0].rs1 <= rs1;
      rdBuffer[0].rs2 <= rs2;
        end
       else if(branchTaken)
        begin
          instructionCount = instructionCount -1;
          case(fetchBuffer.instruction.opcode)
            6'h00,
            6'h01,
            6'h02,
            6'h03,
            6'h04,
            6'h05 : arithmeticInstrCount = arithmeticInstrCount-1;
            
            6'h06,
            6'h07,
            6'h08,
            6'h09,
            6'h0A,
            6'h0B : logicalInstrCount = logicalInstrCount-1;
            
            6'h0C,
            6'h0D : memoryInstrCount = memoryInstrCount - 1;
            
            6'h0E,
            6'h0F,
            6'h10,
            6'h11 : branchInstrCount = branchInstrCount - 1;
            
          endcase
      decodeBuffer.readData1 <= '0;
      decodeBuffer.readData2 <= '0;
      decodeBuffer.immOut <= '0;
      decodeBuffer.pc <= pcOut ;
          decodeBuffer.haltSignal<=haltSignal;
          decodeBuffer.instruction <= 'x;
      //decodeBuffer.cntrl <= cntrl;
          controlBuffer[0].cntrl<= 'x;
          rdBuffer[0].rd <= 'x;
          rdBuffer[0].rs1 <= 'x;
          rdBuffer[0].rs2 <= 'x;
           decodeBuffer.rd <= 'X;
        end
    end


  executionStage IE(clk,decodeBuffer.instruction, decodeBuffer.rd, decodeBuffer.readData1, decodeBuffer.readData2, decodeBuffer.immOut, decodeBuffer.pc ,controlBuffer[0].cntrl,aluOut,branchAddress, branchTaken, writeData ,executionRd);
  always_ff@(posedge clk)
    begin
 
      executionBuffer.aluOut <= aluOut;
      executionBuffer.branchAddress <= branchAddress;
      executionBuffer.branchTaken <= branchTaken;
      executionBuffer.writeData <= writeData;
      executionBuffer.haltSignal <= decodeBuffer.haltSignal;
      executionBuffer.rd <= executionRd;
      executionBuffer.instruction <=decodeBuffer.instruction;
      executionBuffer.branchTaken <= branchTaken;
      controlBuffer[1].cntrl<= controlBuffer[0].cntrl;
      rdBuffer[1].rd <= rdBuffer[0].rd;
      rdBuffer[1].rs1 <= rdBuffer[0].rs1;
      rdBuffer[1].rs2 <= rdBuffer[0].rs2;
        
    end

  memStage IM(clk,reset,executionBuffer.aluOut, executionBuffer.writeData, executionBuffer.aluOut, controlBuffer[1].cntrl, memDataOut, writeBackData);
  always_ff@(posedge clk)
    begin
      memBuffer.instruction <=executionBuffer.instruction;
      memBuffer.memDataOut <= memDataOut;
      memBuffer.writeBackData <= writeBackData;
      memBuffer.haltSignal <= executionBuffer.haltSignal;
      memBuffer.rd <= executionBuffer.rd;
      // memBuffer.cntrl <= executionBuffer.cntrl;
      controlBuffer[2].cntrl<= controlBuffer[1].cntrl;
      rdBuffer[2].rd <= rdBuffer[1].rd;
      rdBuffer[2].rs1 <= rdBuffer[1].rs1;
      rdBuffer[2].rs2 <= rdBuffer[1].rs2;
    end
  writeBackStage WB(clk,memBuffer.instruction,memBuffer.rd ,memBuffer.writeBackData, memBuffer.memDataOut , 
                    controlBuffer[2].cntrl, wbData,memBuffer.haltSignal,wbRd);



  final
  begin
    $display("\n/////////////////////////////////////////////////////////////////////");
    $display("==================== Pipeline No forwarding ====================");
    $display("/////////////////////////////////////////////////////////////////////");
    $display("\n==================== Instruction Counts ====================");
    $display("Toatl number of instructions = %0d", instructionCount);
    $display("Arithmetic Instructions = %0d", arithmeticInstrCount);
    $display("Logical Instructions = %0d", logicalInstrCount);
    $display("Memory access instruction = %0d", memoryInstrCount);
    $display("Control transfer instruction = %0d", branchInstrCount);
    $display("\n==================== Final Register Status ====================");
    $display("Program Counter = %0d", IF.PC.q);
    for (int i=11; i< 26; i++)
      begin
        $display("R%0d = %0d", i, $signed(ID.RF.registerFile[i]));
      end
    dataOut = {>>MEMWIDTH{IM.DM.dataMem[1400 +: BYTESPERINSTRUCTION]}};
    $display("\n==================== Final Memory State ====================");
    $display("Address = 1400 Contents =%0d",dataOut);
    dataOut = {>>MEMWIDTH{IM.DM.dataMem[1404 +: BYTESPERINSTRUCTION]}};
    $display("Address = 1404 Contents =%0d", dataOut);
    dataOut = {>>MEMWIDTH{IM.DM.dataMem[1408 +: BYTESPERINSTRUCTION]}};
    $display("Address = 1408 Contents =%0d",dataOut);
    $display("\n==================== Timing Simulator ====================");
    $display("Total number of clock Cycles = %0d", finalClockCount);
    $display("STALLS=%0d",stalls);
    
    $display("Total data hazard=%0d", dataHazards);

  end


endmodule