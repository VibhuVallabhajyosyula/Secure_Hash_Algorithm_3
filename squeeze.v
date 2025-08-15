module squeeze(
  input clk,
  input rst,
  input start,
  input [1599:0] state_out,
  output reg [255:0] hash_out,
  output reg done
);

  always @(posedge clk) begin
    if (rst) begin
      hash_out <= 256'd0;
      done <= 0;
    end
    else if (start) begin
      // Byte-reverse the output: reverse each 8-bit byte
      hash_out[7:0]     <= state_out[255:248];  // byte 31 -> byte 0
      hash_out[15:8]    <= state_out[247:240];  // byte 30 -> byte 1
      hash_out[23:16]   <= state_out[239:232];  // byte 29 -> byte 2
      hash_out[31:24]   <= state_out[231:224];  // byte 28 -> byte 3
      hash_out[39:32]   <= state_out[223:216];  // byte 27 -> byte 4
      hash_out[47:40]   <= state_out[215:208];  // byte 26 -> byte 5
      hash_out[55:48]   <= state_out[207:200];  // byte 25 -> byte 6
      hash_out[63:56]   <= state_out[199:192];  // byte 24 -> byte 7
      hash_out[71:64]   <= state_out[191:184];  // byte 23 -> byte 8
      hash_out[79:72]   <= state_out[183:176];  // byte 22 -> byte 9
      hash_out[87:80]   <= state_out[175:168];  // byte 21 -> byte 10
      hash_out[95:88]   <= state_out[167:160];  // byte 20 -> byte 11
      hash_out[103:96]  <= state_out[159:152];  // byte 19 -> byte 12
      hash_out[111:104] <= state_out[151:144];  // byte 18 -> byte 13
      hash_out[119:112] <= state_out[143:136];  // byte 17 -> byte 14
      hash_out[127:120] <= state_out[135:128];  // byte 16 -> byte 15
      hash_out[135:128] <= state_out[127:120];  // byte 15 -> byte 16
      hash_out[143:136] <= state_out[119:112];  // byte 14 -> byte 17
      hash_out[151:144] <= state_out[111:104];  // byte 13 -> byte 18
      hash_out[159:152] <= state_out[103:96];   // byte 12 -> byte 19
      hash_out[167:160] <= state_out[95:88];    // byte 11 -> byte 20
      hash_out[175:168] <= state_out[87:80];    // byte 10 -> byte 21
      hash_out[183:176] <= state_out[79:72];    // byte 9  -> byte 22
      hash_out[191:184] <= state_out[71:64];    // byte 8  -> byte 23
      hash_out[199:192] <= state_out[63:56];    // byte 7  -> byte 24
      hash_out[207:200] <= state_out[55:48];    // byte 6  -> byte 25
      hash_out[215:208] <= state_out[47:40];    // byte 5  -> byte 26
      hash_out[223:216] <= state_out[39:32];    // byte 4  -> byte 27
      hash_out[231:224] <= state_out[31:24];    // byte 3  -> byte 28
      hash_out[239:232] <= state_out[23:16];    // byte 2  -> byte 29
      hash_out[247:240] <= state_out[15:8];     // byte 1  -> byte 30
      hash_out[255:248] <= state_out[7:0];      // byte 0  -> byte 31
      
      done <= 1;  // pulse done for 1 cycle
    end
    else begin
      done <= 0;  // reset done when start is low
    end
  end

endmodule
