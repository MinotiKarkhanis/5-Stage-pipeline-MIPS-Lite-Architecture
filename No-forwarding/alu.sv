`include "mipspkg.sv"
module alu(a,b,aluop, jump,out,zero, branchTaken);
  import mips_pkg::*;
  input logic [2:0]aluop;
  input logic jump;
  input logic [DATA-1:0] a,b;
  output logic [DATA-1:0] out;
  output logic zero;
  output logic branchTaken;
  always_comb
    begin
      branchTaken ='0;
      zero= '0;
      case(aluop)
        3'b000: begin
          out = $signed(a) + $signed(b);
          if(jump)
            branchTaken='1;
        end
        3'b001:begin
          out = $signed(a) - $signed(b);
        end
        3'b010: begin
          out = $signed(a)* $signed(b) ;
        end
        3'b011: begin
          out = a | b;
        end
        3'b100: begin
          out =  a & b;
        end
        3'b101: begin
          out = a ^ b ;
        end
        3'b110: begin
          out = (a=='0) ? 1 : '0;
          branchTaken = (a=='0) ? 1 : '0;
        end
        3'b111 : begin
          out = (a==b) ? 1 : '0;
          branchTaken = (a==b) ? 1 : '0;
        end
        default : begin
          branchTaken='0;
          jump ='0;
        end
      endcase
    end
endmodule
