module waitStateUnit(clk,reset,count, hazard, forward1, forward2, hazardDetected);
  import mips_pkg::*;
  input logic clk;
  input logic reset;
  input logic[1:0]count;
  input logic forward1, forward2;
  input logic hazard;
  output logic hazardDetected;
  
  
  logic [1:0] waitCount;
  logic set;
  
  
  always_ff@(posedge clk)
  begin
    if(hazard && set=='0)
      begin
      waitCount <='0;
      set <='1;
      end
    else if( set=='1 && waitCount!==count)
      begin
        waitCount <= waitCount + 1'b1;
        //stalls <= stalls +1;
      end
    else 
      begin
      set<=0;
      waitCount <='0;
      end
    if( set=='1 && waitCount!==count && (forward1 =='0 && forward2 =='0) && hazardDetected=='1)
      begin
        stalls <= stalls +1;
      end
  end
  always_comb
    begin
      if(hazard || set=='1)
         begin
        hazardDetected ='1;
         end
      else 
        hazardDetected='0;
        
      if(waitCount == count)
        hazardDetected = '0;
       
    end
endmodule