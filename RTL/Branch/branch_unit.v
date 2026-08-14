module branch_unit(

    input wire Branch,
    input wire Jump,
    input wire Zero,

    input wire [31:0] pc,
    input wire [31:0] immediate,

    output wire PCSrc,
    output wire [31:0] branch_target

);

    // Branch Target Address
    assign branch_target = pc + immediate;

    // Select Next PC
    assign PCSrc = (Branch & Zero) | Jump;

endmodule