module top();
  import mips_pkg::*;
  
  logic [DATA-1:0]a;
  logic[DATA-1:0]b;
  logic sel;
  logic[DATA-1:0]out;

  mux2x1 mux(a,b,sel,out);

  initial
  begin
    a='1;
    b=0;
    sel='1;
    #5;
    a='1;
    b='0;
    sel='0;
  end
  initial
    begin
      $monitor("a=%0d b=%0d sel=%b out=%0d",a,b,sel,out);
    end
endmodule
  
