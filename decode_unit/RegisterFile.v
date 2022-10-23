module RegisterFile(stall_flag, inst_read_reg_addr1, inst_read_reg_addr2, reg_wr_addr, reg_wr_data, reg_wr, clk, reg_file_rd_data1, reg_file_rd_data2, reset);
	input stall_flag;
	input [4:0] inst_read_reg_addr1 ,inst_read_reg_addr2 ,reg_wr_addr;
	input [31:0] reg_wr_data;
	input reg_wr ,clk, reset;
	output reg [31:0] reg_file_rd_data1 ,reg_file_rd_data2;
	integer i;
	reg [31:0] registers[0:31]; // Need to understand implementation of 32 32-bit registers
	//TODO: Reading at posedge makes the program inefficient

	reg registers_flag[0:31];

	always @(reset)
		begin
			registers[0] <= 32'd0; registers_flag[0] <= 32'd0;
			registers[1] <= 32'd0; registers_flag[1] <= 32'd0;
			registers[2] <= 32'd0; registers_flag[2] <= 32'd0;
			registers[3] <= 32'd0; registers_flag[3] <= 32'd0;
			registers[4] <= 32'd4; registers_flag[4] <= 32'd0;
			registers[5] <= 32'd5; registers_flag[5] <= 32'd0;
			registers[6] <= 32'd6; registers_flag[6] <= 32'd0;
			registers[7] <= 32'd7; registers_flag[7] <= 32'd0;
			registers[8] <= 32'd0; registers_flag[8] <= 32'd0;
			registers[9] <= 32'd0; registers_flag[9] <= 32'd0;
			registers[10] <= 32'd0; registers_flag[10] <= 32'd0;
			registers[11] <= 32'd0; registers_flag[11] <= 32'd0;
			registers[12] <= 32'd0; registers_flag[12] <= 32'd0;
			registers[13] <= 32'd0; registers_flag[13] <= 32'd0;
			registers[14] <= 32'd0; registers_flag[14] <= 32'd0;
			registers[15] <= 32'd15; registers_flag[15] <= 32'd0;
			registers[16] <= 32'd16; registers_flag[16] <= 32'd0;
			registers[17] <= 32'd0; registers_flag[17] <= 32'd0;
			registers[18] <= 32'd0; registers_flag[18] <= 32'd0;
			registers[19] <= 32'd0; registers_flag[19] <= 32'd0;
			registers[20] <= 32'd0; registers_flag[20] <= 32'd0;
			registers[21] <= 32'd0; registers_flag[21] <= 32'd0;
			registers[22] <= 32'd0; registers_flag[22] <= 32'd0;
			registers[23] <= 32'd0; registers_flag[23] <= 32'd0;
			registers[24] <= 32'd0; registers_flag[24] <= 32'd0;
			registers[25] <= 32'd0; registers_flag[25] <= 32'd0;
			registers[26] <= 32'd0; registers_flag[26] <= 32'd0;
			registers[27] <= 32'd0; registers_flag[27] <= 32'd0;
			registers[28] <= 32'd0; registers_flag[28] <= 32'd0;
			registers[29] <= 32'd0; registers_flag[29] <= 32'd0;
			registers[30] <= 32'd0; registers_flag[30] <= 32'd0;
			registers[31] <= 32'd0; registers_flag[31] <= 32'd0;
		end
	//always @(inst_read_reg_addr1, inst_read_reg_addr2, posedge clk, stall_flag)


	reg[31:0] t_reg_file_rd_data1, t_reg_file_rd_data2, t_reg_wr_data;

	// always @(posedge clk)
	// 	begin
	// 	$display("time = %3d, Register file: read reg 1 = %d, read reg 2 = %d, stall_flag = %d", $time, inst_read_reg_addr1, inst_read_reg_addr2, stall_flag);
	// 	t_reg_wr_data <= reg_wr_data;
	// 	if (stall_flag==0)
	// 		// #1
	// 		begin
	// 			t_reg_file_rd_data1 <= registers[inst_read_reg_addr1];
	// 			t_reg_file_rd_data1 <= registers[inst_read_reg_addr2];
	// 		end
	// 	end

    // always@(reg_wr_data, reg_wr_addr) $display("reg_wr_data =%d, reg_wr_addr=%d",reg_wr_data, reg_wr_addr);

	always @(posedge clk)
	// if (stall_flag==0)
	// begin
	// #8
	// #1
		begin
			// $display("time = %3d, Register file: read reg 1 = %d, read reg 2 = %d, stall_flag = %d", $time, inst_read_reg_addr1, inst_read_reg_addr2, stall_flag);
			reg_file_rd_data1 = registers[inst_read_reg_addr1];
			reg_file_rd_data2 = registers[inst_read_reg_addr2];
			$display ("REGISTER FILE: time=%3d, register data1=%d, register data2=%d \n", $time, reg_file_rd_data1, reg_file_rd_data2);
		end


	always @ (posedge clk)
	begin
		$display("REGISTER FILE: time: %3d", $time);
		for(i=0; i<32; i=i+1)
			$display("Register ", i , " ", registers[i]);

	end

	always @ (negedge clk)
	begin
		if (reg_wr == 1)
		begin
			registers[reg_wr_addr] = reg_wr_data;
			$display ("REGISTER FILE: time=%3d, ans=%b addr=%b data=%b \n", $time, registers[reg_wr_addr], reg_wr_addr,reg_wr_data);
		end
	end

	// end
	// always@(posedge clk)
	// begin
	// 	$display("REGISTER FILE: time: %3d", $time);
	// 	for(i=0; i<32; i=i+1)
	// 		$display("Register ", i , " ", registers[i]);
	// end

endmodule
