`include "mipspkg.sv"
//`include "instruction.mem"
module instructionMemory(address, instruction);
  //package importing
  import mips_pkg::*;

  //parameter declaration
  parameter FILENAME = "instruction.mem";

  
  
 

  // Input and output declaration
  input logic [ADDRESSWIDTH-1:0] address;
  output Instruct instruction;

  //Memory array declaration
  logic [MEMWIDTH-1:0] instructMem [MEMDEPTH-1:0];

  initial 
    begin
      logic [INSTRUCTION_WIDTH-1:0] tempMem [(MEMDEPTH/BYTESPERINSTRUCTION)-1:0];
      $readmemh(FILENAME,tempMem);
      instructMem ={>>MEMWIDTH{tempMem}};
    end
  
    generate
    always_comb begin
      if (address[$clog2(BYTESPERINSTRUCTION)-1:0]==0) begin
        instruction = {>>MEMWIDTH{instructMem[address +: BYTESPERINSTRUCTION]}};
      end
      else begin
        instruction = 'hDEADBEEF;
      end
    end
  endgenerate

  
endmodule