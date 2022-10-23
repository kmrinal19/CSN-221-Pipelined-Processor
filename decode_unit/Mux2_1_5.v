module Mux2_1_5(inp1, inp2, stall_flag, cs, out);

input stall_flag;
input [4:0] inp1, inp2;
input cs;
output reg [4:0] out;

always @(inp1 or inp2 or cs or stall_flag)
if (stall_flag==0)
    begin
        out = (cs == 1'b0) ? inp1: (cs == 1'b1)? inp2: 5'bx; // To understand: 5'bx
    end
endmodule