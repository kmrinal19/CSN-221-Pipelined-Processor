module Instruction_Memory(clk, pc, inp_instn, nextpc, pc_to_branch, reset, jump_in_im, jump_address_im, pcout_ex, branch_out_ex, counter, jump_counter, branch_counter);

input clk;
input wire reset, branch_out_ex;
input wire jump_in_im;
input wire[25:0] jump_address_im;
input wire [31:0] pc, pcout_ex, counter, jump_counter, branch_counter;
reg [31:0] Imemory [0:1023];
output reg [31:0] inp_instn;
output reg [31:0] nextpc;
output reg [31:0] pc_to_branch;
reg[31:0] pc_curr;
reg t_jump_in_im, t_branch_out_ex;

initial
    begin
        $readmemb("m.bin", Imemory);
    end

always @ (posedge reset)
    begin
        nextpc <= 32'd0;
        pc_curr <= 0;
    end

always @ (posedge clk)
    begin
        pc_curr = pc;
        t_jump_in_im = jump_in_im;
        t_branch_out_ex = branch_out_ex;
        if(jump_in_im==1)
            begin
                pc_curr = {6'b000000 ,jump_address_im};
            end

        inp_instn  = Imemory[pc_curr/4];
        if(inp_instn==32'd4294967295)
            pc_curr = 32'd980;
        pc_to_branch = pc_curr;
    end

always @ (negedge clk)
    begin
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