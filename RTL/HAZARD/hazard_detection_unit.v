module hazard_detection_unit(                    //this module is in the ID stage(in between the IF/ID AND ID/EXE).even though its inputs are from the exe state it works in the decode stage. 

    input wire ID_EX_MemRead,
    input wire [4:0] ID_EX_rd,

    input wire [4:0] IF_ID_rs1,
    input wire [4:0] IF_ID_rs2,

    output reg PCWrite,
    output reg IF_ID_Write,
    output reg ControlMux
                                                  // LW   x5, 0(x1)      Instruction 1
                                                  // ADD  x6, x5, x2     Instruction 2
);

always @(*) begin

    if (ID_EX_MemRead &&((ID_EX_rd == IF_ID_rs1) ||(ID_EX_rd == IF_ID_rs2))) 
    begin
        // Stall Pipeline
        PCWrite     = 1'b0;
        IF_ID_Write = 1'b0;
        ControlMux  = 1'b1;
    end

    else 
    begin
        // Normal Operation
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ControlMux  = 1'b0;
    end

end

endmodule