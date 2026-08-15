module branch_unit(               //this module is used for the branch or jump instruction(PC).

    input wire Branch,
    input wire Jump,
    input wire JALR,
    input wire Zero,          
    input wire [2:0] funct3,  //needed to decode branch condition

    input wire [31:0] pc,
    input wire [31:0] rs1,
    input wire [31:0] immediate,

    output wire PCSrc,
    output wire [31:0] branch_target

);

    //we make the lsb 0 to ensure the JALR target address is properly aligned, as required by the RISC-V specification.
    assign branch_target = (JALR) ? ((rs1 + immediate) & 32'hFFFFFFFE) :(pc + immediate);

    reg branch_taken;

    always @(*) begin
        case(funct3)
            3'b000: branch_taken = Zero;    // BEQ:  rs1 == rs2
            3'b001: branch_taken = ~Zero;   // BNE:  rs1 != rs2
            3'b100: branch_taken = ~Zero;   // BLT:  rs1 <  rs2  (SLT result=1 -> Zero=0)
            3'b101: branch_taken = Zero;    // BGE:  rs1 >= rs2  (SLT result=0 -> Zero=1)
            3'b110: branch_taken = ~Zero;   // BLTU: rs1 <  rs2 (unsigned)
            3'b111: branch_taken = Zero;    // BGEU: rs1 >= rs2 (unsigned)
            default: branch_taken = 1'b0;
        endcase
    end

    //mux for next PC
    assign PCSrc = (Branch & branch_taken) | Jump;

endmodule