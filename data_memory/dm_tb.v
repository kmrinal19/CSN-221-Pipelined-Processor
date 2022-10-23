`timescale 1ns / 1ps
`include "data_memory/data_memory.v"

module dm_test_bench;
  reg reset;
  reg clk;
  reg Mem_read;
  reg Mem_write;
  reg [31:0] Mem_address;
  reg [31:0] Write_data;
  wire [31:0] Read_Data;

  DataMemory tb (
    .clk(clk),
    .reset(reset),
    .Mem_read(Mem_read),
    .Mem_write(Mem_write),
    .Mem_address(Mem_address),
    .Write_data(Write_data),
    .Read_Data(Read_Data)
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
      Mem_read = 1'b0;
      Mem_write = 1'b1;
      Mem_address = 0;
      Write_data = 20;
      Mem_read = 1'b1;
      Mem_write = 1'b0;
      Mem_address = 0;
      Write_data = 30;
      $finish;
    end

endmodule