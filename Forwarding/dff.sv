`include "mipspkg.sv"
module programCounter(clk, reset, haltSignal, hazardDetected, d, q);
  import mips_pkg::*;
  input logic clk,reset;
  input logic haltSignal;
  input logic [DATA-1:0] d;
  input logic hazardDetected;
  output logic [DATA-1:0] q;
  
  always_ff@(posedge clk, posedge reset)
    begin
      if(reset)
        q<=0;
      else if(hazardDetected!='1 && haltSignal!='1)
        q<=d;
    end
endmodule