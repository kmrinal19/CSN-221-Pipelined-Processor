`timescale 1ns / 1ps
`include "IF_Unit/Instruction_Memory.v"
`include "execution/EX.v"
`include "data_memory/data_memory.v"
`include "write_back/write_back.v"
`include "registers/IF_ID_reg.v"
`include "registers/ID_EX_reg.v"
`include "registers/EX_DM_reg.v"
`include "registers/DM_WB_reg.v"
`include "decode_unit/controlunit.v"
`include "decode_unit/instruction_decoder.v"
// `include "decode_unit/RegisterFile.v"


module pipeline();
    wire flag_if, flag_id, flag_ex;
    reg clk, reset;
    wire mem_to_reg_out_ex_dm;
    // reg [31:0] registers[0:31];
    wire [31:0] pc;
    reg [31:0] Imemory [0:1023];
    wire [31:0] inp_instn;
    wire [31:0] nextpc, pcout_ex_dm;
    wire [31:0] pc_to_branch;
    wire [31:0] PCplus4Out;
    wire [31:0] currpc_out;
    wire [31:0] out_instn;
    wire [5:0] opcode;
    wire [4:0] inst_read_reg_addr2_out_id, rd, rd_out_id, rd_in_id_ex, rd_out_id_ex, rd_out_ex, rd_in_ex_dm, rd_out_ex_dm, rd_in_dm_wb, rd_out_dm_wb, rd_in_wb, rd_out_wb, inst_read_reg_addr2_out_id_ex;
    wire [15:0] inst_imm_field;
    wire [1:0] alu_op;
    wire [1:0] alu_op_out_id_ex;
    // wire [5:0] funct;
    wire [31:0] branch_address;
    wire [31:0] pcout, resultOut, Mem_address, Write_data;
    wire Mem_read, Mem_write, mem_to_reg_out_dm_wb, jump;
    wire [31:0] Read_Data, read_data_out_wb, alu_res_out_wb, ALU_result_out_ex_dm;
    wire [25:0] jump_address;

    Instruction_Memory IM (
        .stall_flag(flag_if),
        .clk(clk),
        .pc(nextpc),
      	.reset(reset),
        .inp_instn(inp_instn),
        .nextpc(nextpc),
        .pc_to_branch(pc_to_branch),
        .jump_in_im(jump_id),
        .jump_address_im(jump_address),
        .pcout_ex(pcout),
        .branch_out_ex(branch_out_ex)
    );

    // assign opcode = inp_instn[31:26]; // changes to be made in controlunit.v
    // assign inst_read_reg_addr1 = inp_instn[25:21];
    // assign inst_read_reg_addr2 = inp_instn[20:16];
    // assign rd = inp_instn[15:11];
    // assign inst_imm_field = inp_instn[15:0];

    IF_ID_reg IF(
        .clk(clk),
        .reset(reset),
        .currpc(pc_to_branch),
        .inp_instn(inp_instn),
        .nextpc(nextpc),
        .PCplus4Out(PCplus4Out),
        .currpc_out(currpc_out),
        .out_instn(out_instn),
        .jump_address(jump_address),
        .jump_in(jump),
        .jump_out(jump_id)
    );


    ControlUnit cu (
        .opcode(out_instn[31:26]),
        .branch_out_ex_dm(branch_out_ex_dm),
        .reset(reset),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump),
        .clk(clk)
        );

    wire [31:0] reg_wr_data;
    // reg_dst and reg_write
    wire [31:0] reg_file_rd_data1, reg_file_rd_data2, sgn_ext_imm, imm_sgn_ext_lft_shft;
    wire [15:0] imm_field_wo_sgn_ext;
    wire [31:0] nextpc_out;
    wire [31:0] reg_file_out_data1, reg_file_out_data2;
    wire [31:0] sgn_ext_imm_out;
    wire [4:0] rs_out, rt_out;
    wire [1:0] alu_op_out;

    instruction_decoder tb (
        .stall_flag(flag_id),
        .stall_flag_if(flag_if),
        .stall_flag_ex(flag_ex),
        .stall_flag_id_out(flag_id),
        .stall_flag_if_out(flag_if),
        .stall_flag_ex_out(flag_ex),
        .clk (clk),
        .reset(reset),
        .inst_read_reg_addr1(out_instn[25:21]),
        .inst_read_reg_addr2(out_instn[20:16]),
        .rd(out_instn[15:11]), // Raw rd from instruction
        // .rd(rd_out_wb),
        .reg_wr_addr_wb(rd_out_wb), // Now, writing at address recieved from wb stage
        .reg_wr_data(reg_wr_data),
        .inst_imm_field(out_instn[15:0]),
        .reg_write(reg_write_out_wb),
        .reg_file_rd_data1(reg_file_rd_data1),
        .reg_file_rd_data2(reg_file_rd_data2),
        .imm_field_wo_sgn_ext(imm_field_wo_sgn_ext),
        .sgn_ext_imm(sgn_ext_imm),
        .imm_sgn_ext_lft_shft(imm_sgn_ext_lft_shft),
        .reg_write_cu(reg_write),
        .inst_read_reg_addr2_out_id(inst_read_reg_addr2_out_id),
        .rd_out_id(rd_out_id),
        .jump_in(jump_id),
        .jump_out_id(jump_out_id)
    );

    ID_EX_reg ID_EX (
        // .branch(branch),
        // .reg_write(reg_write),
        // .mem_to_reg(mem_to_reg),
        // .mem_write(mem_write),
        // .mem_read(mem_read),
        // .rd_in_id_ex(rd_out_id),
        // .alu_src(alu_src),
        // .alu_op(alu_op),
        // .nextpc(PCplus4Out),
        // .reg_file_rd_data1(reg_file_out_data1) ,
        // .reg_file_rd_data2(reg_file_out_data2),
        // .sgn_ext_imm(sgn_ext_imm),
        // .inst_imm_field(imm_field_wo_sgn_ext),
        // .nextpc_out(nextpc_out) ,
        // .reg_file_out_data1(reg_file_out_data1) ,
        // .reg_file_out_data2(reg_file_out_data2) ,
        // .sgn_ext_imm_out(sgn_ext_imm_out),
        // .reg_write_out_id_ex(reg_write_out_id_ex),
        // .mem_to_reg_out_id_ex(mem_to_reg_out_id_ex),
        // .mem_write_out_id_ex(mem_write_out_id_ex),
        // .mem_read_out_id_ex(mem_read_out_id_ex),
        // .branch_out_id_ex(branch_out_id_ex),
        // .alu_src_out_id_ex(alu_src_out_id_ex),
        // .alu_op_out_id_ex(alu_op_out_id_ex),
        // .clk(clk),
        // .reset(reset),
        // .rd_out_id_ex(rd_out_id_ex)

        branch, reg_write, mem_to_reg, mem_write, mem_read, alu_src, alu_op, nextpc ,reg_file_rd_data1,reg_file_rd_data2, sgn_ext_imm, inst_imm_field, nextpc_out, reg_file_out_data1, reg_file_out_data2
        , sgn_ext_imm_out, reg_write_out_id_ex, mem_to_reg_out_id_ex, mem_write_out_id_ex, mem_read_out_id_ex, branch_out_id_ex, alu_src_out_id_ex, alu_op_out_id_ex, clk, reset, reg_dst, reg_dst_id_ex, inst_read_reg_addr2_out_id, rd_out_id, inst_read_reg_addr2_out_id_ex, rd_out_id_ex, jump_out_id
    );

    // EX Ex (
    //     .stall_flag(flag_ex),
    //     .clk (clk),
    //     .reset (reset),
    //     .branch (branch),
    //     .rs (reg_file_rd_data1),
    //     .rt (reg_file_rd_data2),
    //     .sign_ext (sgn_ext_imm),
    //     .ALUSrc (alu_src),
    //     .ALUOp (alu_op),
    //     // .funct (funct),
    //     .pc (nextpc),
    //     .address(branch_address),
    //     .zero (zero),
    //     .resultOut(resultOut),
    //     .pcout (pcout) // redundant
    // );

    EX Ex (
        .stall_flag(flag_ex),
        .clk (clk),
        .reset (reset),
        .branch (branch_out_id_ex),
        .reg_dst(reg_dst_id_ex),
        .inst_read_reg_addr2(inst_read_reg_addr2_out_id_ex),
        .rd(rd_out_id_ex),
        .rs (reg_file_out_data1),
        .rt (reg_file_out_data2),
        .sign_ext (sgn_ext_imm_out),
        .ALUSrc (alu_src_out_id_ex),
        .ALUOp (alu_op_out_id_ex),
        // .funct (funct),
        .pc (nextpc_out),
        .address(branch_address),
        .zero (zero),
        .resultOut(resultOut),
        .pcout (pcout), // redundant
        .rd_out(rd_out_ex),
        .branch_out_ex_dm(branch_out_ex_dm), // input
        //control signals
        .mem_read_in_ex(mem_read_out_id_ex),
        .mem_write_in_ex(mem_write_out_id_ex),
        .reg_write_in_ex(reg_write_out_id_ex),
        .mem_to_reg_in_ex(mem_to_reg_out_id_ex),
        .mem_read_out_ex(mem_read_out_ex),
        .mem_write_out_ex(mem_write_out_ex),
        .reg_write_out_ex(reg_write_out_ex),
        .mem_to_reg_out_ex(mem_to_reg_out_ex),
        .branch_out(branch_out_ex)

    );

    EX_DM_register EX_DM (
        .ALU_result (resultOut),
        .ALU_result_out_ex_dm(ALU_result_out_ex_dm),
        .mem_to_reg_in(mem_to_reg_out_ex),
        .mem_to_reg_out_ex_dm(mem_to_reg_out_ex_dm),
        .mem_read_in (mem_read_out_ex),
        .mem_write_in(mem_write_out_ex),
        .reg_write_in(reg_write_out_ex),
        .Write_data_in(reg_file_out_data2),
        // .Mem_address(Mem_address),
        .mem_read_out_ex_dm(mem_read_out_ex_dm),
        .mem_write_out_ex_dm(mem_write_out_ex_dm),
        .reg_write_out_ex_dm(reg_write_out_ex_dm),
        .Write_data_out(Write_data),
        .clk(clk),
        .reset(reset),
        .rd_in_ex_dm(rd_out_ex),
        .rd_out_ex_dm(rd_out_ex_dm),
        .branch_out_ex(branch_out_ex),
        .branch_out_ex_dm(branch_out_ex_dm),
        .pcout_ex(pcout),
        .pcout_ex_dm(pcout_ex_dm)
    );

    DataMemory DM (
        .clk(clk),
        .reset(reset),
        .Mem_read(mem_read_out_ex_dm),
        .Mem_write(mem_write_out_ex_dm),
        .Mem_address(Mem_address),
        .Write_data(Write_data),
        .Read_Data(Read_Data)
    );

    MEM_WB_reg DM_WB (
        .clk(clk),
        .alu_result(ALU_result_out_ex_dm),
        .read_data(Read_Data),
        .reg_write(reg_write_out_ex_dm),
        .mem_to_reg(mem_to_reg_out_ex_dm),
        .mem_to_reg_out_dm_wb(mem_to_reg_out_dm_wb),
        .reg_write_out_dm_wb(reg_write_out_dm_wb),
        .read_data_out(read_data_out_wb),
        .alu_res_out(alu_res_out_wb),
        .rd_in_dm_wb(rd_out_ex_dm),
        .rd_out_dm_wb(rd_out_dm_wb)
    );

    WriteBack WB(
        .clk(clk),
        .reset(reset),
        .rd_in_wb(rd_out_dm_wb),
        .reg_write(reg_write_out_dm_wb),
        .mem_to_reg(mem_to_reg_out_dm_wb),
        .alu_data_out(alu_res_out_wb),
        .dm_data_out(read_data_out_wb),
        .wb_data(reg_wr_data),
        .reg_write_out_wb(reg_write_out_wb),
        // .rd_out_wb(rd_out_dm_wb)
        .rd_out_wb(rd_out_wb)
    );

    always@(clk)
    // #10 clk <= ~clk;
    #100 clk <= ~clk;


    initial
    begin
    $monitor("MONTIOR: time=%3d, reg_wr_data=%d \n", $time, reg_wr_data);
    #100
    clk = 0;
    #50
    reset = 1;
    // #500
    // reset <= 0;
    end
    // always@(posedge reset)
    // begin
    //     wire flag_if = 1'b0;
    //     flag_id <= 1'b0;
    //     flag_ex <= 1'b0;
    // end
    // initial
    // begin
    //     clk = 1'b0;
    //     forever #3 clk = ~clk;
    // end

    // initial
    // begin
    //     reset = 1'b1;
    //     #100 reset = 1'b0;
    // end

    // initial
    // begin
    //     $10
    //     $display ("time=%3d, address=%b, zero=%b, result=%d, pcout=%b, offset%b \n", $time, address, zero, resultOut, pcout, offset);
    //   	$finish;
    // end



endmodule