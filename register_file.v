(* keep *) module register_file (
    input i_Clk,

    //Read Addresses
    input [1:0] i_Reg1,
    input [2:0] i_Reg_Imm,

    //Write Inputs
    input i_Write_En,
    input [1:0] i_Write_Sel,
    input [7:0] i_Write_Data,

    //Read Data Out
    output [7:0] o_Read_Data_1,
    output [7:0] o_Read_Data_2
);



reg [7:0] regs[0:3]; //R0-R3

wire [1:0] read_sel_1 = i_Reg1;
wire [1:0] read_sel_2 = i_Reg_Imm[1:0];  //READS are only for reg2. Can safely truncate | Rsrc can be reg2 or imm3

//Read Registers
assign o_Read_Data_1 = regs[read_sel_1];
assign o_Read_Data_2 = regs[read_sel_2];

always @(posedge i_Clk)
begin
    if(i_Write_En)
        regs[i_Write_Sel] <= i_Write_Data;
end

endmodule