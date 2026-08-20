`timescale 1ns/1ps
 
module riscv_processor_tb_case5_branch_jump;
 
    // CASE 5: Branch/Jump | Start PC: 112 | Main instructions: 112-136
    // 112: add  x28,x1,x2    -> x28 = 15 (computed right before branch)
    // 116: beq  x28,x3,+8    -> BRANCH FORWARDING: needs x28 fwd to compare; taken
    // 120: addi x29,x0,99    -> SHOULD BE FLUSHED (branch taken skips this) x29 will not have 0 as no value is kept in it.
    // 124: jal  x30,+8       -> branch target; jump ahead, link x30
    // 128: addi x31,x0,88    -> SHOULD BE FLUSHED (jal skips this) x31 will have 0 throughut as no value is updated.
    // 132: addi x1,x0,55     -> jal target lands here, x1=55 
    // 136: addi x2,x0,66     -> filler
 

    //Branch and JAL are resolved in EX in your design, and the PC is redirected to the target when the EX-stage result is available
    //after flush in the IF/ID register all the signals are 0 and in the ID/EX the control signals are 0(then theinstruction related things will not be working).
    
    //branch unit is present in the exe state,so to know whether branch is taken or not and jump i staken we ahve to wait for the 3rd cycle after instruciton entered(exe state).
    
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

        repeat (42) @(posedge clk);
 
        $finish;
    end
endmodule