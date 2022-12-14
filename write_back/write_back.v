
module WriteBack (rd_in_wb, reg_write, mem_to_reg, alu_data_out, dm_data_out, clk, wb_data, reset, reg_write_out_wb, rd_out_wb);
input mem_to_reg, clk, reset, reg_write;
input [31:0] alu_data_out, dm_data_out;
input wire [4:0] rd_in_wb;
output reg [31:0] wb_data;
output reg reg_write_out_wb;
output reg [4:0] rd_out_wb;

reg t_reg_write_out_wb;
reg[4:0] t_rd_out_wb;
reg[31:0] t_wb_data;

always @(posedge clk)
    begin
        rd_out_wb <= rd_in_wb;
        reg_write_out_wb <= reg_write;
        if (mem_to_reg==1)
            wb_data <= dm_data_out;
        else
            wb_data <= alu_data_out;
    end
endmodule