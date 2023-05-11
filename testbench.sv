`include "uvm_macros.svh"
 import uvm_pkg::*;
`include "s_if.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "monitor_2.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "ref_model.sv"
`include "env.sv"
`include "test.sv"

module testbench;
//instantiate interface  
  s_if sif();
// connect interface to the design  
  movavg_fltr mavg(
    .clk(sif.clk),
    .reset_n(sif.reset_n),
    .start_act(sif.start_act),
    .movavg_en(sif.movavg_en),
    .vald_din(sif.vald_din),
    .data_in(sif.data_in),
    .movavgwin_param(sif.movavgwin_param),
    .data_out(sif.data_out),
    .valid_out(sif.valid_out)
  );
 
  
  //instantiate main clock and disable reset_n
  initial begin 
    sif.clk=0;
    sif.reset_n=0;
    #50;
    sif.reset_n=1;    
  end
//dump the changes in the values of nets and registers  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
   //create the main clock  
  always#5 sif.clk= ~sif.clk;
  //send values path to uvm configuration data base (virtual interface and factory in this case)
  initial begin
    uvm_factory factory = uvm_factory::get();
    uvm_config_db #(virtual s_if) :: set(null, "*", "vsif", sif);
    uvm_config_db #(uvm_factory) :: set(null, "*", "factory", factory);
    //casting "test" to "uvm_test_top" varaiable. "uvm_test_top" is the top hierarchy of our uvm testbench.
    run_test("test");
    //we can't keep writing code after run_test in the block becuase $finish is called inside for simulator exit.
  end
 


  
endmodule
