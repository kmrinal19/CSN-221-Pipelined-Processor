`include "decode_unit/RegisterFile.v"
`include "decode_unit/SignExtend.v"

module instruction_decoder (
    reg_write_cu,
    clk,
    reset,
    inst_read_reg_addr1,
    inst_read_reg_addr2,
    rd,
    reg_wr_data,
    inst_imm_field,
    reg_write,
    reg_file_rd_data1,
    reg_file_rd_data2,
    imm_field_wo_sgn_ext,
    sgn_ext_imm,
    imm_sgn_ext_lft_shft,
    reg_wr_addr_wb,
    inst_read_reg_addr1_out_id,
    inst_read_reg_addr2_out_id,
    rd_out_id,
    jump_in,
    jump_out_id
);
    input clk, reset, reg_write, jump_in;
    input [4:0] inst_read_reg_addr1 ,inst_read_reg_addr2, rd, reg_wr_addr_wb;
    input [15:0] inst_imm_field;
    input [31:0] reg_wr_data;
    input reg_write_cu;
    output [31:0] reg_file_rd_data1, reg_file_rd_data2, sgn_ext_imm, imm_sgn_ext_lft_shft;
    output reg [15:0] imm_field_wo_sgn_ext;
    output reg [4:0] rd_out_id, inst_read_reg_addr2_out_id, inst_read_reg_addr1_out_id;
    output reg jump_out_id;
    wire [4:0] reg_wr_addr;


    always @(posedge clk)
        begin
            jump_out_id <= jump_in;
            rd_out_id <= rd;
            inst_read_reg_addr2_out_id <= inst_read_reg_addr2;
            inst_read_reg_addr1_out_id <= inst_read_reg_addr1;
        end


    RegisterFile registerFile(inst_read_reg_addr1, inst_read_reg_addr2, reg_wr_addr_wb, reg_wr_data, reg_write, clk, reg_file_rd_data1, reg_file_rd_data2, reset);

    // sign extension
    SignExtend signExtend(clk, inst_imm_field, sgn_ext_imm);

    // left shift
    assign imm_sgn_ext_lft_shft = sgn_ext_imm << 2;

    always @(posedge clk)
        imm_field_wo_sgn_ext <= inst_imm_field;

endmodule