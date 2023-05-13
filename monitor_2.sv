class monitor_2 extends monitor;
  `uvm_component_utils(monitor_2)

  
  function new(input string inst = "monitor_2", uvm_component parent = null);
    super.new(inst,parent); 
    `uvm_info(get_type_name(), $sformatf("monitor_2"), UVM_LOW);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
   if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
 	 `uvm_error("MON", "Unable to access Interface");
    t = transaction::type_id::create("t"); 
endfunction  

    
 
virtual task run_phase(uvm_phase phase);
  fork
  	begin
    	forever begin
          @(negedge vsif.clk);
          if(vsif.vald_din) 
       		  t.data_in.push_back(vsif.data_in);  
        end
    end
      
    begin
       forever begin
          @(negedge vsif.clk);
         if(vsif.valid_out)            
          	t.data_out.push_back(vsif.data_out);
       end
    end
        begin
       forever begin
 		 @(posedge vsif.start_act)
          t.movavgwin_param=vsif.movavgwin_param; 
       end
    end
    
    begin
      forever begin
        @(negedge vsif.valid_out)
          `uvm_info("data_in",$sformatf("data in is:%p",t.data_in),UVM_LOW)
          `uvm_info("data_out",$sformatf("data out is:%p",t.data_out),UVM_LOW)
        	send.write(t);
            t.data_in.delete();
            t.data_out.delete();
      end  
    end   
  join       
 endtask
endclass
