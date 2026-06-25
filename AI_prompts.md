## phase-2_1
### Generating the SPICE decks for your Static Noise Margin (SNM) analysis
[Role: VLSI Analog Automation Expert]
Context: SkyWater 130nm PDK (1.8V operation).
Task: Write an Ngspice simulation netlist to measure the Read Static Noise Margin (RSNM) of a 6T SRAM cell. 
Include:
1. Subcircuit definition for sky130 nfet and pfet models.
2. Wordline (WL) connected to 1.8V, BL and BL_bar tied to 1.8V (Read condition).
3. Two independent DC voltage sweeps inserted into the cross-coupled nodes to generate the VTC curves.
4. An .control block that plots the regular and flipped VTCs to create a Butterfly Curve.
## phase-2_2
### Sense Amp Validation
[Role: SPICE Simulation Engineer]
Task: Generate a transient verification deck in Ngspice for a latch-based differential sense amplifier using sky130 primitives. 
Setup: Force an initial voltage difference of BL = 1.8V and BL_bar = 1.7V. Apply a pulsed clock to the Sense Amp Enable (SA_EN) pin at t = 1ns. 
Output: Simulate for 5ns and plot SA_OUT and SA_OUT_bar to verify full-swing rail-to-rail amplification.
