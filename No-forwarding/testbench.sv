module top();
  parameter CYCLETIME = 10;
  localparam ONTIME = CYCLETIME/2;

  bit clk;
  logic reset;

  mipsLiteProcessor PROCESSOR(clk,reset);



  always #ONTIME clk = ~clk;
  initial 
    begin
      reset ='1;
      repeat (2)@(posedge clk);
      reset ='0;
    end

  initial 
    begin 
      $dumpfile("dump.vcd");
      $dumpvars;
    end

endmodule