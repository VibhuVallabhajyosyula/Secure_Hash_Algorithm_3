module SHA3_top(clk, rst, start, message_in, message_len, final_hash_out, done);

// Port declarations
input clk, rst, start;
input [7:0] message_in;
input [63:0] message_len;
output reg [255:0] final_hash_out;
output reg done;

// State register
reg [2:0] state;

// Internal state registers
reg [1599:0] state_reg;
reg last_block_reg;

// Message handling
wire [54:0] num_blocks;
wire [1087:0] padded_msg;
wire ready_for_input;
wire [8:0] last_block_bits;
wire last_block;
wire tx_block;

// Control signals
reg pad_start;
reg absorb_start;
reg permute_start;
reg squeeze_start;

// Done signals
wire done_pad, done_absorb, done_permute, done_squeeze;

// Module outputs
wire [1599:0] state_out_absorb;
wire [1599:0] state_out_permute;
wire [255:0] hash_out;

// Parameters
parameter BEGIN = 3'd0,
          PAD = 3'd1,
          ABSORB = 3'd2,
          PERMUTE = 3'd3,
          SQUEEZE = 3'd4,
          DONE_STATE = 3'd5;

// Module instantiations

// Padding instance
message_padding pad_inst(
    .clk(clk),
    .start(pad_start),
    .rst(rst),
    .message_in(message_in),
    .message_len(message_len),
    .num_blocks(num_blocks),
    .last_block_bits(last_block_bits),
    .last_block(last_block),
    .tx_block(tx_block),
    .padded_msg(padded_msg),
    .done_msg(pad_done)
    
   
);

// Absorbing instance
absorb #(.RATE(1088)) absorb_inst(
    .clk(clk),
    .rst(rst),
    .start(absorb_start),
    .padded_message(padded_msg),
    .state_in(state_reg),
    .state_out(state_out_absorb),
    .done(done_absorb)
);

// Permute instance
permute permute_inst(
    .clk(clk),
    .rst(rst),
    .start(permute_start),
    .state_in(state_reg),
    .state_out(state_out_permute),
    .done(done_permute)
);

// Squeezing instance
squeeze squeeze_inst(
    .clk(clk),
    .rst(rst),
    .start(squeeze_start),    
    .state_out(state_reg),
    .hash_out(hash_out),
    .done(done_squeeze)
);

// Main FSM
always @(posedge clk) begin
    if (rst) begin
        state <= BEGIN;
        done <= 0;
        final_hash_out <= 256'd0;
        state_reg <= 1600'd0;
        pad_start <= 0;
        absorb_start <= 0;
        permute_start <= 0;
        squeeze_start <= 0;
        last_block_reg<=0;
    end
    else begin
        case (state)
            BEGIN: begin
                done <= 0;
                final_hash_out <= 256'd0;
                pad_start <= 0;
                absorb_start <= 0;
                permute_start <= 0;
                squeeze_start <= 0;
                last_block_reg<=0;
                
                if (start) begin
                    pad_start <= 1;
                    state <= PAD;
                    $display("FSM: BEGIN -> PAD");
                end
            end
            
            PAD: begin
                if (tx_block) begin
                    pad_start <= 0;
                    absorb_start <= 1;
                    state <= ABSORB;
                    $display("FSM: PAD -> ABSORB");
                end
            end
            
            ABSORB: begin
                if (done_absorb) begin
                    absorb_start <= 0;
                    state_reg <= state_out_absorb;  // Update state register
                    permute_start <= 1;
                    last_block_reg<=last_block;
                    state <= PERMUTE;
                    $display("FSM: ABSORB -> PERMUTE");
                end
            end
            
            PERMUTE: begin
                if (done_permute) begin
                    permute_start <= 0;
                    state_reg <= state_out_permute;  // Update state register
                    if(last_block_reg) begin
                    squeeze_start <= 1;
                    state <= SQUEEZE;
                   end 
                   else begin
                    pad_start<=1;
                   state<=PAD;
                    
                    $display("FSM: PERMUTE -> SQUEEZE");
                    end
                end
            end
            
            SQUEEZE: begin
                if (done_squeeze) begin
                    squeeze_start <= 0;
                    final_hash_out <= hash_out;
                    done <= 1;
                    state <= DONE_STATE;
                    $display("FSM: SQUEEZE -> DONE");
                end
            end
            
            DONE_STATE: begin
                // Stay in done state until reset or new start
                if (start) begin
                    done <= 0;
                    state <= BEGIN;
                end
            end
            
            default: begin
                state <= BEGIN;
            end
        endcase
    end
end

endmodule
