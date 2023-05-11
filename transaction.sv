`include "pd_mavg_aex_includes.v"
class transaction extends uvm_sequence_item;
  rand logic [`PIXEL_WIDTH-1:0] valid_din_length;
  rand logic [`DATAWIDTH-1:0] data_in[$];
  rand logic [1:0]  movavgwin_param;
  logic [`DATAWIDTH-1:0] data_out[$];
  //transaction constraints.
  constraint x{  
    				  valid_din_length<100;
                      data_in.size()==valid_din_length;
    				  solve valid_din_length before data_in; 
              }
  
    
  function new(input string inst = "transaction");
  super.new(inst); 
  endfunction
    `uvm_object_utils_begin(transaction)// The utils macros define the infrastructure needed to enable the object/component for correct factory operation.
  `uvm_field_sarray_int(valid_din_length, UVM_ALL_ON)//The `uvm_field_* macros are invoked inside of the `uvm_*_utils_begin and `uvm_*_utils_end macro blocks to form “automatic” implementations of the core data methods: copy, compare, pack, unpack, record, print, and sprint.
  `uvm_field_sarray_int(data_in, UVM_ALL_ON)
  `uvm_field_sarray_int(movavgwin_param, UVM_ALL_ON)
  `uvm_object_utils_end
 

 
endclass
