# Smoothing_measured_signal
A verification environment for a verilog block. This block inputs a noisy signal and outputs it as a clean signal. The cleaning quality depends on the window filter.
What special in this verification environment is that it continas 3 methods to check the output data:
1. on-the-fly: in the monitor itself.
2. in the scoreboard without reference model.
3. in the scorebord with reference model.
 * To choose between on-the-fly method and with scoreboard you just should change the test_type in the test.sv
 * Its also important to notice that over time, the inputs block values are changed every valid_din to get better coverage. 
 * I couldn't upload the design itsself due to copyright 
