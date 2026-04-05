`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

class tlm_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(tlm_scoreboard)
  `NEW_COMP
 
  tlm_tx exp_q[$];
  tlm_tx exp,act;
   
  
  uvm_analysis_imp_exp #(tlm_tx, tlm_scoreboard) exp_t;
  uvm_analysis_imp_act #(tlm_tx, tlm_scoreboard) act_t;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    exp_t = new("exp",this);
    act_t = new("act",this);
  endfunction
  
  
  function void write_exp(tlm_tx tx);
    `uvm_info("DRV->SCB",tx.to_string(),UVM_LOW);
      
    exp_q.push_back(tx);
  
  endfunction
   
  function void write_act(tlm_tx tx);
    `uvm_info("MON->SCB",tx.to_string(),UVM_LOW);
    exp = new();
    act = new();
    
    exp = exp_q.pop_front();
    act = tx;
    
    compare(exp,act);
  endfunction
    
  function void compare(tlm_tx exp,tlm_tx act);
  
    bit data_mismatch;
    
    if(exp.tlp_type == act.tlp_type)
      begin
        `uvm_info("SB",$sformatf("*****TLP TYPE MATCHED:%s*****",exp.tlp_type),UVM_LOW);
      end
    else 
      begin
        `uvm_info("SB",$sformatf("LENGHT MISMATCHED"),UVM_LOW);
      end     
    
    if(exp.tag == act.tag) 
      begin
        `uvm_info("SB",$sformatf("*****Tag MATCHED:%0d*****",exp.tag),UVM_LOW);
      end
    else 
      begin
        `uvm_info("SB",$sformatf("TAG MISMATCHED"),UVM_LOW);
      end
     
                   
    if(exp.length == act.length) 
      begin
        `uvm_info("SB",$sformatf("*****Length MATCHED:%0d*****",exp.length),UVM_LOW);
      end
    else 
      begin
        `uvm_info("SB",$sformatf("LENGHT MISMATCHED"),UVM_LOW);
      end      
    
    foreach(exp.data[i]) begin
      if(exp.data[i]==act.data[i]) begin
      end
      else begin
        data_mismatch = 1;
        `uvm_info("SB : DATA_MISMATCHED",$sformatf("data[%0d]=%0h",i,exp.data[i]),UVM_LOW);
      end
    end
    
    if(!data_mismatch);
    $display("******TLP data matched**********");
    
    
    
  endfunction
    
endclass