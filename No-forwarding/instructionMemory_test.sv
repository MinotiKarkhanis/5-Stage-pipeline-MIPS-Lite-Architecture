module top();
  import mips_pkg::*;
  logic [ADDRESSWIDTH-1:0] address;
  Instruct instruction;
  
  instructionMemory IM(address, instruction);
  initial
    begin
      address = '0;
      #5;
      $display("%h", instruction);
      address = 4;
      #5;
      $display("%h", instruction);
      address = 8;
      #5;
      $display("%h", instruction);
      address = 12;
      #5;
      $display("%h", instruction);
    end
endmodule