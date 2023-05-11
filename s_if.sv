interface s_if;
  
logic clk;  
logic reset_n;
logic start_act;
logic  movavg_en;
logic vald_din;
logic [11:0] data_in;
logic [1:0]  movavgwin_param; 
logic [11:0] data_out;
logic valid_out;    

//an assertion that checks that valid_out is the same as vald_din after 2 clock cycles.
property check;
  @(posedge clk) 
  (!($isunknown($past(vald_din,2)))) |-> ($past(vald_din,2)==valid_out);
endproperty
  
  assert property (check) 
  else 
    `uvm_error("CHECKER_phase_signals", "valid_out_error");

  
endinterface
