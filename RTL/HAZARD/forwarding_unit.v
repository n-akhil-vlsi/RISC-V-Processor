module forwarding_unit(                               //we can imagine that the forwarding unit is present at the top or beside the datapath which takes signals from different pipeline stages and analyze them.

    input wire EX_MEM_RegWrite,
    input wire [4:0] EX_MEM_rd,

    input wire MEM_WB_RegWrite,
    input wire [4:0] MEM_WB_rd,

    input wire [4:0] ID_EX_rs1,
    input wire [4:0] ID_EX_rs2,

    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB                          //                            ADD  x5, x1, x2
                                                       //ADD x5, x1, x2     or       AND  x7, x8, x9
                                                       //SUB x6, x5, x3              SUB  x6, x5, x3
);                                                     //regwrite is compulsary because,the instruction should keep the final value in the destination register. 
                                                       //if it is store then we dont need the destination register value.so we dont need this condition.
always @(*) begin

    ForwardA = 2'b00;
    ForwardB = 2'b00;
    
     //Here EX_MEM_RD and MEM_WB_RD should not be x0,becz we cant write value into the x0 reg it is always 0.If the rd is x0 then we dont forward the value becz x0 dont update any value.

     //When EX/MEM and MEM/WB both match the source register, select EX/MEM because it contains the newer value.That is the reason we write EX_MEM_RD in IF case. Priority---(EX_MEM_RD>MEM_WB_RD)
       
    // ForwardA Logic
    if (EX_MEM_RegWrite &&(EX_MEM_rd != 5'd0) &&(EX_MEM_rd == ID_EX_rs1))

        ForwardA = 2'b10;

    else if (MEM_WB_RegWrite &&(MEM_WB_rd != 5'd0) &&(MEM_WB_rd == ID_EX_rs1))

        ForwardA = 2'b01;

    // ForwardB Logic
    if (EX_MEM_RegWrite &&(EX_MEM_rd != 5'd0) &&(EX_MEM_rd == ID_EX_rs2))

        ForwardB = 2'b10;

    else if (MEM_WB_RegWrite &&(MEM_WB_rd != 5'd0) &&(MEM_WB_rd == ID_EX_rs2))

        ForwardB = 2'b01;

end

endmodule