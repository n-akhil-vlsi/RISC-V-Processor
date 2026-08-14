module branch_unit(

    input wire Branch,
    input wire Jump,
    input wire JALR,
    input wire Zero,          // from ALU: (ALU_result == 0)
    input wire [2:0] funct3,  // NEW: needed to decode branch condition

    input wire [31:0] pc,
    input wire [31:0] rs1,
    input wire [31:0] immediate,

    output wire PCSrc,
    output wire [31:0] branch_target

);

    // Branch Target Address
    // JALR: (rs1 + imm) with LSB cleared | JAL/Branch: pc + imm
    assign branch_target = (JALR) ?
                            ((rs1 + immediate) & 32'hFFFFFFFE) :
                            (pc + immediate);

    // Decode branch condition from funct3
    // ALUControl for branches (from alu_control):
    //   BEQ/BNE  -> SUB   : Zero=1 means rs1==rs2
    //   BLT/BLTU -> SLT/SLTU : ALU result = (rs1<rs2) ? 1 : 0
    //                          Zero=1 means result==0, i.e. rs1>=rs2
    //   BGE/BGEU -> same SLT/SLTU, branch_unit inverts by using Zero directly
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

    // Select Next PC
    assign PCSrc = (Branch & branch_taken) | Jump;

endmodule