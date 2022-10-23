module SignExtend(clk, stall_flag, inp ,out);

input clk, stall_flag;
input  [15:0] inp;
output reg [31:0] out;


always @(posedge clk)
if (stall_flag==0)
begin
begin
    out =  (inp[15] == 1)? {16'hffff , inp} : (inp[15] == 0)? {16'h0000 ,inp}  : 16'hxxxx;
end
end
endmodule
