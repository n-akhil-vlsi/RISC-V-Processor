module control_unit(

    input  wire [6:0] opcode,

    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,               //mux,before the input B of the ALU.
    output reg [1:0] ALUSrcA,        //mux,before the input A of the ALU. 00=rs1, 01=PC(AUIPC), 10=zero(LUI).
    output reg [1:0] ResultSrc,      // modified MemtoReg (1-bit) mux. 00=ALU, 01=Mem(LW), 10=PC+4(JAL,JALR).
    output reg Branch,
    output reg Jump,
    output reg JALR,             
    output reg [1:0] ALUOp

);

always @(*) begin
    
    
    RegWrite  = 0;
    MemRead   = 0;
    MemWrite  = 0;
    ALUSrc    = 0;
    ALUSrcA   = 2'b00;
    ResultSrc = 2'b00;  
    Branch    = 0;
    Jump      = 0;
    JALR      = 0;     
    ALUOp     = 2'b00;

    case(opcode)

        // R-Type
        7'b0110011: begin
            RegWrite = 1;
            ALUSrc   = 0;
            ALUOp    = 2'b10;
        end

        // I-Type Arithmetic (ADDI, ANDI...)
        7'b0010011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b11;
        end

        // Load Word (LW)
        7'b0000011: begin
            RegWrite  = 1;
            MemRead   = 1;
            ResultSrc = 2'b01;   
            ALUSrc    = 1;
            ALUOp     = 2'b00;
        end

        // Store Word (SW)
        7'b0100011: begin
            MemWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;
        end

        // Branch (BEQ/BNE/BLT,BGE,BGEU,BLTU)
        7'b1100011: begin
            Branch = 1;
            ALUOp  = 2'b01;
        end

        // JAL
        7'b1101111: begin
            Jump      = 1;
            RegWrite  = 1;
            ResultSrc = 2'b10;   
        end

        // JALR
        7'b1100111: begin
            Jump      = 1;
            JALR      = 1;      
            RegWrite  = 1;
            ALUSrc    = 1;
            ResultSrc = 2'b10;   
        end

        // LUI
        7'b0110111: begin
            RegWrite = 1;
            ALUSrc   = 1;
            ALUSrcA  = 2'b10;
        end

        // AUIPC
        7'b0010111: begin
            RegWrite = 1;
            ALUSrc   = 1;
            ALUSrcA  = 2'b01;
        end

        default: begin
        end

    endcase

end

endmodule