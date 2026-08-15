module data_memory(
 
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
 
    input wire [2:0] funct3,      // selects byte/halfword/word width + sign/zero extend
 
    input wire [31:0] address,
    input wire [31:0] write_data,
 
    output reg [31:0] read_data
 
);
 
reg [31:0] memory [0:63];
 
wire [5:0] word_addr;                 // Which 32-bit word??out of (there are total 64 register)
wire [1:0] byte_offset;               // Which byte inside that word
 
assign word_addr   = address[7:2];    //LSB 2 bits are ignored because they are always 0-aligned for words.
assign byte_offset  = address[1:0];
 
// Synchronous Write (byte-enable masked, based on funct3)

always @(posedge clk) 
begin 
    if(MemWrite) begin
 
        case(funct3)
 
            3'b000: begin // Store Byte
                case(byte_offset)
                    2'b00: memory[word_addr][7:0]   <= write_data[7:0];
                    2'b01: memory[word_addr][15:8]  <= write_data[7:0];
                    2'b10: memory[word_addr][23:16] <= write_data[7:0];
                    2'b11: memory[word_addr][31:24] <= write_data[7:0];
                endcase
            end
 
            3'b001: begin // Store Hlaf Word
                if(byte_offset[1] == 1'b0)
                    memory[word_addr][15:0]  <= write_data[15:0];
                else
                    memory[word_addr][31:16] <= write_data[15:0];
            end
 
            3'b010: begin // Store Word
                memory[word_addr] <= write_data;
            end
 
            default: begin
                memory[word_addr] <= write_data; // fallback: treat as SW
            end
 
        endcase
 
    end
 
end
 

// Asynchronous Read (width select + sign/zero extend, based on funct3)

always @(*) begin
 
    if(MemRead) begin
 
        case(funct3)
 
            3'b000: begin // Load Byte (sign-extend byte)
                case(byte_offset)
                    2'b00: read_data = {{24{memory[word_addr][7]}},  memory[word_addr][7:0]};
                    2'b01: read_data = {{24{memory[word_addr][15]}}, memory[word_addr][15:8]};
                    2'b10: read_data = {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
                    2'b11: read_data = {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
                endcase
            end
 
            3'b001: begin // Load Half-word (sign-extend halfword)
                if(byte_offset[1] == 1'b0)
                    read_data = {{16{memory[word_addr][15]}}, memory[word_addr][15:0]};
                else
                    read_data = {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
            end
 
            3'b010: begin // Load Word
                read_data = memory[word_addr];
            end
 
            3'b100: begin // Load Byte Unsigned (zero-extend byte)
                case(byte_offset)
                    2'b00: read_data = {24'b0, memory[word_addr][7:0]};
                    2'b01: read_data = {24'b0, memory[word_addr][15:8]};
                    2'b10: read_data = {24'b0, memory[word_addr][23:16]};
                    2'b11: read_data = {24'b0, memory[word_addr][31:24]};
                endcase
            end
 
            3'b101: begin // Load Half-word Unsigned (zero-extend halfword)
                if(byte_offset[1] == 1'b0)
                    read_data = {16'b0, memory[word_addr][15:0]};
                else
                    read_data = {16'b0, memory[word_addr][31:16]};
            end
 
            default: begin
                read_data = memory[word_addr]; // fallback: treat as LW
            end
 
        endcase
 
    end
    else begin
        read_data = 32'd0;
    end
 
end
 
endmodule
 