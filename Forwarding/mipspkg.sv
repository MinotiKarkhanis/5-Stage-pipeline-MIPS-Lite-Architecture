//This file contains the package for MIPS lite simulator
//**************************************** MIPS LITE SIMULATOR *************************************** 

`ifndef MIPS_LITE
`define MIPS_LITE

package mips_pkg;
parameter IMMSIZE=16;
parameter OPCODE =6;
parameter REGISTERNUMBER= 32;
parameter DATA = 32;
parameter ADDRESSWIDTH=32;
//parameter INSTRUCTION_WIDTH=32;
localparam REGISTERWIDTH = $clog2(REGISTERNUMBER);
localparam MEMDEPTH = 4096;
localparam  MEMWIDTH=8;
localparam INSTRUCTION_WIDTH=32;
localparam BYTESPERINSTRUCTION= INSTRUCTION_WIDTH/MEMWIDTH;

int instructionCount;
int arithmeticInstrCount;
int logicalInstrCount;
int memoryInstrCount;
int branchInstrCount;
int clockCount;
int stalls;
int dataHazards;

logic [MEMDEPTH-1:0] memWriteStatus;
int finalClockCount;

typedef union packed{
  
  struct packed {
    logic [REGISTERWIDTH-1:0] rs;
    logic [REGISTERWIDTH-1:0] rt;
    logic [REGISTERWIDTH-1:0] rd;
    logic[10:0] unused;
  }R;
  
  struct packed{
    logic [REGISTERWIDTH-1:0] rs;
    logic [REGISTERWIDTH-1:0] rt;
    logic [IMMSIZE-1:0] imm;
  }I;

}instruction;

typedef struct packed{
  logic[OPCODE-1:0] opcode;
  instruction Type;
}Instruct;


typedef struct packed{
  logic memWriteEnable;
  logic regWrite;
  logic writeBack;
  logic wbMux;
  logic rs2;
  logic jump;
  logic [2:0] aluop;
}Control;

//pipeline buffers
struct packed{
  logic [ADDRESSWIDTH-1:0] pc;
  Instruct instruction;  
}fetchBuffer;

struct packed{
  Instruct instruction;
  logic [DATA-1:0] readData1;
  logic [DATA-1:0] readData2;
  logic [DATA-1:0] immOut;
  logic [ADDRESSWIDTH-1:0] pc;
  Control cntrl;
  logic haltSignal;
  logic forward1;
  logic forward2;
  logic memForward1;
  logic memForward2;
  logic wbForward1;
  logic wbForward2;
}decodeBuffer;

struct packed {
  logic [DATA-1:0] aluOut;
  logic [ADDRESSWIDTH-1:0] branchAddress;
  logic [DATA-1:0] writeData;
  Control cntrl;
  logic branchTaken;
  logic haltSignal;

}executionBuffer;

struct packed{
  logic [DATA-1:0] memDataOut;
  logic [DATA-1:0] writeBackData;
  Control cntrl;
  logic branchTaken;
  logic haltSignal;

}memBuffer;

struct packed{
Control cntrl;
}controlBuffer[2:0];

struct packed{
  logic [REGISTERWIDTH-1:0] rs1;
  logic [REGISTERWIDTH-1:0] rs2;
  logic [REGISTERWIDTH-1:0] rd;
 
} rdBuffer[2:0];

struct packed{
 Instruct instruction;
}instructionBuffer[2:0];

task countInstruction();
  instructionCount = instructionCount + 1;
endtask

task countArithmeticInstruction();
  arithmeticInstrCount = arithmeticInstrCount + 1;
endtask

task countLogicalInstruction();
  logicalInstrCount = logicalInstrCount + 1;
endtask

task countMemoryInstruction();
  memoryInstrCount = memoryInstrCount + 1;
endtask

task countBranchInstruction();
  branchInstrCount = branchInstrCount + 1;
endtask


task hazardDetection(rdBuffer,rd1,rd2);
  
endtask

endpackage


`endif