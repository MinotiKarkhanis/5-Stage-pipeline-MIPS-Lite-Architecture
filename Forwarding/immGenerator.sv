//`include "registerFile.sv"
`include "mipspkg.sv"
module immGenerator(instr,immOut);
  import mips_pkg::*;
  
  input Instruct instr;
  output logic [DATA-1:0] immOut;
  always_comb
    begin
      unique case(instr.opcode)
        6'b000001: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b000011: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b000101: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b000111: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b001001: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b001011: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b001100: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b001101: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b001110: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        6'b001111: immOut={{DATA-IMMSIZE{instr.Type.I.imm[IMMSIZE-1]}},instr.Type.I.imm};
        default : immOut = 'x;
      endcase
    end
endmodule