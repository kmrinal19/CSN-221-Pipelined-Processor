`include "decode_unit/Mux2_1_5.v"
// `include "registers_flag.v"
// `include "decode_unit/Mux2_1_32.v"
`include "decode_unit/RegisterFile.v"
`include "decode_unit/SignExtend.v"
//`include "decode_unit/LeftShift2.v"

module instruction_decoder (
    stall_flag,
    stall_flag_if,
    stall_flag_ex,
    stall_flag_id_out,
    stall_flag_if_out,
    stall_flag_ex_out,
    reg_write_cu,
    clk,
    reset,
    inst_read_reg_addr1,
    inst_read_reg_addr2,
    // rt removed (Redundant input, same as inst_read_reg_addr2)
    rd,
    reg_wr_data, // Added reg_wr_data
    // alu_data_out removed (Redundant, to be included in WB stage)
    // mem_data_out removed (Redundant, to be included in WB stage)
    inst_imm_field,
    reg_write,
    // mem_to_reg removed (Redundant, to be included in WB stage)
    // jr_offset removed (What is jr_offset?)
    reg_file_rd_data1,
    reg_file_rd_data2,
    imm_field_wo_sgn_ext, // wo: without
    sgn_ext_imm,
    imm_sgn_ext_lft_shft,
    reg_wr_addr_wb,
    inst_read_reg_addr2_out_id,
    rd_out_id,
    jump_in,
    jump_out_id
);
    reg registers_flag[0:31];

    always @(posedge reset)
        begin
            registers_flag[0] <= 1'b0;
            registers_flag[1] <= 1'b0;
            registers_flag[2] <= 1'b0;
            registers_flag[3] <= 1'b0;
            registers_flag[4] <= 1'b0;
            registers_flag[5] <= 1'b0;
            registers_flag[6] <= 1'b0;
            registers_flag[7] <= 1'b0;
            registers_flag[8] <= 1'b0;
            registers_flag[9] <= 1'b0;
            registers_flag[10] <= 1'b0;
            registers_flag[11] <= 1'b0;
            registers_flag[12] <= 1'b0;
            registers_flag[13] <= 1'b0;
            registers_flag[14] <= 1'b0;
            registers_flag[15] <= 1'b0;
            registers_flag[16] <= 1'b0;
            registers_flag[17]<= 1'b0;
            registers_flag[18] <= 1'b0;
            registers_flag[19] <= 1'b0;
            registers_flag[20] <= 1'b0;
            registers_flag[21] <= 1'b0;
            registers_flag[22] <= 1'b0;
            registers_flag[23] <= 1'b0;
            registers_flag[24] <= 1'b0;
            registers_flag[25] <= 1'b0;
            registers_flag[26] <= 1'b0;
            registers_flag[27] <= 1'b0;
            registers_flag[28] <= 1'b0;
            registers_flag[29] <= 1'b0;
            registers_flag[30] <= 1'b0;
            registers_flag[31] <= 1'b0;

            stall_flag_ex_out <= 1'b0;
            stall_flag_if_out <= 1'b0;
            stall_flag_id_out <= 1'b0;
        end
    input clk, reset, reg_write, stall_flag, stall_flag_if, stall_flag_ex, jump_in;
    input [4:0] inst_read_reg_addr1 ,inst_read_reg_addr2, rd, reg_wr_addr_wb; //rt removed
    // input [31:0] alu_data_out, mem_data_out; (Redundant, to be included in WB stage)
    input [15:0] inst_imm_field;
    input [31:0] reg_wr_data; // Added reg_wr_data
    input reg_write_cu; // mem_to_reg removed(Redundant mem_to_reg signal, to be included in WB stage)
    output [31:0] reg_file_rd_data1, reg_file_rd_data2, sgn_ext_imm, imm_sgn_ext_lft_shft;
    output reg [15:0] imm_field_wo_sgn_ext;
    output reg [4:0] rd_out_id, inst_read_reg_addr2_out_id;
    output reg stall_flag_if_out, stall_flag_ex_out, stall_flag_id_out, jump_out_id;
    // computing multiplexer results
    wire [4:0] reg_wr_addr; // Changed reg to wire due to error in line 37
    // reg [4:0] reg_wr_addr;
    // reg [31:0] reg_wr_data; (removed calculation of reg_wr_data)


    always @(posedge clk)
        begin
            jump_out_id <= jump_in;
            rd_out_id <= rd;
            inst_read_reg_addr2_out_id <=  inst_read_reg_addr2;
            if(registers_flag[inst_read_reg_addr1]==1 || registers_flag[inst_read_reg_addr2]==1)
            begin
                    stall_flag_if_out <= 1'b1;
                    stall_flag_id_out <= 1'b1;
                    // stall_flag_ex_out <= 1'b1;
            end
            $display("INSTRUCTION DECODER: time = %3d, Register file: read reg 1 = %d, read reg 2 = %d", $time, inst_read_reg_addr1, inst_read_reg_addr2);
            // $display(stall_flag_if_out, " ", stall_flag_id_out, " ", stall_flag_ex_out);
        end

    // Mux2_1_5 reg_wr_mux(inst_read_reg_addr2, rd, stall_flag, reg_dst, reg_wr_addr);

    // always @(clk)
    //     $display("time =%3d ID write address",$time, reg_wr_addr);
    // Mux2_1_32 wrb_mux(alu_data_out, mem_data_out, mem_to_reg, reg_wr_data);
    //#1
    // register file
    RegisterFile registerFile(stall_flag, inst_read_reg_addr1, inst_read_reg_addr2, reg_wr_addr_wb, reg_wr_data, reg_write, clk, reg_file_rd_data1, reg_file_rd_data2, reset); // Replaced reg_wr_addr with reg_wr_addr_wb

    // sign extension
    SignExtend signExtend(clk, stall_flag, inst_imm_field, sgn_ext_imm);

    // left shift
    //#1
    assign imm_sgn_ext_lft_shft = sgn_ext_imm << 2; //redundant

    // always @(reg_file_rd_data1) begin
    //     jr_offset <= reg_file_rd_data1;
    // end

    // assign imm_field_wo_sgn_ext = inst_imm_field; //Added below block in place

    always @(posedge clk)
    if (stall_flag==0)
        begin
                imm_field_wo_sgn_ext <= inst_imm_field;
        end
    // always @(posedge clk)
    // begin
    //     rd_out_id <= reg_wr_addr;
    // end
    // always @(negedge clk)
    // $display ("dsvrgssa");


    // reg [4:0] a;
    // initial
    // begin

    //     // rd_out_id <= reg_wr_addr;

    //     a <= reg_wr_addr; //haven't checked wire to reg conversion

    //     registers_flag[a] <= 1'b1;   //stall flag set
    //     #1


    //     $display ("dsva",registers_flag[a]);
    //     $finish;
    //     // if (reg_write==1)
    //     //     Registers_flag.registers_flag[rd] <= 1'b1;
    // end
    reg [4:0] flag_reg_wr_addr;
    reg [4:0] flag_reg_wr_addr_wb;


    always @(posedge clk)
    // #10
    // #1
    begin
        // flag_reg_wr_addr <= reg_wr_addr;
        flag_reg_wr_addr_wb <= reg_wr_addr_wb;
        // rd_out_id <= reg_wr_addr;
        // stall_flag_if_out <= stall_flag_if;
        // stall_flag_ex_out <= stall_flag_ex;
        // stall_flag_id_out <= stall_flag,
        // #1
        // $display("check address= %d",rd_out_id);

        // if (reg_write_cu==1)
        //     registers_flag[flag_reg_wr_addr] <= 1'b1;   //stall flag set

        if (reg_write==1)
        begin
            registers_flag[reg_wr_addr_wb] <= 1'b0;
            stall_flag_if_out <= 1'b0;
            stall_flag_id_out <= 1'b0;
            stall_flag_ex_out <= 1'b0;
        end
    end

endmodule