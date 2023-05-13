class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
uvm_analysis_port #(transaction) send;// Broadcasts a value to all subscribers implementing a uvm_analysis_imp.
virtual s_if vsif;
transaction t;
integer pixel_counter=0;
integer pixel_value=0;
integer j;


 
  function new(input string inst = "monitor", uvm_component parent = null);
    super.new(inst,parent); 
    send = new("send",this);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
    		t = transaction::type_id::create("t");
  	if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
  		`uvm_error("MON", "Unable to access Interface");
  endfunction
 
virtual task run_phase(uvm_phase phase);

    fork
      begin
        forever begin
          @(posedge vsif.start_act)
          t.movavgwin_param=vsif.movavgwin_param; 
          `uvm_info("movavg_param",$sformatf("param is:%p",t.movavgwin_param),UVM_LOW)
        end
      end
      
      begin
        forever begin
          @(negedge vsif.clk);
          if(vsif.vald_din) 
        	t.data_in.push_back(vsif.data_in);                                
        end
      end
       begin
         forever begin
		@(negedge vsif.vald_din);
      		//`uvm_info("data_in",$sformatf("data in is:%p",t.data_in),UVM_LOW)
         end
      end
          
   
      begin
       forever begin        
         @(negedge vsif.clk);
         //checker on the fly:comparing the t.data_out ,that created in the monitor,  to the data_out interface values immediatly, without scoreboard.
         if(vsif.valid_out) begin
           if(pixel_counter<2**(t.movavgwin_param+1)-1)begin
             t.data_out.push_back(0);
           end           
           else begin      
             pixel_value=0;
             for(int i=j; i<2**(t.movavgwin_param+1)+j; i++) begin
               pixel_value=(pixel_value+t.data_in[i]);
             end
             pixel_value=pixel_value/(2**(t.movavgwin_param+1));
             t.data_out.push_back(pixel_value); 
             j++;           
            
           end 
           `uvm_info("pix",$sformatf("pixel_counter_is:%d",pixel_counter),UVM_DEBUG)
           `uvm_info("data_out_mid",$sformatf("data_out_mid:%p",t.data_out),UVM_DEBUG)
           `uvm_info("vsif.data_out",$sformatf("vsif.data_out_mid:%p",vsif.data_out),UVM_DEBUG)
           if(t.data_out[pixel_counter]!=vsif.data_out)
		   `uvm_error("CHECKER_phase_signals", "output_error");
            pixel_counter++; 
	 end
       end        
      end
        begin
         forever begin
           @(negedge vsif.valid_out);           
           //`uvm_info("data_out",$sformatf("data out is:%p",t.data_out),UVM_LOW)
            pixel_counter=0;
            t.data_out.delete();
            t.data_in.delete();
            j=0;
         end
      end     
    join
    
  endtask
endclass
