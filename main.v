module main (
    input i_Clk,
    output o_LED_1
);

    reg rst = 1'b0;
    wire [4:0] w_ROM_Addr; //read rom @ addr
    wire [4:0] w_PC;  //set pc
    wire [7:0] w_Inst;
    wire [2:0] w_Op;
    wire [1:0] w_Reg1;
    wire [2:0] w_Reg_Imm;
    wire [7:0] w_Rdst_Val;
    wire [7:0] w_Rsrc_Val;
    wire [7:0] w_Result;
    wire [1:0] w_Reg_Addr;
    wire [4:0] w_Mem_Addr;
    wire [2:0] w_ALU_Op;
    wire [7:0] w_MemData;
    wire w_Zero_Flag;
    wire w_Overflow;
    wire w_UseImm;
    wire w_RegWrite_En;
    wire w_MemWrite_En;
    wire w_UseMem;
    wire w_Jmp_En;
    wire w_Halt;
    wire [7:0] w_BusData = (w_UseMem == 1'b1) ? w_MemData : w_Result;

    rom rom_instance
    (
        .i_Addr(w_ROM_Addr),
        .o_Inst(w_Inst)
    );

    ram ram_instance
    (
        .i_Clk(i_Clk),
        .i_Addr(w_Mem_Addr),
        .i_Write_En(w_MemWrite_En),
        .i_Data(w_Rdst_Val),
        .o_Data(w_MemData)
    );

    instruction_decoder decoder_instance
    (
        .i_Inst(w_Inst),
        .o_Op(w_Op),
        .o_Reg1(w_Reg1),
        .o_Reg_Imm(w_Reg_Imm)
    );

    alu alu_instance
    (
        .i_Val_1(w_Rdst_Val),
        .i_Val_2(w_Rsrc_Val),
        .i_ALU_Op(w_ALU_Op),
        .o_Result(w_Result),
        .o_Overflow(w_Overflow),
        .o_Zero_Flag(w_Zero_Flag)
    );

    register_file regfile_instance
    (
        .i_Clk(i_Clk),
        .i_Reg1(w_Reg1),
        .i_Reg_Imm(w_Reg_Imm),
        .i_Write_En(w_RegWrite_En),
        .i_Write_Sel(w_Reg_Addr),
        .i_Write_Data(w_BusData),
        .o_Read_Data_1(w_Rdst_Val),
        .o_Read_Data_2(w_Rsrc_Val)
    );


    control control_instance
    (
        .i_Op(w_Op),
        .i_Rdst(w_Reg1),
        .i_Rsrc_Imm(w_Reg_Imm),
        .i_Zero_Flag(w_Zero_Flag),
        .i_Overflow(w_Overflow),
        .o_UseImm(w_UseImm),
        .o_RegWrite_En(w_RegWrite_En),
        .o_Reg_Addr(w_Reg_Addr),
        .o_UseMem(w_UseMem),
        .o_MemWrite_En(w_MemWrite_En),
        .o_Mem_Addr(w_Mem_Addr),
        .o_ALU_Op(w_ALU_Op),
        .o_PCSelect(w_Jmp_En),
        .o_PCAddr(w_PC),
        .o_Halt(w_Halt)
    );

    program_counter pc_instance
    (
        .i_Rst(rst),
        .i_Clk(i_Clk),
        .i_Jmp_En(w_Jmp_En),
        .i_Jmp_Addr(w_PC),
        .o_PC(w_ROM_Addr)
    );


    assign o_LED_1 = w_Rdst_Val[3];


endmodule