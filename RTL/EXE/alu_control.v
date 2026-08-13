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
            ALUControl = 4'b0001;   // SUB

        // R-Type
        2'b10:
        begin
            case(funct3)

                3'b000:
                    if(funct7 == 7'b0100000)
                        ALUControl = 4'b0001;   // SUB
                    else
                        ALUControl = 4'b0000;   // ADD

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
                    else
                        ALUControl = 4'b0110;   // SRL

                3'b010:
                    ALUControl = 4'b1000;       // SLT

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

                default: ALUControl = 4'b0000;

            endcase
        end

        default:
            ALUControl = 4'b0000;

    endcase

end

endmodule