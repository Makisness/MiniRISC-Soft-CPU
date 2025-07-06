module instruction_decoder (
    input [7:0] i_Inst,
    output [2:0] o_Op,
    output [1:0] o_Reg1,
    output [2:0] o_Reg_Imm
);
    
assign o_Op = i_Inst[7:5];
assign o_Reg1 = i_Inst[4:3];
assign o_Reg_Imm = i_Inst [2:0];

endmodule