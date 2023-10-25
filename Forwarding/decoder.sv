`include "mipspkg.sv"
module decoder(instruction,haltSignal,branchTaken,rs1, rs2, rd);
  import mips_pkg::*;

  input Instruct instruction;
  input logic branchTaken;
  input logic haltSignal;
  output logic [REGISTERWIDTH-1:0] rs1,rs2, rd;

  always_comb
    begin
      if(!branchTaken)
       begin
      
      unique case(instruction.opcode) 
        6'b000000: begin
          //add
          if(!haltSignal)
          begin
          countInstruction();
          countArithmeticInstruction();
           end
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b000001: begin
          //addi
          if(!haltSignal)
            begin
          countInstruction();
          countArithmeticInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd =  instruction.Type.I.rt;
        end
        6'b000010: begin
          //sub
          if(!haltSignal)
            begin
          countInstruction();
          countArithmeticInstruction();
            end
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd  = instruction.Type.R.rd;
        end

        6'b000011: begin
          //subi
          if(!haltSignal)
            begin
          countInstruction();
          countArithmeticInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 ='x;
          rd  = instruction.Type.I.rt;
        end

        6'b000100: begin
          //Mul
          if(!haltSignal)
            begin
          countInstruction();
          countArithmeticInstruction();
            end
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b000101: begin
          //Muli
          if(!haltSignal)
            begin
          countInstruction();
          countArithmeticInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd = instruction.Type.I.rt;
        end
        6'b000110: begin
          //OR
          if(!haltSignal)
            begin
          countInstruction();
          countLogicalInstruction();
            end
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b000111: begin
          //ORI
          if(!haltSignal)
            begin
          countInstruction();
          countLogicalInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd = instruction.Type.I.rt;
        end
        6'b001000: begin
          //and
          if(!haltSignal)
            begin
          countInstruction();
          countLogicalInstruction();
            end
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b001001: begin
          //andi
          if(!haltSignal)
            begin
          countInstruction();
          countLogicalInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2='x;
          rd = instruction.Type.I.rt;
        end
        6'b001010: begin
          //xor
          if(!haltSignal)
            begin
          countInstruction();
          countLogicalInstruction();
            end
          rs1 = instruction.Type.R.rs;
          rs2 = instruction.Type.R.rt;
          rd = instruction.Type.R.rd;
        end
        6'b001011: begin
          //xori
          if(!haltSignal)
            begin
          countInstruction();
          countLogicalInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd = instruction.Type.I.rt;
        end
        6'b001100: begin
          //ldw
          if(!haltSignal)
            begin
          countInstruction();
          countMemoryInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd = instruction.Type.I.rt;
        end
        6'b001101: begin
          //stw
          if(!haltSignal)
            begin
          countInstruction();
          countMemoryInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = instruction.Type.I.rt;
          rd='x;
        end
        6'b001110: begin
          //BZ
          if(!haltSignal)
            begin
          countInstruction();
          countBranchInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd='x;
        end
        6'b001111: begin
          //BEQ
          if(!haltSignal)
            begin
          countInstruction();
          countBranchInstruction();
            end
          rs1 =  instruction.Type.I.rs;
          rs2 = instruction.Type.I.rt;
          rd='x;
        end
        6'b010000: begin
          //JR
          if(!haltSignal)
            begin
          countInstruction();
          countBranchInstruction();
            end
          rs1 = instruction.Type.I.rs;
          rs2 = 'x;
          rd='x;
        end
        6'b010001: begin
          //HALT
          if(!haltSignal)
            begin
          countInstruction();
          countBranchInstruction();
              rs1='x;
              rs2 ='x;
              rd='x;
            end
          //$finish;
        end
        default: begin
          rs1 = 'x;
          rs2 = 'x;
          rd = 'x;
        end

      endcase
        end
      else 
        begin
           rs1 = 'x;
          rs2 = 'x;
          rd = 'x;
        end
    end

endmodule
