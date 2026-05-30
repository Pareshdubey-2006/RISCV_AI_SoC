module pe #(
    parameter WIDTH = 8
)(
    input clk,

    input [WIDTH-1:0] a_in,
    input [WIDTH-1:0] b_in,

    input [(2*WIDTH)-1:0] acc_in,

    output reg [WIDTH-1:0] a_out,
    output reg [WIDTH-1:0] b_out,

    output reg [(2*WIDTH)-1:0] acc_out
);

always @(posedge clk)
begin

    acc_out <= acc_in + (a_in * b_in);

    a_out <= a_in;

    b_out <= b_in;

end

endmodule