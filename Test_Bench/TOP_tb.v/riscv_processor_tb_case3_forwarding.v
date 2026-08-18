`timescale 1ns/1ps
 
module riscv_processor_tb_case3_forwarding;
 
    // CASE 3: Forwarding | Start PC: 56 | Main instructions: 56-64
    // 56: add x15,x1,x2    -> x15 = 5+10 = 15
    // 60: sub x16,x15,x3   -> EX/MEM FORWARD: x15 forwarded from previous instr
    // 64: add x17,x15,x16  -> MEM/WB fwd x15 (2 back) + EX/MEM fwd x16 (1 back)
 




      // 56 to 80


      
    reg clk;
    reg reset;
 
    riscv_processor dut (
        .clk   (clk),
        .reset (reset)
    );
 
    // clock: 10ns period
    initial clk = 1'b0;
    always #5 clk = ~clk;
 
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;
 
        // run enough cycles for PC to reach 64 (17 fetches from 0),
        // plus WB latency, plus margin
        repeat (23) @(posedge clk);
 
        $finish;
    end

endmodule
 