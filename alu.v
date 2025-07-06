module alu (
    input [7:0] i_Val_1,
    input [7:0] i_Val_2,
    input [2:0] i_ALU_Op,
    output reg [7:0] o_Result,
    output reg o_Overflow,
    output reg o_Zero_Flag
);

wire [7:0] add_result = i_Val_1 + i_Val_2;
wire [7:0] sub_result = i_Val_1 - i_Val_2;

always @(*)
begin
case (i_ALU_Op)
    3'b001: //ADD
    begin
    o_Result = add_result;     
    o_Overflow = (~i_Val_1[7] & ~i_Val_2[7] & add_result[7]) | (i_Val_1[7] & i_Val_2[7] & ~add_result[7]);
    o_Zero_Flag = (add_result == 0);
    end
    3'b010: //SUB
    begin
    o_Result = sub_result;
    o_Overflow = (~i_Val_1[7] & i_Val_2[7] & sub_result[7]) | (i_Val_1[7] & ~i_Val_2[7] & ~sub_result[7]);
    o_Zero_Flag = (sub_result == 0);
    end
    default:
    begin
    o_Result = 8'b0;
    o_Overflow = 1'b0;
    end
endcase
end
    
endmodule