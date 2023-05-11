# Smoothing_measured_signal
A verification environment for a verilog block. This block inputs a noisy signal and outputs it as a clean signal. The cleaning quality depends on the window filter.
What special in this verification environment is thats there are 3 methods to check the oputput data:
1. on-the-fly: in the monitor it self.
2. in the scoreboard without refmodel.
3. in the scorebord with refmodel.
