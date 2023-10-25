`include "mipspkg.sv"
module decoder(instruction,rs1, rs2, rd);
  import mips_pkg::*;

  input Instruct instruction;
  output logic [REGISTERWIDTH-1:0] rs1,rs2, rd;

  always_comb
    begin
      
      
      unique case(instruction.opcode) 
        6'b000000: begin
          //add
          countInstruction();
          countArithmeticInstruction();
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b000001: begin
          //addi
          countInstruction();
          countArithmeticInstruction();
          rs1 = instruction.Type.I.rs;
          rd =  instruction.Type.I.rt;
        end
        6'b000010: begin
          //sub
          countInstruction();
          countArithmeticInstruction();
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd  = instruction.Type.R.rd;
        end

        6'b000011: begin
          //subi
          countInstruction();
          countArithmeticInstruction();
          rs1 = instruction.Type.I.rs;
          rd  = instruction.Type.I.rt;
        end

        6'b000100: begin
          //Mul
          countInstruction();
          countArithmeticInstruction();
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b000101: begin
          //Muli
          countInstruction();
          countArithmeticInstruction();
          rs1 = instruction.Type.I.rs;
          rd = instruction.Type.I.rt;
        end
        6'b000110: begin
          //OR
          countInstruction();
          countLogicalInstruction();
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b000111: begin
          //ORI
          countInstruction();
          countLogicalInstruction();
          rs1 = instruction.Type.I.rs;
          rd = instruction.Type.I.rt;
        end
        6'b001000: begin
          //and
          countInstruction();
          countLogicalInstruction();
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b001001: begin
          //andi
          countInstruction();
          countLogicalInstruction();
          rs1 = instruction.Type.I.rs;
          rd = instruction.Type.I.rt;
        end
        6'b001010: begin
          //xor
          countInstruction();
          countLogicalInstruction();
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b001011: begin
          //xori
          countInstruction();
          countLogicalInstruction();
          rs1 = instruction.Type.I.rs;
          rd = instruction.Type.I.rt;
        end
        6'b001100: begin
          //ldw
          countInstruction();
          countMemoryInstruction();
          rs1 = instruction.Type.I.rs;
          rd= instruction.Type.I.rt;
        end
        6'b001101: begin
          //stw
          countInstruction();
          countMemoryInstruction();
          rs1 = instruction.Type.I.rs;
          rs2 = instruction.Type.I.rt;
        end
        6'b001110: begin
          //BZ
          countInstruction();
          countBranchInstruction();
          rs1 = instruction.Type.I.rs;
        end
        6'b001111: begin
          //BEQ
          countInstruction();
          countBranchInstruction();
          rs1 =  instruction.Type.I.rs;
          rs2 = instruction.Type.I.rt;
        end
        6'b010000: begin
          //JR
          countInstruction();
          countBranchInstruction();
          rs1 = instruction.Type.I.rs;
        end
        6'b010001: begin
          //HALT
          countInstruction();
          countBranchInstruction();
          $finish;
        end
        default: begin
          rs1 = 'x;
          rs2 = 'x;
          rd = 'x;
        end

      endcase
    end

endmodule
