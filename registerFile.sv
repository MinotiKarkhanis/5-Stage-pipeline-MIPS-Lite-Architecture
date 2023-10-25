`include "mipspkg.sv"
module registerFile(clk,reset,writeEnable,rs1,rs2,rd,writeData,readData1,readData2);
  import mips_pkg::*;

  input logic clk;
  input logic reset;
  input logic writeEnable;
  input logic [REGISTERWIDTH-1:0] rs1, rs2,rd;
  input logic [DATA-1:0] writeData;
  output logic [DATA-1:0] readData1, readData2;
  
  logic[DATA-1:0] registerFile [REGISTERNUMBER-1:0];
  
  always_ff@(posedge clk)
    begin
      if(reset)
        begin
          for(int i=0; i < REGISTERNUMBER; i++)
            begin
              registerFile[i] <= '0;
            end
        end
      else if(writeEnable)
        registerFile[rd] <= writeData;
      else
        begin
          registerFile[rd] <= registerFile[rd];
        end
    end
 assign readData1 = (rs1==0) ? '0 : registerFile[rs1];
 assign readData2 = (rs2==0) ? '0 : registerFile[rs2];
  //assign readData1 =  registerFile[rs1];
  //assign readData2 =  registerFile[rs2];
endmodule