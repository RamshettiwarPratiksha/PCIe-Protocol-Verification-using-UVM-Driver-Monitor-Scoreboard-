class tlm_env extends uvm_env;

  `uvm_component_utils(tlm_env)
  `NEW_COMP

  tlm_agent rc_agent;
  tlm_agent ep_agent;
  tlm_scoreboard sb;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    rc_agent = tlm_agent::type_id::create("rc_agent", this);
    ep_agent = tlm_agent::type_id::create("ep_agent", this);
    sb = tlm_scoreboard::type_id::create("sb",this);
  endfunction

   
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase); 
    rc_agent.drv.ap.connect(sb.exp_t);
    ep_agent.mon.ap.connect(sb.act_t);
  endfunction
  
endclass