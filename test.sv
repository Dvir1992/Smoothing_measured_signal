class test extends uvm_test;
  
  `uvm_component_utils(test) //The utils macros define the infrastructure needed to enable the object/component for correct factory operation.
  env e;
  generator gen;
  bit [1:0] test_type;
  function new(string inst="test", uvm_component parent = null);// we must enter the parent to create the testbench hirarchy
    super.new(inst,parent);//get the uvm_test characteristics
    `uvm_info("TEST","test_built",UVM_LOW)
  endfunction
  
 
 
  virtual function void build_phase(uvm_phase phase);// we use virtual methods becuase if the base class and the extended class have the same method name and the base class handle is pointing on the extended class, we would like to get the method from the extended class.
  super.build_phase(phase);
    e = env::type_id::create("e",this);
    gen = generator::type_id::create("gen",this);
    gen.limit=20;//num of sequence items we want to send to the driver.
    test_type=1;// determine the way of monitor and check the output data.
    //
    uvm_config_db #(bit [1:0]) :: set(null, "*", "test_type", test_type);
    uvm_config_db #(int) :: set(null, "*", "limit", gen.limit);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
   //test can't be finished until objection is dropped.
  phase.raise_objection(this);
   //start the sequence -sequencer-driver handshake
  gen.start(e.a.seqr);
  #1000;  
  phase.drop_objection(this);
  endtask
endclass
 
  
