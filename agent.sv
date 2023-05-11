class agent extends uvm_agent;
`uvm_component_utils(agent)
 
 
  function new(string inst = "agent", uvm_component parent = null);
    super.new(inst,parent);
    `uvm_info("AGENT","agent_built",UVM_LOW)
  endfunction
 
  monitor m;
  driver d;
  uvm_sequencer #(transaction) seqr;
  uvm_factory factory;
  bit [1:0] test_type;
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    if(!uvm_config_db#( uvm_factory)::get(this,"","factory",factory))
      `uvm_error("AGN", "Unable to access factroy");
    if(!uvm_config_db#(bit[1:0])::get(this,"","test_type",test_type))
      `uvm_error("AGN", "Unable to access test_type");
    if(test_type==1)
      set_inst_override_by_type("*",monitor::get_type(), monitor_2::get_type()); //in this test type we choose to work on monitor_2
    m = monitor::type_id::create("m",this);
    d = driver::type_id::create("d",this);
    seqr = uvm_sequencer #(transaction)::type_id::create("seqr",this);      
    factory.print();
 
  endfunction
 
  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
  


