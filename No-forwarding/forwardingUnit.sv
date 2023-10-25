module forwardingDetection(rs1,rs2,forward);
  import mips_pkg::*;
  input logic [REGISTERWIDTH-1:0] rs1;
  input logic [REGISTERWIDTH-1:0] rs2;
  output logic hazard;
  output logic [1:0] count;

  always_comb
    begin
      if(rs1==rdBuffer[0].rd || rs2==rdBuffer[0].rd)
        begin
          count=2'b10;
          hazard ='1;
        end
      else if (rs1==rdBuffer[1].rd || rs2==rdBuffer[1].rd)
        begin
          count =2'b01;
          hazard ='1;
        end
      else
        begin
          hazard = '0;
        end

    end
endmodule