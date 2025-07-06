(* keep *) module ram (
    input i_Clk,
    input [4:0] i_Addr,
    input i_Write_En,
    input [7:0] i_Data,
    output [7:0] o_Data,
    output [2:0] o_Test
);

//Memory Array
reg [7:0] memory[0:31];


//NO LOAD_IMMEDIATE - Must Prelaod Ram

    // Hardcoded preload
initial begin
    memory[2] = 8'd3;  // Value for LOAD R1, 2
    memory[3] = 8'd3;  // Value for LOAD R2, 3
    // Add more as needed
end



//Write Logic - Sync
always @(posedge i_Clk)
begin
    if(i_Write_En)
        memory[i_Addr] <= i_Data;
end

//Read Logic - Async
assign o_Data = memory[i_Addr];



//testing
assign o_Test = memory[6][2:0];

endmodule