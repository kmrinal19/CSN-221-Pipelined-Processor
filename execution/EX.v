module EX(stall_flag, clk, rs, rt, rd_out_ex_dm, sign_ext, ALUSrc, ALUOp, branch, reset, reg_dst, inst_read_reg_addr1_out_id_ex, inst_read_reg_addr2, rd_out_dm_wb, rd, pc, zero, address, resultOut, pcout, branch_out, offset,rd_out, branch_out_ex_dm, mem_read_in_ex, mem_write_in_ex, reg_write_in_ex, reg_write_out_ex_dm, reg_write_out_dm_wb, mem_to_reg_in_ex, mem_read_out_ex, mem_write_out_ex, reg_write_out_ex, mem_to_reg_out_ex, result_out_dm_wb, result_out_ex_dm, branch_counter, branch_counter_output);

    input stall_flag;
    input reset;        //To start from a known state - not necessary
    input clk, reg_dst, branch_out_ex_dm;
    input mem_read_in_ex, mem_write_in_ex, reg_write_in_ex, mem_to_reg_in_ex, reg_write_out_ex_dm, reg_write_out_dm_wb;
    input wire [31:0] pc, branch_counter;
    input wire branch;
    input wire [31:0] rs;
    input wire [31:0] rt, result_out_dm_wb, result_out_ex_dm;
    input wire [31:0] sign_ext;
    input wire [4:0] rd_out_ex_dm, rd_out_dm_wb;
    input wire ALUSrc;          //to choose bw rt and sign extend ,from cu
    input wire [1:0] ALUOp;     //from cu
    input wire [4:0] inst_read_reg_addr2, rd, inst_read_reg_addr1_out_id_ex;
    wire [5:0] funct;     //from decode unit
    reg [3:0] ALUControl;
    reg [31:0] result;
    output reg zero;
    output reg [31:0] address;
    output reg [31:0] resultOut, branch_counter_output;
    output reg [31:0] pcout;
    output reg[4:0] rd_out;
    output reg branch_out;
    output reg mem_read_out_ex, mem_write_out_ex, reg_write_out_ex, mem_to_reg_out_ex;
    // output reg [3:0] ALUControlOut;

    reg [31:0] t_branch_counter_output;

    // wire [3:0] ALUControl;
    // wire [31:0] result;
    output reg [31:0] offset;
    // wire [31:0] neg_data2 = -data2;
    reg [31:0] data1, data2;
    reg [1:0] forward_a, forward_b;
    // pcout = pc;

    // always @(posedge clk)
    // begin
    //     if (stall_flag==0)
    //         begin
    //         if(ALUSrc == 0)
    //         data2 = rt;
    //         else
    //         data2 = sign_ext;  //assumed that 16-bit has been extended to 32-bit by ID unit
    //         end
    // end

    //AluControl

    parameter LW = 2'b00;
    parameter SW = 2'b00;
    parameter ADDI = 2'b00;
    parameter BEQ = 2'b01;
    parameter RType = 2'b10;
    parameter ADD = 6'b000000;
    parameter SUB = 6'b000001;
    parameter MUL = 6'b000010;

    assign funct = sign_ext[5:0];

    always @(posedge clk)
    begin
        t_branch_counter_output <= branch_counter_output;
        if(branch_out_ex_dm==1)
        begin
            mem_read_out_ex <= 0;
            mem_write_out_ex <= 0;
            reg_write_out_ex <= 0;
            mem_to_reg_out_ex <= 0;
            branch_out <= 0;
        end
        else
        begin
            forward_a = 2'b00;
            forward_b = 2'b00;

            // Data forwarding signals

            $display("EXECUTION: reg_write_out_ex_dm: %b, rd_out_ex_dm: %b, inst_read_reg_addr1_out_id_ex:%b",reg_write_out_ex_dm,rd_out_ex_dm,inst_read_reg_addr1_out_id_ex);

            // MEM hazard
            if(reg_write_out_dm_wb == 1 && rd_out_dm_wb == inst_read_reg_addr1_out_id_ex)
                forward_a = 2'b01;
            if(reg_write_out_dm_wb == 1 && rd_out_dm_wb == inst_read_reg_addr2)
                forward_b = 2'b01;

            // EX hazard
            if(reg_write_out_ex_dm == 1 && rd_out_ex_dm == inst_read_reg_addr1_out_id_ex)
                forward_a = 2'b10;
            if(reg_write_out_ex_dm == 1 && rd_out_ex_dm == inst_read_reg_addr2)
                forward_b = 2'b10;

            case(forward_a)

                2'b00:
                    data1 = rs;

                2'b01:
                    data1 = result_out_dm_wb;

                2'b10:
                    data1 = result_out_ex_dm;

            endcase

            $display("EXECUTION: forward_a: %b, data1: %d", forward_a, data1);

            mem_read_out_ex <= mem_read_in_ex;
            mem_write_out_ex <= mem_write_in_ex;
            reg_write_out_ex <= reg_write_in_ex;
            mem_to_reg_out_ex <= mem_to_reg_in_ex;
            // branch_out <= branch_out_ex_dm;

            // MUX for selecting rd
            if (reg_dst==0)
                rd_out = inst_read_reg_addr2;
            else
                rd_out = rd;

            if (stall_flag==0)
            begin
            if(ALUSrc == 0)
                data2 = rt;
            else
                data2 = sign_ext;  //assumed that 16-bit has been extended to 32-bit by ID unit

            pcout = pc;
            case(ALUOp) //aluop same for lw and sw and addi... first it is going to load before addi

                LW: //address always in rs and data in rt
                begin
                    ALUControl = 4'b0000;
                    offset = sign_ext; //check if shift is necessary
                    data2 = offset;
                end

                SW:
                begin
                    ALUControl = 4'b0000;
                    offset = sign_ext; //check if shift is necessary
                    data2 = offset;
                end
                ADDI:
                    ALUControl = 4'b0000;

                BEQ:
                    ALUControl = 4'b0001;

                RType:
                    case(funct)

                        ADD:
                            ALUControl = 4'b0000;

                        SUB:
                            ALUControl = 4'b0001;

                        MUL:
                            ALUControl = 4'b0010;

                    endcase


            endcase

            case(forward_b)

                2'b00:
                    data2 = data2;

                2'b01:
                    data2 = result_out_dm_wb;

                2'b10:
                    data2 = result_out_ex_dm;

            endcase

            $display("EXECUTION: forward_b: %b, data2: %d", forward_b, data2);

            if(data1 == data2)
                begin
                    zero = 1'b1;
                end
            else
                zero = 1'b0;

            case(ALUControl)

                4'b0000:
                    begin
                    $display("EXECUTION UNIT: time = %3d, data1=%d, data2=%d \n", $time, data1, data2);
                    result = data1 + data2;
                    end


                4'b0001:
                    begin
                    result = data1 - data2;
                    end

                4'b0010:
                    begin
                    result = data1 * data2;
                    end

            endcase

            // if (branch==1 && zero==1)
            //     begin
            //         offset = sign_ext<<2;
            //     end

            if (branch==1 && zero==1)
            begin
                branch_counter_output <= t_branch_counter_output + 1;
                offset = sign_ext;
                address = offset;
                pcout = address;
                branch_out = 1;
            end
            else
                branch_out = 0;

            resultOut = result;
            $display("EXECUTION UNIT: ", resultOut);
            end
        end
    end

    always @(posedge reset)
    begin
        zero = 1'b0;
        branch_counter_output <= 0;
    end

endmodule