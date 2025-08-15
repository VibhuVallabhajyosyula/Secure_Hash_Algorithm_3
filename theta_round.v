module theta_round(
  input clk,
  input rst,
  input start,
  input [1599:0] state_in,
  output reg done,
  output reg [1599:0] theta_transform
);

  reg [1:0] state;

  reg [63:0] C0, C1, C2, C3, C4;
  reg [63:0] D0, D1, D2, D3, D4;

  wire [63:0] rot0, rot1, rot2, rot3, rot4;

  ROTL rot0_inst(.a(C1), .n(6'd1), .out(rot0));
  ROTL rot1_inst(.a(C2), .n(6'd1), .out(rot1));
  ROTL rot2_inst(.a(C3), .n(6'd1), .out(rot2));
  ROTL rot3_inst(.a(C4), .n(6'd1), .out(rot3));
  ROTL rot4_inst(.a(C0), .n(6'd1), .out(rot4));

  always @(posedge clk) begin
    if (rst) begin
      state <= 0;
      done <= 0;
      theta_transform <= 1600'd0;
      C0 <= 0; C1 <= 0; C2 <= 0; C3 <= 0; C4 <= 0;
      D0 <= 0; D1 <= 0; D2 <= 0; D3 <= 0; D4 <= 0;
    end else begin
      case (state)
        0: begin
          done <= 0;
          if (start) begin
            C0 <= state_in[   0 +: 64] ^ state_in[ 320 +: 64] ^ state_in[ 640 +: 64] ^ state_in[ 960 +: 64] ^ state_in[1280 +: 64];
            C1 <= state_in[  64 +: 64] ^ state_in[ 384 +: 64] ^ state_in[ 704 +: 64] ^ state_in[1024 +: 64] ^ state_in[1344 +: 64];
            C2 <= state_in[ 128 +: 64] ^ state_in[ 448 +: 64] ^ state_in[ 768 +: 64] ^ state_in[1088 +: 64] ^ state_in[1408 +: 64];
            C3 <= state_in[ 192 +: 64] ^ state_in[ 512 +: 64] ^ state_in[ 832 +: 64] ^ state_in[1152 +: 64] ^ state_in[1472 +: 64];
            C4 <= state_in[ 256 +: 64] ^ state_in[ 576 +: 64] ^ state_in[ 896 +: 64] ^ state_in[1216 +: 64] ^ state_in[1536 +: 64];
            state <= 1;
          end
        end

        1: begin
          D0 <= C4 ^ rot0;
          D1 <= C0 ^ rot1;
          D2 <= C1 ^ rot2;
          D3 <= C2 ^ rot3;
          D4 <= C3 ^ rot4;
          state <= 2;
        end

        2: begin
          theta_transform[   0 +: 64] <= state_in[   0 +: 64] ^ D0;
          theta_transform[  64 +: 64] <= state_in[  64 +: 64] ^ D1;
          theta_transform[ 128 +: 64] <= state_in[ 128 +: 64] ^ D2;
          theta_transform[ 192 +: 64] <= state_in[ 192 +: 64] ^ D3;
          theta_transform[ 256 +: 64] <= state_in[ 256 +: 64] ^ D4;

          theta_transform[ 320 +: 64] <= state_in[ 320 +: 64] ^ D0;
          theta_transform[ 384 +: 64] <= state_in[ 384 +: 64] ^ D1;
          theta_transform[ 448 +: 64] <= state_in[ 448 +: 64] ^ D2;
          theta_transform[ 512 +: 64] <= state_in[ 512 +: 64] ^ D3;
          theta_transform[ 576 +: 64] <= state_in[ 576 +: 64] ^ D4;

          theta_transform[ 640 +: 64] <= state_in[ 640 +: 64] ^ D0;
          theta_transform[ 704 +: 64] <= state_in[ 704 +: 64] ^ D1;
          theta_transform[ 768 +: 64] <= state_in[ 768 +: 64] ^ D2;
          theta_transform[ 832 +: 64] <= state_in[ 832 +: 64] ^ D3;
          theta_transform[ 896 +: 64] <= state_in[ 896 +: 64] ^ D4;

          theta_transform[ 960 +: 64]  <= state_in[ 960 +: 64] ^ D0;
          theta_transform[1024 +: 64] <= state_in[1024 +: 64] ^ D1;
          theta_transform[1088 +: 64] <= state_in[1088 +: 64] ^ D2;
          theta_transform[1152 +: 64] <= state_in[1152 +: 64] ^ D3;
          theta_transform[1216 +: 64] <= state_in[1216 +: 64] ^ D4;

          theta_transform[1280 +: 64] <= state_in[1280 +: 64] ^ D0;
          theta_transform[1344 +: 64] <= state_in[1344 +: 64] ^ D1;
          theta_transform[1408 +: 64] <= state_in[1408 +: 64] ^ D2;
          theta_transform[1472 +: 64] <= state_in[1472 +: 64] ^ D3;
          theta_transform[1536 +: 64] <= state_in[1536 +: 64] ^ D4;

          done <= 1;
          state <= 3;
          
        end

        3: begin
       // $display("After theta:%h",theta_transform);
          done <= 0;
          state <= 0;
        end
      endcase
    end
  end
endmodule
