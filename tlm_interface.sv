interface tlm_if (input logic clk);

  // =============================
  // RC → EP
  // =============================
  logic [31:0] rc_tx_data;
  logic        rc_tx_valid;
  logic   rc_tx_datak;
  
  logic [31:0] rc_rx_data;
  logic        rc_rx_valid;
  logic [2:0]  rc_rx_status;
  logic rc_rx_datak;



  logic [31:0] ep_rx_data;
  logic        ep_rx_valid;
  logic [2:0]  ep_rx_status;
  logic ep_rx_datak;
  
  logic [31:0] ep_tx_data;
  logic        ep_tx_valid;
  logic ep_tx_datak;
  


 bit init;
  // =============================
  // CONTROL
  // =============================
  logic [1:0]  pipe_rate;
  logic        pipe_phystatus;

  // =============================
  // LTSSM
  // =============================
  typedef enum logic [1:0] {
    DETECT,
    POLLING,
    CONFIG,
    L0
  } link_state_e;

  link_state_e link_state;

  
  // =============================
  // LTSSM FSM
  // =============================
  always_ff @(posedge clk) begin
    if (!init) begin
    link_state <= DETECT;
      init = 1;
    end
    else begin
      case (link_state)

      DETECT: begin
        if (rc_tx_valid || ep_tx_valid)
          link_state <= POLLING;
      end

      POLLING: begin
        if ((rc_tx_datak != 0 && rc_tx_data == 32'h545331) ||
            (ep_tx_datak != 0 && ep_tx_data == 32'h545331))
          link_state <= CONFIG;
      end

      CONFIG: begin
        if ((rc_tx_datak != 0 && rc_tx_data == 32'h545332) ||
            (ep_tx_datak != 0 && ep_tx_data == 32'h545332))
          link_state <= L0;
      end

      L0: begin
        link_state <= L0;
      end

    endcase
    end
  end

endinterface