module iota_round(
  input clk,
  input rst,
  input start,
  input [4:0] round,
  input [1599:0] state,
  output reg done,
  output reg [1599:0] iota_transform
);
  wire [63:0] RC;
  reg [1:0] fsm_state;
  
  round_constant rou_con(.round(round), .RC(RC));
  
  always@(posedge clk) begin
    if(rst) begin
      iota_transform <= 1600'd0;
      done <= 0;
      fsm_state <= 0;
      
    end
    else begin
      case(fsm_state) 
        0: begin
          done <= 0; 
          if(start) begin
           
            iota_transform <= {state[1599:64], state[63:0] ^ RC};
            fsm_state <= 1;
          end
        end
        
        1: begin
          done <= 1;  
         // $display("After iota:%h",iota_transform); 
          if(!start) begin 
            fsm_state <= 0;
          end
        end
        
        default: fsm_state <= 0;
      endcase
    end
  end
endmodule
