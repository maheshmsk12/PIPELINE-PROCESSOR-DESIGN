module pipelined(clk,rst);
    input clk;
    input rst;
 
	
    reg [31:0] PC;
    reg [31:0] instr_mem[0:15];
    reg [31:0] regfile[0:15];
    reg [31:0] data_mem[0:15];

    // Pipeline Registers
    reg [31:0] IF_ID_instr;
    reg [31:0] ID_EX_opA, ID_EX_opB;
    reg [3:0] ID_EX_rd;
    reg [2:0] ID_EX_opcode;
    reg [31:0] EX_WB_result;
    reg [3:0] EX_WB_rd;
    reg EX_WB_write;

    // Opcodes
    localparam ADD = 3'b000,
               SUB = 3'b001,
               AND = 3'b010,
               LOAD = 3'b011;

    // Instruction Fetch (IF)
    always @(posedge clk) begin
        if (rst) begin
            PC <= 0;
        end else begin
            IF_ID_instr <= instr_mem[PC >> 2];
            PC <= PC + 4;
        end
    end

    // Instruction Decode (ID)
    wire [2:0] opcode = IF_ID_instr[31:29];
    wire [3:0] rs = IF_ID_instr[28:25];
    wire [3:0] rt = IF_ID_instr[24:21];
    wire [3:0] rd = IF_ID_instr[20:17];

    always @(posedge clk) begin
        ID_EX_opA <= regfile[rs];
        ID_EX_opB <= regfile[rt];
        ID_EX_rd <= rd;
        ID_EX_opcode <= opcode;
    end

    // Execute (EX)
    reg [31:0] ALU_result;

    always @(*) begin
        case (ID_EX_opcode)
            ADD:  ALU_result = ID_EX_opA + ID_EX_opB;
            SUB:  ALU_result = ID_EX_opA - ID_EX_opB;
            AND: ALU_result = ID_EX_opA & ID_EX_opB;
            LOAD: ALU_result = data_mem[ID_EX_opB];
            default: ALU_result = 0;
        endcase
    end

    always @(posedge clk) begin
        EX_WB_result <= ALU_result;
        EX_WB_rd <= ID_EX_rd;
        EX_WB_write <= 1'b1;
    end

    // Write Back (WB)
    always @(posedge clk) begin
        if (EX_WB_write && EX_WB_rd != 4'b0000) begin
            regfile[EX_WB_rd] <= EX_WB_result;
        end
    end
endmodule





