`include "mipspkg.sv"
module hazardDetection(rs1,rs2,instruction, hazard, count);
  import mips_pkg::*;
  input logic [REGISTERWIDTH-1:0] rs1;
  input logic [REGISTERWIDTH-1:0] rs2;
  input Instruct instruction;
  output logic hazard;
  output logic [1:0] count;


  always_comb
    begin

      if(rs1==rdBuffer[0].rd || rs2==rdBuffer[0].rd )
        begin
          begin
            if(instructionBuffer[0].instruction.opcode==6'h0C || instruction.opcode!==6'h09 )
              begin
                count=2'b10;
                hazard ='1;
              end
          end
        end
      else if (rs1==rdBuffer[1].rd || rs2==rdBuffer[1].rd)
        begin
          if(instructionBuffer[0].instruction.opcode!==6'h09 || instruction.opcode!==6'h09 )
            count =2'b10	;
          hazard ='1;
        end
      else
        begin
          hazard = '0;
        end
    end

endmodule