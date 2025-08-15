module ROTL(
  input [63:0] a,
  input [5:0] n,
  output [63:0] out
);
  assign out = (a << n) | (a >> (64 - n));
endmodule
