module forwardingUnit(rs1,rs2,instruction,forward1, forward2, memForward1, memForward2, wbForward1, wbForward2);
  import mips_pkg::*;
  input logic [REGISTERWIDTH-1:0] rs1;
  input logic [REGISTERWIDTH-1:0] rs2;
  input Instruct instruction;
  output bit forward1,forward2,memForward1,memForward2, wbForward1, wbForward2;

  always_comb
    begin
    //  $display("instr =%h instr1 =%h, instr2=%h",instruction, instructionBuffer[0].instruction, instructionBuffer[1].instruction.opcode);
      if(rs1==rdBuffer[0].rd )
        begin
          if(instructionBuffer[0].instruction.opcode!==6'h0C )
            begin
              //count=2'b10;
              forward1 ='1;
              forward2 = '0;
              memForward1 ='0;
              memForward2='0;
              wbForward1 ='0;
              wbForward2 ='0;
            end
        end
      else if( rs2==rdBuffer[0].rd)
        begin
         if(instructionBuffer[0].instruction.opcode!==6'h0C)
           begin
              forward1 ='0;
              forward2 = '1;
              memForward1 ='0;
              memForward2='0;
              wbForward1 ='0;
              wbForward2 ='0;
            end
        end
      /*else if (rs1==rdBuffer[1].rd)
        begin
          //count =2'b01;
          //if(instructionBuffer[1].instruction.opcode==6'h0C)
          forward1 ='0;
          forward2 = '0;
          memForward1 ='1;
          memForward2='0;
          wbForward1 ='0;
          wbForward2 ='0;   
        end
      else if(rs2==rdBuffer[1].rd)
        begin
          if(instructionBuffer[1].instruction.opcode==6'h0C)
            begin
              forward1 ='0;
              forward2 = '0;
              memForward1 ='0;
              memForward2='1;
              wbForward1 ='0;
              wbForward2 ='0;
            end
        end
      else if (rs1==rdBuffer[2].rd)
        begin
          //count =2'b01;
          forward1 ='0;
          forward2 = '0;
          memForward1 ='0;
          memForward2='0;
          wbForward1 ='1;
          wbForward2 ='0;   
        end
      else if(rs2==rdBuffer[2].rd)
        begin
          forward1 ='0;
          forward2 = '0;
          memForward1 ='0;
          memForward2='0;
          wbForward1 ='0;
          wbForward2 ='1;
          $display("instruction= %h",instruction);
          $display("%h",rs2);
          $display("%p",rdBuffer);
          $display("%p",instructionBuffer);
        end*/
      else
        begin
          forward1 ='0;
          forward2 = '0;
          memForward1 ='0;
          memForward2='0;
          wbForward1 ='0;
          wbForward2 ='0;
        end

    end
endmodule