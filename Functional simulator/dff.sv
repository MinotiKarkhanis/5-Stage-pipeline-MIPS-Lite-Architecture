`include "mipspkg.sv"
module programCounter(clk, reset, d, q);
  import mips_pkg::*;
  input logic clk,reset;
  input logic [DATA-1:0] d;
  output logic [DATA-1:0] q;
  
  always_ff@(posedge clk, posedge reset)
    begin
      if(reset)
        q<=0;
      else
        q<=d;
    end
endmodule