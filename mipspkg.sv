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

logic [MEMDEPTH-1:0] memWriteStatus;

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


endpackage


`endif