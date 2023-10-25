module top();
  import mips_pkg::*;
  parameter CYCLETIME = 10;
  localparam ONTIME = CYCLETIME/2;
  bit clk;
  Instruct instruction;

  logic [DATA-1:0] writeData;
  logic [DATA-1:0] immOut;
  logic [DATA-1:0] readData1;
  logic [DATA-1:0] readData2;
  logic writeEnable;

  decodeStage dec(clk,writeEnable, instruction, writeData, immOut, readData1, readData2);

  always #ONTIME clk=~clk;
  initial 
    begin
      @(posedge clk);
      instruction = 32'h040103E8;
      
    end


  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #100;
      $finish;

    end
endmodule