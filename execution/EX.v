module EX(stall_flag, clk, rs, rt, rd_out_ex_dm, sign_ext, ALUSrc, ALUOp, branch, reset, reg_dst, inst_read_reg_addr1_out_id_ex, inst_read_reg_addr2, rd_out_dm_wb, rd, pc, zero, address, resultOut, pcout, branch_out, offset,rd_out, branch_out_ex_dm, mem_read_in_ex, mem_write_in_ex, reg_write_in_ex, reg_write_out_ex_dm, reg_write_out_dm_wb, mem_to_reg_in_ex, mem_read_out_ex, mem_write_out_ex, reg_write_out_ex, mem_to_reg_out_ex);

    input stall_flag;
    input reset;        //To start from a known state - not necessary
    input clk, reg_dst, branch_out_ex_dm;
    input mem_read_in_ex, mem_write_in_ex, reg_write_in_ex, mem_to_reg_in_ex, reg_write_out_ex_dm, reg_write_out_dm_wb;
    input wire [31:0] pc;
    input wire branch;
    input wire [31:0] rs;
    input wire [31:0] rt;
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
    output reg [31:0] resultOut;
    output reg [31:0] pcout;
    output reg[4:0] rd_out;
    output reg branch_out;
    output reg mem_read_out_ex, mem_write_out_ex, reg_write_out_ex, mem_to_reg_out_ex;
    // output reg [3:0] ALUControlOut;

    // wire [3:0] ALUControl;
    // wire [31:0] result;
    output reg [31:0] offset;
    // wire [31:0] neg_data2 = -data2;
    reg [31:0] data2;
    reg [2:0] forward_a, forward_b;
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
            mem_read_out_ex <= mem_read_in_ex;
            mem_write_out_ex <= mem_write_in_ex;
            reg_write_out_ex <= reg_write_in_ex;
            mem_to_reg_out_ex <= mem_to_reg_in_ex;
            // branch_out <= branch_out_ex_dm;
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

            if(rs == data2)
                begin
                    zero = 1'b1;
                end
            else
                zero = 1'b0;

            case(ALUControl)

                4'b0000:
                    begin
                    $display("EXECUTION UNIT: time = %3d, data1=%d, data2=%d \n", $time, rs, data2);
                    result = rs + data2;
                    end


                4'b0001:
                    begin
                    result = rs - data2;
                    end

                4'b0010:
                    begin
                    result = rs * data2;
                    end

            endcase

            // if (branch==1 && zero==1)
            //     begin
            //         offset = sign_ext<<2;
            //     end

            if (branch==1 && zero==1)
            begin
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

    always @(posedge reset) zero = 1'b0;

endmodule