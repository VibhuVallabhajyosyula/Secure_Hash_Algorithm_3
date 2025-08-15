module pi_round(
  input clk,
  input rst,
  input start,
  input [1599:0] state,
  output reg done,
  output reg [1599:0] pi_transform
);
  reg active;
  reg [1:0] fsm_state;
  always@(posedge clk)
    begin
      if(rst)
      begin
        pi_transform <= 1600'd0;
        done <= 0;
        active <= 0;
        fsm_state<=0;
      end
      else
        begin
        case(fsm_state) 
        0:begin
          if(start)
            begin
          pi_transform[   0 +: 64] <= state[   0 +: 64]; // (i=0, j=0)
		  pi_transform[ 640 +: 64] <= state[  64 +: 64]; // (i=1, j=0)
		  pi_transform[1280 +: 64] <= state[ 128 +: 64]; // (i=2, j=0)
		  pi_transform[ 320 +: 64] <= state[ 192 +: 64]; // (i=3, j=0)
		  pi_transform[ 960 +: 64] <= state[ 256 +: 64]; // (i=4, j=0)

		  pi_transform[1024 +: 64] <= state[ 320 +: 64]; // (i=0, j=1)
		  pi_transform[  64 +: 64] <= state[ 384 +: 64]; // (i=1, j=1)
		  pi_transform[ 704 +: 64] <= state[ 448 +: 64]; // (i=2, j=1)
		  pi_transform[1344 +: 64] <= state[ 512 +: 64]; // (i=3, j=1)
		  pi_transform[ 384 +: 64] <= state[ 576 +: 64]; // (i=4, j=1)

		  pi_transform[ 448 +: 64] <= state[ 640 +: 64]; // (i=0, j=2)
		  pi_transform[1088 +: 64] <= state[ 704 +: 64]; // (i=1, j=2)
		  pi_transform[ 128 +: 64] <= state[ 768 +: 64]; // (i=2, j=2)
		  pi_transform[ 768 +: 64] <= state[ 832 +: 64]; // (i=3, j=2)
		  pi_transform[1408 +: 64] <= state[ 896 +: 64]; // (i=4, j=2)

		  pi_transform[1472 +: 64] <= state[ 960 +: 64]; // (i=0, j=3)
		  pi_transform[ 512 +: 64] <= state[1024 +: 64]; // (i=1, j=3)
		  pi_transform[1152 +: 64] <= state[1088 +: 64]; // (i=2, j=3)
		  pi_transform[ 192 +: 64] <= state[1152 +: 64]; // (i=3, j=3)
		  pi_transform[ 832 +: 64] <= state[1216 +: 64]; // (i=4, j=3)

		  pi_transform[ 896 +: 64] <= state[1280 +: 64]; // (i=0, j=4)
		  pi_transform[1536 +: 64] <= state[1344 +: 64]; // (i=1, j=4)
		  pi_transform[ 576 +: 64] <= state[1408 +: 64]; // (i=2, j=4)
		  pi_transform[1216 +: 64] <= state[1472 +: 64]; // (i=3, j=4)
		  pi_transform[ 256 +: 64] <= state[1536 +: 64]; // (i=4, j=4)
          
          done <= 1;
          fsm_state<=1;
            end
          end
   1: begin
     // $display("After pi:%h",pi_transform);
      done <= 0;
      fsm_state<=0;
      
    end
    endcase
        end
        end
endmodule
