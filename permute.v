module permute (
  input clk,
  input rst,
  input start,
  input [1599:0] state_in,
  output reg [1599:0] state_out,
  output reg done
);

  // FSM states
  parameter BEGIN      = 4'd0,
            THETA      = 4'd1,
            RHO        = 4'd2,
            PI         = 4'd3,
            CHI        = 4'd4,
            IOTA       = 4'd5,
            WAIT_OUT   = 4'd6;

  reg [3:0] current_state;
  reg [4:0] round;

  // Stage handshake control
  reg theta_start, rho_start, pi_start, chi_start, iota_start;
  wire theta_done, rho_done, pi_done, chi_done, iota_done;

  // Stage outputs
  reg [1599:0] theta_in, rho_in, pi_in, chi_in, iota_in;
  wire [1599:0] theta_transform, rho_transform, pi_transform, chi_transform, iota_transform;

  // Instantiate sub-rounds
  theta_round theta_inst(.clk(clk), .rst(rst), .start(theta_start), .state_in(theta_in), .done(theta_done), .theta_transform(theta_transform));
  rho_round   rho_inst  (.clk(clk), .rst(rst), .start(rho_start),   .state(rho_in),        .done(rho_done),   .rho_transform(rho_transform));
  pi_round    pi_inst   (.clk(clk), .rst(rst), .start(pi_start),    .state(pi_in),         .done(pi_done),    .pi_transform(pi_transform));
  chi_round   chi_inst  (.clk(clk), .rst(rst), .start(chi_start),   .state(chi_in),        .done(chi_done),   .chi_transform(chi_transform));
  iota_round  iota_inst (.clk(clk), .rst(rst), .start(iota_start),  .round(round),         .state(iota_in),   .done(iota_done), .iota_transform(iota_transform));

  always @(posedge clk) begin
    if (rst) begin
      state_out <= 1600'd0;
      done <= 0;
      round <= 0;
      current_state <= BEGIN;
      theta_start <= 0; rho_start <= 0; pi_start <= 0; chi_start <= 0; iota_start <= 0;
      theta_in <= 0; rho_in <= 0; pi_in <= 0; chi_in <= 0; iota_in <= 0;
    end
    else begin
      // Default: keep start signals low unless triggered
      theta_start <= 0;
      rho_start   <= 0;
      pi_start    <= 0;
      chi_start   <= 0;
      iota_start  <= 0;
      done        <= 0;  // default low, will pulse when complete

      case (current_state)
        BEGIN: begin
          if (start) begin
            theta_in <= state_in;
            theta_start <= 1;  // start theta
            round <= 0;
            current_state <= THETA;
          end
        end

        THETA: begin
          if (!theta_done) begin
            theta_start <= 1; // keep asserted until done
          end
          else begin
            rho_in <= theta_transform;
            rho_start <= 1;
            current_state <= RHO;
          end
        end

        RHO: begin
          if (!rho_done) begin
            rho_start <= 1;
          end
          else begin
            pi_in <= rho_transform;
            pi_start <= 1;
            current_state <= PI;
          end
        end

        PI: begin
          if (!pi_done) begin
            pi_start <= 1;
          end
          else begin
            chi_in <= pi_transform;
            chi_start <= 1;
            current_state <= CHI;
          end
        end

        CHI: begin
          if (!chi_done) begin
            chi_start <= 1;
          end
          else begin
            iota_in <= chi_transform;
            iota_start <= 1;
            current_state <= IOTA;
          end
        end

        IOTA: begin
          if (!iota_done) begin
            iota_start <= 1;
          end
          else begin
            if (round == 23) begin
              state_out <= iota_transform;
              done <= 1; // pulse for 1 cycle
              current_state <= WAIT_OUT;
            end
            else begin
              theta_in <= iota_transform;
              theta_start <= 1;
              round <= round + 1;
              current_state <= THETA;
            end
          end
        end

        WAIT_OUT: begin
          if (!start) begin // wait until next block request
            current_state <= BEGIN;
          end
        end

        default: current_state <= BEGIN;
      endcase
    end
  end
endmodule
