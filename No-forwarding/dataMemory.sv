`include "mipspkg.sv"
module dataMemory(clk,reset, memWriteEnable, dataIn, address, dataOut);
  import mips_pkg::*;
  parameter FILENAME = "instruction.mem";
  
  input logic clk;
  input logic reset;
  input logic [DATA-1:0] dataIn;
  input logic [ADDRESSWIDTH-1:0] address;
  input logic memWriteEnable;
  
  output logic [DATA-1:0] dataOut;
  
  logic [MEMWIDTH-1:0] dataMem [MEMDEPTH-1:0];
  
  logic [7:0] data [3:0];
        logic [INSTRUCTION_WIDTH-1:0] tempMem [(MEMDEPTH/BYTESPERINSTRUCTION)-1:0];

    initial 
    begin
      $readmemh(FILENAME,tempMem);
      //dataMem ={>>MEMWIDTH{tempMem}};
      //$display("%p",instructMem);
    end
  always_comb
    begin
      {>>MEMWIDTH{data[0 +: BYTESPERINSTRUCTION]}} = dataIn;
    end
  always_ff@(posedge clk)
    begin
      if(reset)
        begin
          for (int i=0; i< MEMDEPTH ;i++);
          begin
            dataMem ={>>MEMWIDTH{tempMem}};
          end
          //$display("%p",dataMem);
        end
        
      if(memWriteEnable)
        dataMem[address +: BYTESPERINSTRUCTION] <= data;
    end
  always_comb
    begin
      dataOut = {>>MEMWIDTH{dataMem[address +: BYTESPERINSTRUCTION]}};
    end
endmodule