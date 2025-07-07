(* keep *) module main (
    input i_Clk,

    //For Testing
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G
 
);

    //LUT optimization culls these if not explicitly kept
    //I imagine that there is a better way to do this but APIO is limiting

    (* keep *) reg rst = 1'b0;
    (* keep *) wire [4:0] w_ROM_Addr;   //read rom @ addr
    (* keep *) wire [4:0] w_PC;         //set pc
    (* keep *) wire [7:0] w_Inst;
    (* keep *) wire [2:0] w_Op;
    (* keep *) wire [1:0] w_Reg1;
    (* keep *) wire [2:0] w_Reg_Imm;
    (* keep *) wire [7:0] w_Rdst_Val;
    (* keep *) wire [7:0] w_Rsrc_Val;
    (* keep *) wire [7:0] w_Result;
    (* keep *) wire [1:0] w_Reg_Addr;
    (* keep *) wire [4:0] w_Mem_Addr;
    (* keep *) wire [2:0] w_ALU_Op;
    (* keep *) wire [7:0] w_MemData;
    (* keep *) wire w_Zero_Flag;
    (* keep *) wire w_Overflow;
    (* keep *) wire w_UseImm;
    (* keep *) wire w_RegWrite_En;
    (* keep *) wire w_MemWrite_En;
    (* keep *) wire w_UseMem;
    (* keep *) wire w_Jmp_En;
    (* keep *) wire w_Halt;

    (* keep *) wire [7:0] w_BusData = (w_UseMem == 1'b1) ? w_MemData : w_Result;

////////////// TESTING
    (* keep *) wire [3:0] w_Test_Val;


    wire w_Segment2_A;
    wire w_Segment2_B;
    wire w_Segment2_C;
    wire w_Segment2_D;
    wire w_Segment2_E;
    wire w_Segment2_F;
    wire w_Segment2_G;


    Binary_To_7Segment binary_seven_seg_instance
    (
        .i_Clk(i_Clk),
        .i_Binary_Num(w_Test_Val),
        .o_Segment_A(w_Segment2_A),
        .o_Segment_B(w_Segment2_B),
        .o_Segment_C(w_Segment2_C),
        .o_Segment_D(w_Segment2_D),
        .o_Segment_E(w_Segment2_E),
        .o_Segment_F(w_Segment2_F),
        .o_Segment_G(w_Segment2_G)
    );

    assign o_Segment2_A = ~w_Segment2_A;
    assign o_Segment2_B = ~w_Segment2_B;
    assign o_Segment2_C = ~w_Segment2_C;
    assign o_Segment2_D = ~w_Segment2_D;
    assign o_Segment2_E = ~w_Segment2_E;
    assign o_Segment2_F = ~w_Segment2_F;
    assign o_Segment2_G = ~w_Segment2_G;


//This will display the data listed at memory[6] in ram on the 7 segment display

//////////////////



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
        .o_Data(w_MemData),
        .o_Test(w_Test_Val)
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
        .i_Halt(w_Halt),
        .i_Jmp_En(w_Jmp_En),
        .i_Jmp_Addr(w_PC),
        .o_PC(w_ROM_Addr)
    );

endmodule