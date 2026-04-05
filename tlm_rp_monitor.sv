class ep_monitor extends uvm_monitor;

  `uvm_component_utils(ep_monitor)
  `NEW_COMP

  virtual tlm_if vif;
  uvm_analysis_port #(tlm_tx) ap;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual tlm_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "No vif")

    ap = new("ap", this);
  endfunction


  task run_phase(uvm_phase phase);
    
    

    tlm_tx tx;
    int data_count;
    
    forever begin
      @(posedge vif.clk);

     
      // STP DETECT
     
      if (vif.ep_rx_valid &&
          vif.ep_rx_datak == 1 &&
          vif.ep_rx_data  == `STP) begin

        // $display("***********ENTERED MON RUN PHASE*******");
        `uvm_info("MON", "STP detected", UVM_LOW)

        
        tx = tlm_tx::type_id::create("tx");
        
      // HEADER
     
        @(posedge vif.clk);
        if (vif.ep_rx_datak != 0)
          `uvm_error("MON", "Header should not be control symbol")

        tx.tlp_type = vif.ep_rx_data[31:29];
        tx.length   = vif.ep_rx_data[9:0];

        if (tx.length == 0)
          `uvm_error("MON", "Invalid length = 0")

        @(posedge vif.clk);

        // ADDR
       
        if (vif.ep_rx_datak != 0)
          `uvm_error("MON", "ADDR corrupted (control detected)")

        tx.addr = vif.ep_rx_data;

        @(posedge vif.clk);

       
        // TAG
        
        if (vif.ep_rx_datak != 0)
          `uvm_error("MON", "TAG corrupted (control detected)")

          tx.tag = vif.ep_rx_data[31:24];

        
        // DATA
        
        if (tx.tlp_type == tlm_tx::MEM_WR) begin

          tx.data = new[tx.length];
          data_count = 0;

          for (int i = 0; i < tx.length; i++) begin
            @(posedge vif.clk);

           
            if (vif.ep_rx_datak == 1) begin
              `uvm_error("MON", "Control symbol inside DATA")

             
              if (vif.ep_rx_data == `END) begin
                `uvm_error("MON", "Early END detected")
                break;
              end
            end

            tx.data[i] = vif.ep_rx_data;
            data_count++;
          end

          ap.write(tx);
          if (data_count != tx.length)
            `uvm_error("MON", $sformatf("DATA count mismatch exp=%0d got=%0d",
                                        tx.length, data_count));
        end

        // -------------------------
        // END CHECK
        // -------------------------
        @(posedge vif.clk);

        if (vif.ep_rx_datak == 1 &&
            vif.ep_rx_data  == `END) begin

          `uvm_info("MON", "END detected", UVM_LOW)
          `uvm_info("MON",tx.to_string(),UVM_LOW);
         
          

        end 
         else begin
          `uvm_error("MON", "Missing END")
        end

      end // STP

    end // forever

  endtask

endclass