`timescale 1ns/1ps
 
module riscv_processor_tb_case9_reset;
 
    // CASE 9: Reset | Start PC: 224 | Main instructions: 224-252
    // 224: addi x21,x0,1    -> pre-reset sequential instr
    // 228: addi x22,x0,2    -> pre-reset sequential instr
    // 232: addi x23,x0,3    -> pre-reset sequential instr
    // 236: addi x24,x0,4    -> RESET asserted mid-pipeline right around here
    // 240: addi x25,x0,5    -> post-reset: pipeline should be cleared
    // 244: addi x26,x0,6    -> post-reset sequential instr
    // 248: addi x27,x0,7    -> post-reset sequential instr
    // 252: addi x28,x0,8    -> post-reset sequential instr
    //
    // NOTE: register_file has no reset input, so x21/x22/x23 (already
    // committed before the mid-stream reset) are expected to RETAIN
    // their values. Only the PC and pipeline registers (IF/ID, ID/EX,
    // EX/MEM, MEM/WB) are expected to clear/flush. After reset releases,
    // PC returns to 0 and instruction fetch restarts from the top of
    // the program - it does NOT resume at address 240.
 
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
        // initial power-on reset
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;
 
        // let the pipeline run naturally until PC reaches 236
        // (the instruction right before the mid-stream reset point)
        wait (dut.pc == 32'd236);
 
        // IMPORTANT: x21/x22/x23 (fetched at PC=224/228/232) are still
        // in-flight in the pipeline at this exact moment - NOT yet in
        // WB. Give them extra cycles to actually commit before we
        // assert reset, otherwise they get incorrectly flushed too.
        // x24 (just fetched at PC=236) will still be safely caught
        // mid-pipeline and correctly flushed.
        repeat (4) @(posedge clk);
 
        // assert reset again, mid-pipeline, to prove everything clears
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;
 
        // run further to observe PC restart from 0 and confirm
        // no flushed/in-flight instruction incorrectly commits
        repeat (20) @(posedge clk);
 
        $finish;
    end
 
    // waveform dump only - no $display
    initial begin
        $dumpfile("riscv_processor_tb_case9_reset.vcd");
        $dumpvars(0, riscv_processor_tb_case9_reset);
    end
 
endmodule