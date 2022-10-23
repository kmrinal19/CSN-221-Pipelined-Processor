module RegisterFile(inst_read_reg_addr1, inst_read_reg_addr2, reg_wr_addr, reg_wr_data, reg_wr, clk, reg_file_rd_data1, reg_file_rd_data2, reset);
	input [4:0] inst_read_reg_addr1 ,inst_read_reg_addr2 ,reg_wr_addr;
	input [31:0] reg_wr_data;
	input reg_wr ,clk, reset;
	output reg [31:0] reg_file_rd_data1 ,reg_file_rd_data2;
	integer i;
	reg [31:0] registers[0:31];

	reg registers_flag[0:31];

	always @(reset)
		begin
			for(i=0; i<32; i=i+1)
				registers[i] <= 32'd0;
		end

	reg[31:0] t_reg_file_rd_data1, t_reg_file_rd_data2, t_reg_wr_data;

	always @(posedge clk)
		begin
			reg_file_rd_data1 = registers[inst_read_reg_addr1];
			reg_file_rd_data2 = registers[inst_read_reg_addr2];
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
		end
	end

endmodule
