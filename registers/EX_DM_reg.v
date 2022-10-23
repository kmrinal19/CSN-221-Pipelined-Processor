module EX_DM_register (
    ALU_result, ALU_result_out_ex_dm, mem_read_in, mem_write_in, Write_data_in, rd_in_ex_dm, Mem_address, mem_read_out_ex_dm, mem_write_out_ex_dm, Write_data_out, mem_to_reg_in, reg_write_in, mem_to_reg_out_ex_dm, reg_write_out_ex_dm, clk, reset, rd_out_ex_dm, branch_out_ex, branch_out_ex_dm,pcout_ex, pcout_ex_dm
);
input mem_to_reg_in, clk, reset, branch_out_ex;
input wire [4:0] rd_in_ex_dm;
input wire mem_read_in, mem_write_in, reg_write_in;
input wire [31:0] ALU_result, Write_data_in, pcout_ex;
output reg mem_read_out_ex_dm, mem_write_out_ex_dm, reg_write_out_ex_dm;
output reg [31:0] Mem_address, Write_data_out, pcout_ex_dm;
output reg mem_to_reg_out_ex_dm, branch_out_ex_dm;
output reg [4:0] rd_out_ex_dm;
output reg [31:0] ALU_result_out_ex_dm;
reg flag_ex_dm;
always @(posedge reset)
    begin
      flag_ex_dm = 1'b1;
    end
always @(negedge clk)
    begin
        if(branch_out_ex == 1)
        begin
            pcout_ex_dm = pcout_ex;
            branch_out_ex_dm = 1;
            mem_read_out_ex_dm <= 0;
            mem_write_out_ex_dm <= 0;
            mem_to_reg_out_ex_dm <= 0;
            reg_write_out_ex_dm <= 0;
        end
        else
        begin
            ALU_result_out_ex_dm <= ALU_result;
            rd_out_ex_dm <= rd_in_ex_dm;
            mem_read_out_ex_dm <= mem_read_in;
            mem_write_out_ex_dm <= mem_write_in;
            Write_data_out <= Write_data_in;
            mem_to_reg_out_ex_dm <= mem_to_reg_in;
            reg_write_out_ex_dm <= reg_write_in;
            branch_out_ex_dm <= 0;
        end
    end
endmodule