`define NEW_COMP \
function new(string name, uvm_component parent);\
  super.new(name,parent);\
endfunction

`define NEW_OBJ \
function new(string name = "");\
  super.new(name);\
endfunction

`define STP 32'h1111_1111
`define END 32'h2222_2222