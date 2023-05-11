class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
 
transaction t;
virtual s_if vsif;

 
  function new(input string inst = "driver", uvm_component parent = null);
    super.new(inst,parent);
    
    `uvm_info("DRV","drv_built",UVM_LOW)
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
     `uvm_error("DRV", "Unable to access Interface");
  endfunction
 
virtual task run_phase(uvm_phase phase);  
   #1000;  
  forever begin   
    @(posedge vsif.clk or negedge vsif.reset_n);
    if (!vsif.reset_n)
     begin
       vsif.start_act <= 0;
       vsif.movavg_en <= 0;
       vsif.vald_din<=0;
       vsif.data_in<=0;
	   vsif.movavgwin_param<=0;
    end
    else
    begin  
      vsif.movavg_en<=1;
      //handshake steps:4 (cycle will repeated again from here)
		  seq_item_port.get_next_item(t);
      @(posedge vsif.clk);
      vsif.movavgwin_param<=t.movavgwin_param;
   		vsif.start_act<=1;
      @(posedge vsif.clk);
    	vsif.start_act<=0;
    	vsif.vald_din<=1;
      repeat(t.valid_din_length) begin
        vsif.data_in<=t.data_in.pop_front(); 
        @(posedge vsif.clk);
     	end
      vsif.vald_din<=0;
		  @(posedge vsif.clk);
      @(posedge vsif.clk);
      seq_item_port.item_done();    
      end 
  end
   
endtask
 
endclass


