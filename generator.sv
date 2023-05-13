class generator extends uvm_sequence#(transaction);// when we use #(transcation), "req" handle is instansiated with type transaction in uvm_sequence.
`uvm_object_utils(generator)
int limit;
 
 
  function new(string inst = "generator");
   super.new(inst);
  endfunction

 
virtual task body();
  #1000;  
  for (int i=0; i<limit; i++) begin
    req = transaction::type_id::create("TRANS");
    start_item(req);
    req.randomize();
    //wait for item in driver to be done.
    finish_item(req);
    //after driver finish to work on the item
   end
endtask
    
endclass

