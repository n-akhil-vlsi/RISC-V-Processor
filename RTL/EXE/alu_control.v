module alu_control(

    input  wire [1:0] ALUOp,                        //from the control unit
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    output reg [3:0] ALUControl

);

always @(*) begin

    case(ALUOp)

        // Load / Store
        2'b00:
            ALUControl = 4'b0000;   // ADD

        // Branch
        2'b01:
        begin
            case(funct3)

                3'b000: ALUControl = 4'b0001;   // BEQ  -> SUB (branch_unit checks Zero)
                3'b001: ALUControl = 4'b0001;   // BNE  -> SUB (branch_unit checks !Zero)
                3'b100: ALUControl = 4'b1000;   // BLT  -> SLT
                3'b101: ALUControl = 4'b1000;   // BGE  -> SLT (branch_unit inverts result)
                3'b110: ALUControl = 4'b1001;   // BLTU -> SLTU
                3'b111: ALUControl = 4'b1001;   // BGEU -> SLTU (branch_unit inverts result)

                default: ALUControl = 4'b0001;  // fallback: SUB

            endcase
        end

        // R-Type
        2'b10:
        begin
            case(funct3)

                3'b000:
                    if(funct7 == 7'b0100000)
                        ALUControl = 4'b0001;   // SUB
                    else if(funct7 == 7'b0000000)
                        ALUControl = 4'b0000;   // ADD
                    else
                        ALUControl = 4'b0000;   // fallback

                3'b111:
                    ALUControl = 4'b0010;       // AND

                3'b110:
                    ALUControl = 4'b0011;       // OR

                3'b100:
                    ALUControl = 4'b0100;       // XOR

                3'b001:
                    ALUControl = 4'b0101;       // SLL

                3'b101:
                    if(funct7 == 7'b0100000)
                        ALUControl = 4'b0111;   // SRA
                    else if(funct7 == 7'b0000000)
                        ALUControl = 4'b0110;   // SRL
                    else
                        ALUControl = 4'b0110;   // fallback

                3'b010:
                    ALUControl = 4'b1000;       // SLT

                3'b011:
                    ALUControl = 4'b1001;       // SLTU

                default:
                    ALUControl = 4'b0000;

            endcase
        end

        // I-Type Arithmetic
        2'b11:
        begin
            case(funct3)

                3'b000: ALUControl = 4'b0000;   // ADDI
                3'b111: ALUControl = 4'b0010;   // ANDI
                3'b110: ALUControl = 4'b0011;   // ORI
                3'b100: ALUControl = 4'b0100;   // XORI
                3'b010: ALUControl = 4'b1000;   // SLTI
                3'b011: ALUControl = 4'b1001;   // SLTIU
                3'b001: ALUControl = 4'b0101;   // SLLI

                3'b101:
                    if(funct7 == 7'b0100000)
                        ALUControl = 4'b0111;   // SRAI
                    else
                        ALUControl = 4'b0110;   // SRLI

                default: ALUControl = 4'b0000;

            endcase
        end

        default:
            ALUControl = 4'b0000;

    endcase

end

endmodule