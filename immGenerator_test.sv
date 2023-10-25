// Code your testbench here
// or browse Examples
module top();
  import mips_pkg::*;
  
  
  Instruct instr;
  logic [DATA-1:0] immOut;
   
  immGenerator imm(instr, immOut);
  
  initial
    begin
      #5;
      instr.opcode=6'b000001;
      instr.Type.I.imm=16'h8001;
      #5;
      $display("immOut=%h", immOut);
     
    end
    
endmodule