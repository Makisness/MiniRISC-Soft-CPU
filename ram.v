module ram (
    input i_Clk,
    input [4:0] i_Addr,
    input i_Write_En,
    input [7:0] i_Data,
    output [7:0] o_Data
);

//Memory Array
reg [7:0] memory[0:31];

//Write Logic - Sync
always @(posedge i_Clk)
begin
    if(i_Write_En)
        memory[i_Addr] <= i_Data;
end

//Read Logic - Async
assign o_Data = memory[i_Addr];


endmodule