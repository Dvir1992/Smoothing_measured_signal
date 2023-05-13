class env extends uvm_env;
`uvm_component_utils(env)
 
  function new(string inst = "e", uvm_component parent = null);
    super.new(inst,parent);
  endfunction
 
  scoreboard s;
  agent a;
  ref_model rm;
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    `uvm_info("ENV","env_built",UVM_LOW)
    a = agent::type_id::create("a",this);
    s = scoreboard::type_id::create("s",this);
    rm =ref_model::type_id::create("rm",this);
  endfunction
 

  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    `uvm_info("ENV",$sformatf("type_is:%s",a.m.get_type_name()),UVM_LOW)
    a.m.send.connect(s.no_ref);
    rm.send_2.connect(s.with_ref);
  endfunction

endclass
