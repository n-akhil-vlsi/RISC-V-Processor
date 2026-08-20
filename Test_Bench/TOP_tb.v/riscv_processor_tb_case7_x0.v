`timescale 1ns/1ps
 
module riscv_processor_tb_case7_x0;
 
    // CASE 7: x0 | Start PC: 168 | Main instructions: 168-192
    // 168: add  x0,x1,x2    -> attempted write to x0 -> must stay 0
    // 172: add  x11,x0,x3   -> use x0 immediately -> must read 0, not forwarded
    // 176: addi x0,x0,50    -> attempted write to x0 -> must stay 0
    // 180: sub  x12,x0,x4   -> use x0 immediately -> must read 0
    // 184: addi x13,x0,0    -> baseline x0 source use
    // 188: add  x14,x0,x0   -> x14 = 0
    // 192: addi x15,x0,77   -> filler
 
    reg clk;
    reg reset;
 
    riscv_processor dut (
        .clk   (clk),
        .reset (reset)
    );
 
    initial clk = 1'b0;
    always #5 clk = ~clk;
 
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;

        repeat (56) @(posedge clk);
 
        $finish;
    end 
endmodule