`include "dff.sv"
`include "adder.sv"
`include "instructionMemory.sv"
module instructionFetch(clk,reset, haltSignal, hazardDetected,branchAddress, branchTaken, pcPlus4,instruction,pc);
  import mips_pkg::*;
  
  input logic clk;
  input logic reset;
  input logic haltSignal;
  input logic [ADDRESSWIDTH-1:0] branchAddress;
  input logic branchTaken;
  input logic hazardDetected;
  
  output Instruct instruction;
  output logic [ADDRESSWIDTH-1:0] pc;
  logic [ADDRESSWIDTH-1:0] branchMuxOut;
  logic [ADDRESSWIDTH-1:0] pcNext; 
  output logic [ADDRESSWIDTH-1:0] pcPlus4;
  logic addressOutOfBound;
  
  programCounter PC(clk, reset,branchTaken, haltSignal, hazardDetected, branchMuxOut, pc);
  
  adder add(pc,32'h4,'0,pcPlus4,addressOutOfBound);
  
  instructionMemory IM(pc,branchTaken,instruction);
  
  mux2x1 BRANCH(branchAddress, pcPlus4, branchTaken,branchMuxOut);
  
  
  
endmodule