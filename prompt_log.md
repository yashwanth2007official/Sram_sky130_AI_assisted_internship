# phase-1_1
## Understanding the concept and given example
[Role: Senior VLSI Architecture & Memory Compiler Expert]
Task: Analyze the structural layout of the repository 'ShonTaware/SRAM_SKY130'.
Deconstruct its compilation flow into a sequence of 5 distinct, executable research tasks 
suitable for an undergraduate engineering intern. Focus specifically on how the SkyWater 130nm PDK 
integrates with Python-driven OpenRAM configurations. Keep the output highly technical, dense, 
and strictly itemized.
# phase-1_2
## Configuring the tech.py layer mappings for OpenRAM to parse Sky130 GDS files.
[Role: Open-Source EDA Tool Automation Script]
Context: Porting the SkyWater 130nm process node to the OpenRAM Python framework.
Task: Generate a Codex-style python snippet for a 'tech.py' file that explicitly defines:
1. The interconnect metal stack up to Metal 4 (m1_stack, m2_stack, m3_stack).
2. Preferred routing directions where Metal 1 is Horizontal (H) and Metal 2 is Vertical (V).
3. The GDS layer mapping indices tuple for active diffusion, nwell, poly, licon, li, mcon, and m1.
Provide clean, uncommented Python declarations optimized for minimal token expenditure.
# phase-1_3
## Creating reproducible environment provisioning steps for Magic and Ngspice on Ubuntu.
[Role: DevOps Infrastructure Engineer for Microelectronics]
Task: Write an automated bash setup script template (.sh) that installs dependencies, clones, 
compiles, and registers the absolute execution paths for 'Magic' layout tool, 'Ngspice', 
and 'Xschem' on a clean Ubuntu LTS terminal. Include error checking flags (set -e) to halt execution 
if a tool compilation fails.
____
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
