`timescale 1ns / 1ps
`include "decode_unit/instruction_decoder.v"
module testb;
    reg clk, reset; //reset, reg_dst, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    // reg [1:0] alu_op;
    reg [5:0] opcode;
    reg [4:0] inst_read_reg_addr1, inst_read_reg_addr2, rd;
    reg [15:0] inst_imm_field;
    reg [31:0] reg_wr_data;

    wire [31:0] reg_file_rd_data1, reg_file_rd_data2, sgn_ext_imm, imm_sgn_ext_lft_shft;
    wire [15:0] imm_field_wo_sgn_ext;


    instruction_decoder tb (
        .clk (clk),
        .reset(reset),
        .inst_read_reg_addr1(inst_read_reg_addr1),
        .inst_read_reg_addr2(inst_read_reg_addr2),
        .rd(rd),
        .reg_wr_data(reg_wr_data),
        .inst_imm_field(inst_imm_field),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .reg_file_rd_data1(reg_file_rd_data1),
        .reg_file_rd_data2(reg_file_rd_data2),
        .imm_field_wo_sgn_ext(imm_field_wo_sgn_ext),
        .sgn_ext_imm(sgn_ext_imm),
        .imm_sgn_ext_lft_shft(imm_sgn_ext_lft_shft)
    );

    ControlUnit cu (
        .opcode(opcode),
        .reset(reset),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
        );

    initial
    begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    initial
    begin
        reset = 1'b1;
        #100 reset = 1'b0;
    end

    initial
    begin
        #20
        inst_read_reg_addr1 = 5'd1;
        inst_read_reg_addr2 = 5'd2;
        rd = 5'd2;
        reg_wr_data = 32'd25;
        inst_imm_field = 15'd129;
        opcode = 6'b000001;
        #60
        $display ("INSTRUCTION DECODER: time=%3d, rs=%b, rt=%b, rd=%b, reg_wr_data=%b, inst_imm_field=%b, reg_dst=%b, reg_write=%b, reg_file_rd_data1=%d, reg_file_rd_data2=%d, imm_field_wo_sgn_ext=%b, sgn_ext_imm=%b, imm_sgn_ext_lft_shft=%b \n", $time, inst_read_reg_addr1, inst_read_reg_addr2, rd, reg_wr_data, inst_imm_field, reg_dst, reg_write, reg_file_rd_data1,reg_file_rd_data2, imm_field_wo_sgn_ext, sgn_ext_imm, imm_sgn_ext_lft_shft);
      	$finish;
    end

endmodule
