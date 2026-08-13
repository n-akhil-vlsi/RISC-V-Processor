module alu(

    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,              //from the alu_control

    output reg [31:0] Result,
    output wire Zero

);

always @(*) begin

    case(ALUControl)

        // ADD
        4'b0000:
            Result = A + B;

        // SUB
        4'b0001:
            Result = A - B;

        // AND
        4'b0010:
            Result = A & B;

        // OR
        4'b0011:
            Result = A | B;

        // XOR
        4'b0100:
            Result = A ^ B;

        // Shift Left Logical
        4'b0101:
            Result = A << B[4:0];

        // Shift Right Logical
        4'b0110:
            Result = A >> B[4:0];

        // Shift Right Arithmetic
        4'b0111:
            Result = $signed(A) >>> B[4:0];

        // Set Less Than
        4'b1000:
            Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;

        default:
            Result = 32'd0;

    endcase

end

assign Zero = (Result == 32'd0);

endmodule