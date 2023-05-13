class ref_model extends uvm_component;
	
  `uvm_component_utils(ref_model)
  uvm_analysis_port #(transaction) send_2;
  virtual s_if vsif;  
  integer j;
  integer pixel_value;
  integer pixel_counter;
  transaction t;
  function new(input string inst = "ref_model", uvm_component parent = null);
    super.new(inst,parent); 
    `uvm_info(get_type_name(), $sformatf("ref_model"), UVM_LOW);
    send_2 = new("send_2",this);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);    
    if(!uvm_config_db#(virtual s_if)::get(this,"","vsif",vsif))
      `uvm_error("RM", "Unable to access Interface");
    t = transaction::type_id::create("t");
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
      	        // `uvm_info("data_in",$sformatf("data in is:%p",t.data_in),UVM_LOW)
         end
      end
          
   
      begin
       forever begin        
         @(negedge vsif.clk);
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
            pixel_counter++; 
         end
       end        
      end
        begin
         forever begin
           @(negedge vsif.valid_out);           
           //`uvm_info("data_out",$sformatf("data out is:%p",t.data_out),UVM_LOW)
           send_2.write(t);
           pixel_counter=0;
           t.data_out.delete();
           t.data_in.delete();
           j=0;
         end
      end                 
    join     
 endtask  
endclass
