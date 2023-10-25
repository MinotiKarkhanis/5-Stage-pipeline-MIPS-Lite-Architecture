module top();
  parameter DATAPATH_WIDTH=32;
  parameter ADDRESS_WIDTH=32;
  localparam MEMDEPTH= 2**ADDRESS_WIDTH;
  localparam NUMBEROFBYTES=DATAPATH_WIDTH/8;
  localparam CYCLE = 10;
  localparam HCYCLE = CYCLE/2;

   bit clk;
  logic memWriteEnable;
  logic [DATAPATH_WIDTH-1:0] dataIn;
  logic [ADDRESS_WIDTH-1:0]address;
  logic [DATAPATH_WIDTH-1:0] dataOut;


  dataMemory d1(clk,memWriteEnable,dataIn,address,dataOut);

  always #HCYCLE clk=~clk;

  initial
    begin
      @(negedge clk);
      memWriteEnable='1;
      address='0;
      dataIn=32'h8;
      @(negedge clk);
      memWriteEnable='1;
      address=32'h0000004;
      dataIn=32'h00001234;
	  @(negedge clk);
      memWriteEnable='0;
      @(negedge clk);
      address ='0;
      @(negedge clk);
      $display("%h",dataOut);
      address =32'h0000004;
      @(negedge clk);
      $display("%h",dataOut);
      $finish;
    end
  initial
    begin
        $dumpfile("dump.vcd");
  		$dumpvars;
    end

endmodule
