module rho_round(
   clk,
   rst,
   start,
   state,
   done,
    rho_transform
);
   input clk;
   input rst;
   input start;
   input wire [1599:0] state;
   output reg [1599:0] rho_transform;
   
   output reg done;
   

  wire [63:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24;
  reg active;
  reg [1:0] fsm_state;
  
  
  ROTL r0_inst (.a(state[   0 +: 64]), .n(6'd0),  .out(r0));
  ROTL r1_inst (.a(state[  64 +: 64]), .n(6'd1), .out(r1));
  ROTL r2_inst (.a(state[ 128 +: 64]), .n(6'd62),  .out(r2));
  ROTL r3_inst (.a(state[ 192 +: 64]), .n(6'd28), .out(r3));
  ROTL r4_inst (.a(state[ 256 +: 64]), .n(6'd27), .out(r4));

  ROTL r5_inst (.a(state[ 320 +: 64]), .n(6'd36),  .out(r5));
  ROTL r6_inst (.a(state[ 384 +: 64]), .n(6'd44), .out(r6));
  ROTL r7_inst (.a(state[ 448 +: 64]), .n(6'd6), .out(r7));
  ROTL r8_inst (.a(state[ 512 +: 64]), .n(6'd55), .out(r8));
  ROTL r9_inst (.a(state[ 576 +: 64]), .n(6'd20),  .out(r9));

  ROTL r10_inst(.a(state[ 640 +: 64]), .n(6'd3), .out(r10));
  ROTL r11_inst(.a(state[ 704 +: 64]), .n(6'd10),  .out(r11));
  ROTL r12_inst(.a(state[ 768 +: 64]), .n(6'd43), .out(r12));
  ROTL r13_inst(.a(state[ 832 +: 64]), .n(6'd25), .out(r13));
  ROTL r14_inst(.a(state[ 896 +: 64]), .n(6'd39), .out(r14));

  ROTL r15_inst(.a(state[ 960 +: 64]), .n(6'd41), .out(r15));
  ROTL r16_inst(.a(state[1024 +: 64]), .n(6'd45), .out(r16));
  ROTL r17_inst(.a(state[1088 +: 64]), .n(6'd15), .out(r17));
  ROTL r18_inst(.a(state[1152 +: 64]), .n(6'd21), .out(r18));
  ROTL r19_inst(.a(state[1216 +: 64]), .n(6'd8), .out(r19));

  ROTL r20_inst(.a(state[1280 +: 64]), .n(6'd18), .out(r20));
  ROTL r21_inst(.a(state[1344 +: 64]), .n(6'd2), .out(r21));
  ROTL r22_inst(.a(state[1408 +: 64]), .n(6'd61), .out(r22));
  ROTL r23_inst(.a(state[1472 +: 64]), .n(6'd56),  .out(r23));
  ROTL r24_inst(.a(state[1536 +: 64]), .n(6'd14), .out(r24));

  always@(posedge clk)
    begin
      if(rst)
        begin
          rho_transform <= 1600'd0;
          done <= 0;
          fsm_state<=0;
        end
      else
        begin
        case(fsm_state)
        0:begin
          
          if(start)
            begin
      rho_transform[   0 +: 64] <= r0;
      rho_transform[  64 +: 64] <= r1;
      rho_transform[ 128 +: 64] <= r2;
      rho_transform[ 192 +: 64] <= r3;
      rho_transform[ 256 +: 64] <= r4;
          
      rho_transform[ 320 +: 64] <= r5;
      rho_transform[ 384 +: 64] <= r6;
      rho_transform[ 448 +: 64] <= r7;
      rho_transform[ 512 +: 64] <= r8;
      rho_transform[ 576 +: 64] <= r9;
          
      rho_transform[ 640 +: 64] <= r10;
      rho_transform[ 704 +: 64] <= r11;
      rho_transform[ 768 +: 64] <= r12;
      rho_transform[ 832 +: 64] <= r13;
      rho_transform[ 896 +: 64] <= r14;
          
      rho_transform[ 960 +: 64] <= r15;
      rho_transform[1024 +: 64] <= r16;
      rho_transform[1088 +: 64] <= r17;
      rho_transform[1152 +: 64] <= r18;
      rho_transform[1216 +: 64] <= r19;
          
      rho_transform[1280 +: 64] <= r20;
      rho_transform[1344 +: 64] <= r21;
      rho_transform[1408 +: 64] <= r22;
      rho_transform[1472 +: 64] <= r23;
      rho_transform[1536 +: 64] <= r24;
          
         done <= 1;
          fsm_state<=1;
        end
        end
      1:begin  
      // $display("After rho:%h",rho_transform);
      done <= 0;
      fsm_state<=0;
      end
    
    
    endcase
    
    end
    end
endmodule
