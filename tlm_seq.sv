class base_seq extends uvm_sequence#(tlm_tx);
  `uvm_object_utils(base_seq)
  `NEW_OBJ
  
  tlm_tx req;
  
  task body();
    repeat(2) begin
      `uvm_do(req); 
    end
  endtask
endclass


class mem_wr_rd_seq extends base_seq;
  `uvm_object_utils(mem_wr_rd_seq)
  `NEW_OBJ
  
  tlm_tx tx_q[$],wr,rd;
  
  task body();
    repeat(2) begin
      `uvm_do_with(wr,{tlp_type == MEM_WR;});
      tx_q.push_back(wr);
     
    end

    repeat(2) begin     
      wr = tx_q.pop_front();
      `uvm_do_with(rd,{tlp_type == MEM_RD; addr == wr.addr;tag == wr.tag;});
     
    end
    
  endtask
  
  
endclass


class mem_wr_seq extends base_seq;
  `uvm_object_utils(mem_wr_seq)
  `NEW_OBJ
  task body();
    repeat(2) begin
      `uvm_do_with(req,{tlp_type == MEM_WR;}); 
    end
  endtask
endclass