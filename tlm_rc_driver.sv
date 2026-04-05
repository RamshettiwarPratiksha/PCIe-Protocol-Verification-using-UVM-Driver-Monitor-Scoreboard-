class rc_driver extends uvm_driver #(tlm_tx);

   `uvm_component_utils(rc_driver)
  uvm_analysis_port #(tlm_tx) ap;
   `NEW_COMP
  virtual tlm_if vif;

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual tlm_if)::get(this,"","vif",vif))
      `uvm_fatal("DRV","No vif");
    ap = new("ap",this);
  endfunction

  task run_phase(uvm_phase phase);

        tlm_tx req;

        forever begin
         
          seq_item_port.get_next_item(req);
         `uvm_info("DRV",req.to_string(),UVM_LOW)
           
          ap.write(req) ; ////////
          train_link_if_needed();
          drive_tlp(req);

          seq_item_port.item_done();
    end

  endtask
  
  
  task train_link_if_needed();

  // already up → skip
  if (vif.link_state == vif.L0)
    return;

  `uvm_info("RC_DRV", "Starting link training", UVM_LOW)

  // -------------------------
  // TS1 (Polling)
  // -------------------------
  repeat (4) begin
    @(posedge vif.clk);
    vif.rc_tx_valid <= 1;
    vif.rc_tx_datak <= 1;
    vif.rc_tx_data  <= 32'h545331; // "TS1"
    $display("Polling started");
  end
    $display("Polling Done");
  // -------------------------
  // TS2 (Config)
  // -------------------------
  repeat (4) begin
    @(posedge vif.clk);
    vif.rc_tx_valid <= 1;
    vif.rc_tx_datak <= 1;
    vif.rc_tx_data  <= 32'h545332; // "TS2"
    $display("Config started");
  end
    $display("Config Done");
  // -------------------------
  // Stop training
  // -------------------------
  @(posedge vif.clk);
  vif.rc_tx_valid <= 0;
  vif.rc_tx_datak <= 0;
  #1;
  $display("Before wait to L0");
  // wait for L0
    wait (vif.link_state == vif.L0);

  `uvm_info("RC_DRV", "Link is UP (L0)", UVM_LOW)

endtask
  
  
  task drive_tlp(tlm_tx t);

  @(posedge vif.clk);
  vif.rc_tx_valid <= 1;
  vif.rc_tx_datak <= 1;
  vif.rc_tx_data  <= `STP;

  @(posedge vif.clk);
  vif.rc_tx_datak <= 0;
  vif.rc_tx_data  <= {t.tlp_type,6'd0,t.length};

  @(posedge vif.clk); vif.rc_tx_data <= t.addr;
  @(posedge vif.clk); vif.rc_tx_data <= {t.tag,24'd0};

 // if (t.tlp_type != MEM_RD) begin
    foreach(t.data[i]) begin
      @(posedge vif.clk);
      vif.rc_tx_data <= t.data[i];
    end
 // end

  @(posedge vif.clk);
  vif.rc_tx_datak <= 1;
  vif.rc_tx_data  <= `END;

  @(posedge vif.clk);
  vif.rc_tx_valid <= 0;

  endtask
endclass 