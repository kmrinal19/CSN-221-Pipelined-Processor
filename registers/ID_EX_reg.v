module ID_EX_reg (branch, reg_write, mem_to_reg, mem_write, mem_read, alu_src, alu_op, nextpc ,reg_file_rd_data1,reg_file_rd_data2, sgn_ext_imm, inst_imm_field, nextpc_out, reg_file_out_data1, reg_file_out_data2, sgn_ext_imm_out, reg_write_out_id_ex, mem_to_reg_out_id_ex, mem_write_out_id_ex, mem_read_out_id_ex, branch_out_id_ex, alu_src_out_id_ex, alu_op_out_id_ex, clk, reset, reg_dst, reg_dst_id_ex, inst_read_reg_addr2_out_id, rd_out_id, inst_read_reg_addr2_out_id_ex, rd_out_id_ex, jump_in_id);


  input wire reg_write, mem_to_reg, branch, reg_dst, jump_in_id;
  input wire [4:0] rd_out_id, inst_read_reg_addr2_out_id;
  input wire mem_write, mem_read;
  input wire alu_src;
  input wire [1:0] alu_op;
  input wire [31:0] nextpc ,reg_file_rd_data1 ,reg_file_rd_data2 ,sgn_ext_imm;
  input wire [15:0] inst_imm_field;
  input wire clk, reset;
  output reg reg_write_out_id_ex, mem_to_reg_out_id_ex, branch_out_id_ex, reg_dst_id_ex;
  output reg mem_write_out_id_ex, mem_read_out_id_ex;
  output reg alu_src_out_id_ex;
  output reg [1:0] alu_op_out_id_ex;
  output reg [4:0] rd_out_id_ex, inst_read_reg_addr2_out_id_ex;


  output reg [31:0] nextpc_out ,reg_file_out_data1 ,reg_file_out_data2 ,sgn_ext_imm_out;
  reg flag_id_ex;
  // output reg [4:0] rs_out ,rt_out;

  // reg t_reg_write_out_id_ex, t_mem_to_reg_out_id_ex, t_branch_out_id_ex;
  // reg t_mem_write_out_id_ex, t_mem_read_out_id_ex;
  // reg t_alu_src_out_id_ex;
  // reg [1:0] t_alu_op_out_id_ex;
  // reg [4:0] t_rd_out_id_ex;
  // reg [31:0] t_nextpc_out ,t_reg_file_out_data1 ,t_reg_file_out_data2 ,t_sgn_ext_imm_out;

  always @(posedge reset)
    begin
      flag_id_ex = 1'b1;
    end

  // always @(negedge clk)
  //     begin
  //     t_nextpc_out <= nextpc;
  //     t_branch_out_id_ex <= branch;
  //     t_reg_file_out_data1 <= reg_file_rd_data1;
  //     t_reg_file_out_data2 <= reg_file_rd_data2;
  //     t_sgn_ext_imm_out <= sgn_ext_imm;
  //     t_rd_out_id_ex <= rd_in_id_ex;
  //     // rs_out <= inst_imm_field[9:5];
  //     // rt_out <= inst_imm_field[14:10];
  //     // reg_write_out <= reg_write;
  //     t_reg_write_out_id_ex <= reg_write;
  //     t_mem_to_reg_out_id_ex <= mem_to_reg;
  //     t_mem_write_out_id_ex <= mem_write;
  //     t_mem_read_out_id_ex <= mem_read;
  //     t_alu_src_out_id_ex <= alu_src;
  //     t_alu_op_out_id_ex <= alu_op;
  //     // reg_dst_out <= reg_dst;
  //   end

  always @(negedge clk)
      begin
        if(jump_in_id != 1)
        begin
          nextpc_out <= nextpc;
          branch_out_id_ex <= branch;
          reg_file_out_data1 <= reg_file_rd_data1;
          reg_file_out_data2 <= reg_file_rd_data2;
          sgn_ext_imm_out <= sgn_ext_imm;
          rd_out_id_ex <= rd_out_id;
          inst_read_reg_addr2_out_id_ex <= inst_read_reg_addr2_out_id;
          //  rs_out <= inst_imm_field[9:5];
          //  rt_out <= inst_imm_field[14:10];
          //  reg_write_out <= reg_write;
          reg_write_out_id_ex <= reg_write;
          mem_to_reg_out_id_ex <= mem_to_reg;
          mem_write_out_id_ex <= mem_write;
          mem_read_out_id_ex <= mem_read;
          alu_src_out_id_ex <= alu_src;
          alu_op_out_id_ex <= alu_op;
          reg_dst_id_ex <= reg_dst;
          // reg_dst_out <= reg_dst;
        end
    end

endmodule
