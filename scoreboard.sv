`uvm_analysis_imp_decl(_no_ref)
`uvm_analysis_imp_decl(_with_ref)

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
 
  uvm_analysis_imp_no_ref #(transaction,scoreboard) no_ref;
  uvm_analysis_imp_with_ref #(transaction,scoreboard) with_ref;
 
  integer pixel_counter=0;
  integer pixel_value=0;
  integer j=0;
  int limit;
  logic [`DATAWIDTH-1:0] data_out_ref[$];
  integer counter=0;
  event finish;
  function new(input string inst = "SCO", uvm_component parent);
    super.new(inst,parent);
    
endfunction
  

 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
   no_ref = new("no_ref", this);
   with_ref = new("with_ref", this);
   if(!uvm_config_db#(int)::get(this,"","limit",limit))
     `uvm_error("DRV", "Unable to access Interface");
   `uvm_info("scoreboard",$sformatf("limit=%d",limit),UVM_LOW)
 endfunction
 
 virtual task run_phase(uvm_phase phase);   
  phase.raise_objection(this);
   @(finish);
   `uvm_info("scoreboard","finished",UVM_LOW)
   #500;
  phase.drop_objection(this);
  endtask
 
  virtual function void write_no_ref(transaction t);
    while(pixel_counter<t.data_in.size())
      begin
        if(pixel_counter<2**(t.movavgwin_param+1)-1)begin

             data_out_ref.push_back(0);         
        end
           else begin      
             pixel_value=0;
             for(int i=j; i<2**(t.movavgwin_param+1)+j; i++) begin
               pixel_value=(pixel_value+t.data_in[i]);
             end
             pixel_value=pixel_value/(2**(t.movavgwin_param+1));
             data_out_ref.push_back(pixel_value); 
             j++;           
            
           end 
        `uvm_info("data_out_ref",$sformatf("data_out_ref:%h",data_out_ref[0]),UVM_DEBUG)
        `uvm_info("data_out_real",$sformatf("data_out_real:%h",t.data_out[0]),UVM_DEBUG)
        if(t.data_out.pop_front()!=data_out_ref.pop_front())
             `uvm_error("CHECKER_phase_signals", "bad2");
        pixel_counter++; 
      end
    if((data_out_ref.size()!=0)||(t.data_out.size()!=0))
      `uvm_error("CHECKER_phase_signals", "bad3");
    data_out_ref.delete;
    pixel_counter=0;
    j=0;
    counter++;
    $display("counuter=%d",counter);
    if (counter==limit)
      ->finish;
       
                        
  endfunction
   
  virtual function void write_with_ref(transaction t);  
    //if we work with ref model, we would send the real data  here and the expected in       write_no_ref. and then, in one of them we would make the comparison
          
  endfunction
  
endclass
 
