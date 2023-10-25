`include "mipspkg.sv" 
module controller(instr, cntrl);
  import mips_pkg::*;
  input Instruct instr;
  output Control cntrl;

  always_comb
    begin
      case(instr.opcode)
        6'h00 : begin
          //add;
          cntrl.memWriteEnable ='0;
          cntrl.regWrite='1;
          cntrl.writeBack = '1;
          cntrl.wbMux = '1;
          cntrl.rs2 = '1;
          cntrl.jump = '0;
          cntrl.aluop=3'b000;
          
        end
        6'h01 : begin
          //addi
          cntrl.memWriteEnable ='0;
          cntrl.regWrite='1;
          cntrl.writeBack = '1;
          cntrl.wbMux = '1;
          cntrl.rs2 = '0;
          cntrl.jump = '0;
          cntrl.aluop =3'b000;
        end
        6'h02 : begin
          //sub
          cntrl.memWriteEnable ='0;
          cntrl.regWrite='1;
          cntrl.writeBack = '1;
          cntrl.wbMux = '1;
          cntrl.rs2 = '1;
          cntrl.jump = '0;
          cntrl.aluop = 3'b001;
        end
        6'h03 : begin
          //subi
          cntrl.memWriteEnable ='0;
          cntrl.regWrite='1;
          cntrl.writeBack = '1;
          cntrl.wbMux = '1;
          cntrl.rs2 = '0;
          cntrl.jump = '0;
          cntrl.aluop = 3'b001;
        end
          6'h04 :begin
            // mul
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '1;
            cntrl.jump = '0;
            cntrl.aluop=3'b010;
          end
          6'h05 : begin
            //muli
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '0;
            cntrl.jump = '0;
            cntrl.aluop =3'b010;
          end
          6'h06 : begin
            //or
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '1;
            cntrl.jump = '0;
            cntrl.aluop = 3'b011;
          end
          6'h07 : begin
            //ori
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '0;
            cntrl.jump = '0;
            cntrl.aluop = 3'b011;
          end
          6'h08 : begin
            //and
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '1;
            cntrl.jump = '0;
            cntrl.aluop = 3'b100;
          end
          6'h09 : begin
            //andi
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '0;
            cntrl.jump = '0;
            cntrl.aluop = 3'b100;
          end
          6'h0A : begin
            //xor
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '1;
            cntrl.jump = '0;
            cntrl.aluop = 3'b101;
          end
          6'h0B : begin
            //XORI
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '1;
            cntrl.rs2 = '0;
            cntrl.jump = '0;
            cntrl.aluop = 3'b101;
          end
          6'h0C : begin
            //ldw
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='1;
            cntrl.writeBack = '1;
            cntrl.wbMux = '0;
            cntrl.rs2 = '0;
            cntrl.aluop = 3'b000;
          end
          6'h0D : begin
            //stw
            cntrl.aluop = 3'b000;
            cntrl.memWriteEnable ='1;
            cntrl.rs2 = '0;
            cntrl.jump = '0;
            cntrl.regWrite='0;
          end
          6'h0E : begin
            //bz
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='0;
            cntrl.rs2 = '0;
            cntrl.jump = '0;
            cntrl.aluop = 3'b110;
          end
          6'h0F : begin
            // BEQ
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='0;
            cntrl.rs2 = '1;
            cntrl.jump = '0;
            cntrl.aluop = 3'b111;
          end
          6'h10 : begin
            //JR
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='0;
            cntrl.rs2 = '0;
            cntrl.jump = '1;
            cntrl.aluop= 3'b000;
          end
          6'h11 : begin
            //HALT
            cntrl.memWriteEnable ='0;
            cntrl.regWrite='0;
            //cntrl.writeBack = '1;
           // cntrl.wbMux = '1;
            cntrl.rs2 = '1;
            cntrl.jump = '0;
            cntrl.aluop= 3'b000;
          end
        default: cntrl.regWrite='0;
          endcase
          end

          endmodule