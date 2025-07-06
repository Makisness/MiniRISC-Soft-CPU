module rom (
    input [4:0] i_Addr,
    output [7:0] o_Inst
);
//Memory Array    
reg [7:0] Memory [0:31];

//Load program into ROM
initial begin
    $readmemh("program.hex", Memory);
end
//Output instruction
assign o_Inst = Memory[i_Addr];

endmodule