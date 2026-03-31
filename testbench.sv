`include "uvm_pkg.sv"
 import uvm_pkg::*;
`include "common.sv"
`include "tlm_interface.sv"
`include "tlm_tx.sv"
`include "tlm_seq.sv"
`include "tlm_sqr.sv"
`include "tlm_rc_driver.sv"
`include "tlm_ep_monitor.sv"
`include "tlm_scoreboard.sv"
`include "tlm_agent.sv"
`include "tlm_env.sv"
`include "tlm_test.sv"
   
   
 module top;
   
   bit clk;
   initial begin
     clk =0;
    forever #5 clk=~clk;
   end
   
   tlm_if vif(clk);
   
   initial begin
     
     uvm_config_db#(virtual tlm_if)::set(uvm_root::get(),"*","vif",vif);
     run_test("tlm_test");
   end

  
     
     assign vif.rc_rx_data = vif.ep_tx_data;
     assign vif.rc_rx_valid = vif.ep_tx_valid;
     assign vif.rc_rx_status =0;
     
     assign vif.ep_rx_data = vif.rc_tx_data;
     assign vif.ep_rx_valid = vif.rc_tx_valid;
     assign vif.ep_rx_status =0;
     assign vif.ep_rx_datak = vif.rc_tx_datak;
   
   initial begin
     $dumpfile("dump.vcd");
     $dumpvars;
   end
    
   initial begin
     #1000;
     $finish();
   end
 endmodule
