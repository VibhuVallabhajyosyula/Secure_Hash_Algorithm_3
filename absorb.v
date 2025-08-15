module absorb(
  input clk,
  input rst,
  input [1087:0] message,    // either message or block_2 ..........implement block_2 logic in fsm
  input [1599:0] state_in,
  output reg [1599:0] state_out,
  output reg done
);
  parameter IDLE = 3'd0, PERMUTE = 3'd3;
  reg [2:0] next_state;
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          state_out <= 1600'd0;
          next_state <= IDLE;
          done <= 0;
        end
      else
        begin
          state_out[1087:0] <= state_in[1087:0] ^ message;
          state_out[1599:1088] <= state_in[1599:1088];
          next_state <= PERMUTE;
          done <= 1;
        end
    end
endmodule
