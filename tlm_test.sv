class tlm_test extends uvm_test;
  `uvm_component_utils(tlm_test)
  `NEW_COMP
  
  bit is_rc ;
  tlm_env env;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = tlm_env::type_id::create("env",this);
    uvm_config_db#(bit)::set(this,"env.rc_agent*","is_rc",1);
    uvm_config_db#(bit)::set(this,"env.ep_agent*","is_rc",0);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    
    mem_wr_seq  seq;
    seq = mem_wr_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.rc_agent.sqr);
    phase.phase_done.set_drain_time(this,200ns);
    phase.drop_objection(this);
  endtask
  
endclass