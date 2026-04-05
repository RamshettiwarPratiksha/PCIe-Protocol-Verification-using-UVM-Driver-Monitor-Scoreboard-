class tlm_agent extends uvm_agent;
  `uvm_component_utils(tlm_agent)
  `NEW_COMP
   bit is_rc;
  tlm_sqr sqr;
  rc_driver drv;
  ep_monitor mon;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
   if (!uvm_config_db#(bit)::get(this,"", "is_rc", is_rc))
    `uvm_fatal("AGENT", "is_rc not set")
     
     if(is_rc) begin 
      sqr = tlm_sqr::type_id::create("sqr",this);
      drv = rc_driver::type_id::create("drv",this);
     end 
    else 
      mon = ep_monitor::type_id::create("mon",this);
    
    
  endfunction
  
 // drv.is_rc = is_rc;
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_rc)
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass