module SignExtend(clk, inp ,out);

input clk;
input  [15:0] inp;
output reg [31:0] out;


always @(posedge clk)
begin
    out =  (inp[15] == 1)? {16'hffff , inp} : (inp[15] == 0)? {16'h0000 ,inp}  : 16'hxxxx;
end

endmodule
