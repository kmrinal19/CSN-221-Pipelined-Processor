module IF_ID_reg(currpc, nextpc ,inp_instn ,out_instn ,clk ,PCplus4Out, currpc_out, jump_in, jump_out, jump_address, reset);

  input wire [31:0] inp_instn,nextpc, currpc;
  input clk, reset, jump_in;
  reg flag_if_id;
  output reg [31:0] out_instn, PCplus4Out, currpc_out;
  reg [31:0] t_inp_instn, t_nextpc, t_currpc;
  output reg[25:0] jump_address;
  output reg jump_out;

  always @(posedge reset)
    begin
      flag_if_id = 1'b0;
    end

  always @(negedge clk)
    begin
      jump_address = out_instn[25:0];
      PCplus4Out <= nextpc;
      currpc_out <= currpc;
      out_instn = inp_instn;
      jump_out <= jump_in;
      $display("time = %3d IF ID: Ouput inst: %b jump_address: %b", $time, out_instn, jump_address);
    end

endmodule
