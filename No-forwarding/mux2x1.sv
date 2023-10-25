`include "mipspkg.sv"
module mux2x1(a, b, sel, out);
  import mips_pkg::*;
  
  input logic [DATA-1:0] a;
  input logic [DATA-1:0] b;
  input logic sel;
  output logic[DATA-1:0] out;
  
  assign out = (sel) ? a : b;
endmodule