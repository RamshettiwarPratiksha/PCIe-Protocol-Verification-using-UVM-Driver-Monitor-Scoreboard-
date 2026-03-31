class tlm_tx extends uvm_sequence_item;
 
 rand bit [63:0] addr;
 rand bit [31:0] data[];
 rand bit [7:0] tag;
 rand bit [9:0] length;
 
 
  typedef enum{
    MEM_WR,
    MEM_RD,
    CPL
  }tlp_type_t;
  
  rand tlp_type_t tlp_type;
  
  `uvm_object_utils_begin(tlm_tx)
      `uvm_field_array_int(data,UVM_ALL_ON);
      `uvm_field_int(addr,UVM_ALL_ON);
      `uvm_field_int(tag,UVM_ALL_ON);
      `uvm_field_int(length,UVM_ALL_ON);
      `uvm_field_enum(tlp_type_t,tlp_type,UVM_ALL_ON);
  `uvm_object_utils_end
  `NEW_OBJ
  
  constraint addr_t{
    addr inside {[64'h8000_0000:64'h8000_0FFF]};
    {addr%4==0};
  }
   constraint length_t{
     length inside {[1:10]};
  }
   constraint data_t{
     if(tlp_type == MEM_WR || tlp_type ==CPL)
       data.size() == length;
     else data.size()==0;
  }
   constraint tag_t{
     tag inside {[1:100]};
  }
  
  function string to_string();

      string s;

    s = $sformatf("TLP[%s]\n Addr=%h\n Tag=%0d\n Len=%0d\n Data=",
                     tlp_type.name(), addr, tag, length);

      foreach (data[i])
        s = {s, $sformatf("%h ", data[i])};

      return s;

  endfunction
  
endclass