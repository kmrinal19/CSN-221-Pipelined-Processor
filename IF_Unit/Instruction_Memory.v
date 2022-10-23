module Instruction_Memory(stall_flag, clk, pc, inp_instn, nextpc, pc_to_branch, reset, jump_in_im, jump_address_im, pcout_ex, branch_out_ex, counter, jump_counter, branch_counter);

input stall_flag;
input clk;
input wire reset, branch_out_ex;
input wire jump_in_im;
input wire[25:0] jump_address_im;
input wire [31:0] pc, pcout_ex, counter, jump_counter, branch_counter;
// reg [31:0] pc_reg;
reg [31:0] Imemory [0:1023];
output reg [31:0] inp_instn;
output reg [31:0] nextpc;
output reg [31:0] pc_to_branch;
reg[31:0] pc_curr;
reg t_jump_in_im, t_branch_out_ex;

initial //for testing
    begin
        $readmemb("m.bin", Imemory);
    end

always @ (posedge reset)
    begin
        // assign pc = 0;
        // inp_instn  <= Imemory[0];
        nextpc <= 32'd0;
        pc_curr <= 0;
        // pc_to_branch <= 32'd0;
        // #1
        // $display ("time=%3d, inp_instn=%b, nextpc=%b, pc_to _branch=%b \n", $time, inp_instn, nextpc, pc_to_branch);

    end
// always @ (posedge clk, pc or stall_flag)
always @ (clk)
$display ("INSTRUCTION MEMORY: time=%3d, inp_instn=%b, nextpc=%b, pc_to _branch=%b stall = %b\n", $time, inp_instn, nextpc, pc_to_branch, stall_flag);

always @ (posedge clk)
    begin
    if (stall_flag==0)
        begin
            //enabling this leads to $readmemb: Unable to open Icode.txt for reading.
            // #1
            pc_curr = pc;
            t_jump_in_im = jump_in_im;
            t_branch_out_ex = branch_out_ex;
            $display("PC : %b\n", pc);
            if(jump_in_im==1)
                begin
                    pc_curr = {6'b000000 ,jump_address_im};
                    $display ("INSTRUCTION MEMORY JUMP: time=%3d, pc_curr = %b\n", $time, pc_curr);
                end

            inp_instn  = Imemory[pc_curr/4];  //Was given to be [pc>>2]
            if(inp_instn==32'd4294967295)
                pc_curr = 32'd980;
            pc_to_branch = pc_curr;
        end
    end

always @ (negedge clk)
    begin
        // pc_curr=pc;
        $display("IM: negedge branch check: t_branch: %b, branch: %b, pcout_ex: %b", t_branch_out_ex, branch_out_ex, pcout_ex);
        if( branch_out_ex == 1)
        begin
            nextpc = pcout_ex;
        end
        else if(t_jump_in_im==1)
            nextpc = pc_curr;
        else
            nextpc = pc_curr+32'd4;
    end


always @ (pc)
begin
    $display("Clock Cycles = %d , Total Instructions = %d", $time/200, (counter-2*jump_counter-(2*branch_counter))+1);
    if(pc==32'd1000) $finish;
end


endmodule