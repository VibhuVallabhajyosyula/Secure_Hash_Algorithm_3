module message_padding #(parameter RATE = 1088, parameter CAPACITY = 512)(
    input clk,  
    input start,
    input rst,
    input [7:0] message_in,
    input [63:0] message_len,  // in bits
    output [54:0] num_blocks,
    output [8:0] last_block_bits,
    output reg tx_block,
    output reg last_block,
    output reg done_msg,
    output reg [RATE-1:0] padded_msg
);
    parameter CHECK    = 3'b000;
    parameter STREAM   = 3'b001;
    parameter PAD_2    = 3'b010;
    parameter DONE     = 3'b011;

    parameter Pad_msg  = 3'b000;
    parameter Pad_zero = 3'b001;
    parameter Pad_last = 3'b010;
    parameter Pad_new_block = 3'b011;  // for handling 1080  and multiples case

    reg [2:0] state, state_pad;
    reg [RATE-1:0] temp_msg;
    reg [10:0] count_msg;
    reg [54:0] block_counter;
    reg [63:0] bits_processed;

    assign num_blocks = (message_len + 16 + RATE - 1) / RATE; 
    assign last_block_bits = message_len % RATE;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= CHECK;
            temp_msg <= 0;
            padded_msg <= 0;
            tx_block <= 0;
            last_block <= 0;
            done_msg <= 0;
            count_msg <= 0;
            block_counter <= 0;
            state_pad <= Pad_msg;
            bits_processed <= 0;
        end else begin
            tx_block <= 0;
            last_block <= 0;

            case (state)
                CHECK: begin
                    if (start) begin
                        count_msg <= 0;
                        temp_msg <= 0;
                        bits_processed <= 0;
                        block_counter <= 0;

                        if (message_len % RATE == 0) begin
                            state_pad <= Pad_last;
                            state <= STREAM;
                        end else if (message_len <= RATE - 16) begin
                            state_pad <= Pad_msg;
                            state <= PAD_2;
                        end else begin
                            state_pad <= Pad_msg;
                            state <= STREAM;
                        end
                    end
                end

                STREAM: begin 
                    if (bits_processed < message_len && count_msg + 8 <= RATE) begin
                        temp_msg[count_msg +: 8] <= message_in;
                        count_msg <= count_msg + 8;
                        bits_processed <= bits_processed + 8;

                        if (count_msg + 8 == RATE) begin
                            padded_msg<={message_in,temp_msg[RATE-1-8:0]};
                            tx_block <= 1;
                            block_counter <= block_counter + 1;
                            count_msg <= 0;
                            temp_msg <= 0;

                            // Padding decision
                            if (bits_processed >= message_len) begin
                                if (message_len % RATE == 0) begin
                                    state_pad <= Pad_last;
                                    state <= PAD_2;
                                end else begin
                                    state_pad <= Pad_msg;
                                    state <= PAD_2;
                                end
                            end
                        end
                    end else if (bits_processed >= message_len) begin
                        state <= PAD_2;
                    end
                end

                PAD_2: begin
                    case (state_pad)
                        Pad_msg: begin
                            
                            if (count_msg <= RATE - 16) begin
                                
                                temp_msg[count_msg +: 8] <= 8'h06;
                                count_msg <= count_msg + 8;
                                state_pad <= Pad_zero;
                            end else if (count_msg == RATE - 8) begin
                                
                                temp_msg[count_msg +: 8] <= 8'h06;
                                padded_msg <= {8'h06, temp_msg[RATE-8-1:0]};
                                tx_block <= 1;
                                block_counter <= block_counter + 1;
                                count_msg <= 0;
                                temp_msg <= 0;
                                state_pad <= Pad_new_block;
                            end else begin
                                
                                state <= DONE;
                            end
                        end

                        Pad_zero: begin
                            if (count_msg < RATE - 8) begin
                                temp_msg[count_msg +: 8] <= 8'h00;
                                count_msg <= count_msg + 8;
                            end else begin
                                temp_msg[RATE-8 +: 8] <= 8'h80;
                                padded_msg <= {8'h80,temp_msg[RATE-8-1:0]};
                                tx_block <= 1;
                                last_block <= 1;
                                done_msg <= 1;
                                state <= DONE;
                            end
                        end

                        Pad_new_block: begin
                            
                            temp_msg <= {8'h80, {(RATE-8){1'b0}}};
                            padded_msg <= {8'h80, {(RATE-8){1'b0}}};
                            tx_block <= 1;
                            last_block <= 1;
                            done_msg <= 1;
                            state <= DONE;
                        end

                        Pad_last: begin
                            temp_msg[7:0] <= 8'h06;
                            temp_msg[RATE-8 +: 8] <= 8'h80;
                            temp_msg[RATE-9:8] <= {(RATE-16){1'b0}};
                            padded_msg <= {8'h80,{(RATE-16){1'b0}},8'h06};
                            tx_block <= 1;
                            last_block <= 1;
                            done_msg <= 1;
                            state <= DONE;
                        end
                    endcase
                end

                DONE: begin
                    
                end

                default: state <= CHECK;
            endcase
        end
    end
endmodule
