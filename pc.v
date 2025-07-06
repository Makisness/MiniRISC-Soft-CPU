module program_counter (
    input i_Rst,
    input i_Halt,
    input i_Clk,
    input i_Jmp_En,
    input [4:0] i_Jmp_Addr,
    output [4:0]o_PC
);
//Program counter data
reg [4:0] PC_Current = 5'b0;

always @(posedge i_Clk or posedge i_Rst)
begin
    if(!i_Halt)
    begin
        if(i_Rst == 1'b1)   //if rst is high then reset
            PC_Current <= 0;
            else if(i_Jmp_En == 1'b1)   //if jmp_en is high then jump to addr
                PC_Current <= i_Jmp_Addr;
            else if(i_Jmp_En == 1'b0)   //if jump_en is low, standard increment
                PC_Current <= PC_Current + 1; 
            else    //else do nothing -- set equal for redundancy
                PC_Current <= PC_Current;
    end
end

assign o_PC = PC_Current;

endmodule