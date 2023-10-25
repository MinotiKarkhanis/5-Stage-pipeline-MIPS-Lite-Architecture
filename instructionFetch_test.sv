
module top();
  import mips_pkg::*;
  
  parameter CYCLETIME= 10;
  localparam ONTIME = CYCLETIME/2;
  bit clk;
  logic reset;
  Instruct instruction;
  logic [ADDRESSWIDTH-1:0] pc;
  
  instructionFetch IF(clk,reset,pc,instruction);
  
  always #ONTIME clk=~clk;
  
  initial
    begin
      reset='1;
      @(posedge clk);
      reset ='0;
      #10;
      
    end
  initial 
    begin
  $dumpfile("dump.vcd");
  $dumpvars;
   #100;
      $finish;

end

  
 
endmodule