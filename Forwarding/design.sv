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

  Instruct instruction,instr, instrMem, instrDec;
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
  logic [REGISTERWIDTH-1:0] rd,rs1,rs2;
  logic hazardDetected;
  logic haltSignal;
  logic forward1, forward2, memForward1, memForward2, wbForward1, wbForward2;
  initial 
    begin
      if($value$plusargs("TEST = %s",TEST))
        $display("string = %s",TEST);
    end

  //instruction Fetch stage
  instructionFetch IF(clk, reset, haltSignal, hazardDetected, branchAddress, branchTaken, pcPlus4, instruction,pc);

  always_comb
  begin
    if(haltSignal)
    finalClockCount = clockCount + 3;
  end
  //IF AND DECODE Buffer
  always_ff@(posedge clk)
    begin
      if(reset)
        begin
        clockCount<=0;
          //haltSignal<='0;
        end
      else
        begin
          if(forward1=='0 && forward2 =='0)
          clockCount<= clockCount+1;
          if(!hazardDetected )
            begin
          fetchBuffer.instruction <=instruction;
          fetchBuffer.pc <= pc;
            end
          if(branchTaken)
          begin
          fetchBuffer.instruction <='x;
            fetchBuffer.pc <= pc;
             //clockCount <= clockCount-1;
            end
          
           // clockCount<= clockCount-1;
        end
    end


  decodeStage ID(clk,reset,branchTaken,fetchBuffer.pc,controlBuffer[2].cntrl, rdBuffer[2].rd , writeEnable, fetchBuffer.instruction, wbData, cntrl, immOut, readData1, readData2,pcOut, rs1, rs2, rd,hazardDetected,haltSignal,forward1, forward2,memForward1, memForward2,wbForward1, wbForward2, instrDec);

  always_ff@(posedge clk)
    begin
      if(!hazardDetected && !branchTaken)
        begin
      decodeBuffer.instruction <= instrDec;
      decodeBuffer.readData1 <= readData1;
      decodeBuffer.readData2 <= readData2;
      decodeBuffer.immOut <= immOut;
      decodeBuffer.pc <= pcOut;
      decodeBuffer.forward1 <= forward1;
      decodeBuffer.forward2 <= forward2;
      decodeBuffer.memForward1 <= memForward1;
      decodeBuffer.memForward2 <= memForward2;
          decodeBuffer.wbForward1 <= wbForward1;
          decodeBuffer.wbForward2 <= wbForward2;
      decodeBuffer.haltSignal<=haltSignal;
      instructionBuffer[0].instruction <= instrDec;
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
      decodeBuffer.forward1 <= forward1;
      decodeBuffer.forward2 <= forward2;
      decodeBuffer.memForward1 <= memForward1;
      decodeBuffer.memForward2 <= memForward2;
                    decodeBuffer.wbForward1 <= wbForward1;
          decodeBuffer.wbForward2 <= wbForward2;
      decodeBuffer.haltSignal<=haltSignal;
          instructionBuffer[0].instruction <= instrDec;
      //decodeBuffer.cntrl <= cntrl;
          controlBuffer[0].cntrl<= '0;
          rdBuffer[0].rd <= '0;
          rdBuffer[0].rs1 <= '0;
          rdBuffer[0].rs2 <= '0;
        end
    end


  executionStage IE(clk,instructionBuffer[0].instruction, decodeBuffer.readData1, decodeBuffer.readData2, decodeBuffer.immOut, decodeBuffer.pc ,controlBuffer[0].cntrl,aluOut,branchAddress, branchTaken, writeData, decodeBuffer.forward1, decodeBuffer.forward2,decodeBuffer.memForward1, decodeBuffer.memForward2,           decodeBuffer.wbForward1, decodeBuffer.wbForward2, memBuffer.memDataOut,memBuffer.writeBackData, instr);
  always_ff@(posedge clk)
    begin
      
      executionBuffer.aluOut <= aluOut;
      executionBuffer.branchAddress <= branchAddress;
      executionBuffer.branchTaken <= branchTaken;
      executionBuffer.writeData <= writeData;
      executionBuffer.haltSignal <= decodeBuffer.haltSignal;
      instructionBuffer[1].instruction <= instr;
      //executionBuffer.cntrl <= decodeBuffer.cntrl;
      controlBuffer[1].cntrl<= controlBuffer[0].cntrl;
      rdBuffer[1].rd <= rdBuffer[0].rd;
      rdBuffer[1].rs1 <= rdBuffer[0].rs1;
      rdBuffer[1].rs2 <= rdBuffer[0].rs2;
        
    end

  memStage IM(clk,reset,instructionBuffer[1].instruction, executionBuffer.aluOut, executionBuffer.writeData, executionBuffer.aluOut, controlBuffer[1].cntrl, memDataOut, writeBackData, instrMem);
  always_ff@(posedge clk)
    begin
      instructionBuffer[2].instruction <= instrMem;
      memBuffer.memDataOut <= memDataOut;
      memBuffer.writeBackData <= writeBackData;
      memBuffer.haltSignal <= executionBuffer.haltSignal;
      // memBuffer.cntrl <= executionBuffer.cntrl;
      controlBuffer[2].cntrl<= controlBuffer[1].cntrl;
      rdBuffer[2].rd <= rdBuffer[1].rd;
      rdBuffer[2].rs1 <= rdBuffer[1].rs1;
      rdBuffer[2].rs2 <= rdBuffer[1].rs2;
    end
  writeBackStage WB(clk,memBuffer.writeBackData, memBuffer.memDataOut , 
                    controlBuffer[2].cntrl, wbData,memBuffer.haltSignal);



 
  final
  begin
    $display("\n/////////////////////////////////////////////////////////////////////");
    $display("==================== Pipeline with forwarding ====================");
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
    $display("\n==================== Final Memory State ====================");
       for(int i=0;i<MEMDEPTH-1; i=i+4)
      begin
        if(memWriteStatus[i]=='1)
          begin
        dataOut = {>>MEMWIDTH{IM.DM.dataMem[i +: BYTESPERINSTRUCTION]}};
                    $display("Address = %0d Contents =%0d",i,dataOut);

          end
      end
   // dataOut 
    $display("\n==================== Timing Simulator ====================");
    $display("Total number of clock Cycles = %0d", finalClockCount);
    $display("STALLS=%0d",stalls);
    $display("Total data hazard=%0d", dataHazards);

  end

endmodule