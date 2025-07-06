module control (
    input [2:0]i_Op,
    input [1:0]i_Rdst,       
    input [2:0] i_Rsrc_Imm,
    input i_Zero_Flag,
    input i_Overflow,
    output reg o_UseImm,
    output reg o_RegWrite_En,
    output reg [1:0] o_Reg_Addr,
    output reg o_UseMem,            //2-1 MUX for selecting regfile or RAM -- 0 = Use ALU | 1 = use RAM
    output reg o_MemWrite_En,
    output reg [4:0] o_Mem_Addr,
    output reg [2:0] o_ALU_Op,      //ALU Operation Selector
    output reg o_PCSelect,          //Jump_En
    output reg [4:0] o_PCAddr,
    output reg o_Halt           
);

//i_Overflow is not currently handled by control logic

//Op Code Macros
`define OP_NOP 3'b000
`define OP_ADD 3'b001
`define OP_SUB 3'b010
`define OP_LOAD 3'b011
`define OP_STORE 3'b100
`define OP_JUMP 3'b101
`define OP_JZ 3'b110
`define OP_HALT 3'b111

always @(*)
begin
    // Default outputs
    o_ALU_Op       = 3'b000;
    o_RegWrite_En  = 1'b0;
    o_Reg_Addr     = 2'b00;
    o_UseMem       = 1'b0;
    o_MemWrite_En  = 1'b0;
    o_Mem_Addr     = 5'b00000;
    o_PCSelect     = 1'b0;
    o_PCAddr       = 5'b00000;
    o_UseImm       = 1'b0;
    o_Halt         = 1'b0;

    case (i_Op)
        //NOP
        `OP_NOP: ;

        //ADD
        `OP_ADD:
            begin
                o_ALU_Op = i_Op;

                o_RegWrite_En = 1'b1;
                o_Reg_Addr = i_Rdst;

                o_UseMem = 1'b0; //Use ALU Result
                o_MemWrite_En = 1'b0;
                o_UseImm = 1'b0;

                o_PCSelect = 1'b0; //Standard behavior
                o_Halt = 1'b0;
            end

        //SUB
        `OP_SUB:
            begin
                o_ALU_Op = i_Op;

                o_RegWrite_En = 1'b1;
                o_Reg_Addr = i_Rdst;

                o_UseMem = 1'b0; //Use ALU Result
                o_MemWrite_En = 1'b0;
                o_UseImm = 1'b0;

                o_PCSelect = 1'b0; //Standard behavior
                o_Halt = 1'b0;
            end
        
        //LOAD
        `OP_LOAD:
            begin
                o_ALU_Op = 3'b000; //NOP

                //Write to Rdst from mem
                o_RegWrite_En = 1'b1;
                o_Reg_Addr = i_Rdst;

                //Read from imm3 address in mem
                o_MemWrite_En = 1'b0;
                o_UseMem = 1'b1; //Use RAM
                o_Mem_Addr = i_Rsrc_Imm;
                o_UseImm = 1'b1;

                o_PCSelect = 1'b0; //Standard behavior
                o_Halt = 1'b0;
            end
        
        //STORE
        `OP_STORE:
            begin
                o_ALU_Op = 3'b000; //NOP

                //read from (Source Register Rdst)
                o_RegWrite_En = 1'b0;
                o_Reg_Addr = i_Rdst;

                //Write to memory with imm3 address
                o_MemWrite_En = 1'b1;
                o_UseMem = 1'b1; //Use RAM
                o_Mem_Addr = i_Rsrc_Imm;
                o_UseImm = 1'b1;

                o_PCSelect = 1'b0; //Standard behavior
                o_Halt = 1'b0;
            end
        
        //JUMP - This implementation does not use indirect jumps
        //instruction format: [3-bit op][5-bit imm]
        `OP_JUMP:
            begin
                o_ALU_Op = 3'b000; //NOP

                //not used
                o_RegWrite_En = 1'b0;
                o_Reg_Addr = 2'b0;
                
                //not used
                o_MemWrite_En = 1'b0;
                o_UseMem = 1'b0;
                o_Mem_Addr = 3'b0;
                o_UseImm = 1'b0;

                o_PCSelect = 1'b1; //Jump Behavior
                o_PCAddr = {i_Rdst,i_Rsrc_Imm}; //[5-bit imm] Jump Target
                o_Halt = 1'b0;
            end

        //JUMP IF ZERO
        `OP_JZ:
            begin
                if(i_Zero_Flag == 0)
                begin
                    o_PCSelect = 1'b1; //Jump Behavior
                    o_PCAddr = {i_Rdst,i_Rsrc_Imm}; //[5-bit imm] Jump Target
                end
                else
                    o_PCSelect = 1'b0; //Standard Behavior

                o_ALU_Op = 3'b000; //NOP

                //not used
                o_RegWrite_En = 1'b0;
                o_Reg_Addr = 2'b0;
                
                //not used
                o_MemWrite_En = 1'b0;
                o_UseMem = 1'b0;
                o_Mem_Addr = 3'b0;
                o_UseImm = 1'b0;
                o_Halt = 1'b0;
            end

        //HALT
        `OP_HALT:
            begin
                o_ALU_Op = 3'b000; //NOP

                //not used
                o_RegWrite_En = 1'b0;
                
                //not used
                o_MemWrite_En = 1'b0;
                o_UseMem = 1'b0;
                o_UseImm = 1'b0;

                o_PCSelect = 1'b0;


                //HALT!
                o_Halt = 1'b1;
            end     

        default: ;//NOP
    endcase
end

endmodule