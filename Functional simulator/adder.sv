`include "mipspkg.sv"
module adder(a,b,cin,sum,cout);
  import mips_pkg::*;
  input logic[DATA-1:0] a,b;
  input logic cin;
  output logic [DATA-1:0] sum;
  output logic cout;
  
  always_comb
    begin
      {cout,sum} = a + b + cin;
    end
endmodule