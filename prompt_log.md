# week-1
## phase-1_1
### Understanding the concept and given example
[Role: Senior VLSI Architecture & Memory Compiler Expert]  
Task: Analyze the structural layout of the repository 'ShonTaware/SRAM_SKY130'.
Deconstruct its compilation flow into a sequence of 5 distinct, executable research tasks 
suitable for an undergraduate engineering intern. Focus specifically on how the SkyWater 130nm PDK 
integrates with Python-driven OpenRAM configurations. Keep the output highly technical, dense, 
and strictly itemized.  
## phase-1_2
### Configuring the tech.py layer mappings for OpenRAM to parse Sky130 GDS files.
[Role: Open-Source EDA Tool Automation Script]  
Context: Porting the SkyWater 130nm process node to the OpenRAM Python framework.  
Task: Generate a Codex-style python snippet for a 'tech.py' file that explicitly defines:  
1. The interconnect metal stack up to Metal 4 (m1_stack, m2_stack, m3_stack).  
2. Preferred routing directions where Metal 1 is Horizontal (H) and Metal 2 is Vertical (V).  
3. The GDS layer mapping indices tuple for active diffusion, nwell, poly, licon, li, mcon, and m1.  
Provide clean, uncommented Python declarations optimized for minimal token expenditure.  
## phase-1_3
### Creating reproducible environment provisioning steps for Magic and Ngspice on Ubuntu.
[Role: DevOps Infrastructure Engineer for Microelectronics]  
Task: Write an automated bash setup script template (.sh) that installs dependencies, clones, 
compiles, and registers the absolute execution paths for 'Magic' layout tool, 'Ngspice', 
and 'Xschem' on a clean Ubuntu LTS terminal. Include error checking flags (set -e) to halt execution 
if a tool compilation fails.  
____
# week-2&3
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

 ### 6T SRAM Bitcell & Static Noise Margin (RSNM) Analysis
* **Implementation:** Built using actual SkyWater 130nm library models (`sky130.lib.spice` at Typical-Typical corner) running under `ngspice` HSPICE compatibility mode (`set ngbehavior=hsa`).  
* **Sizing Configuration:** Driver transistors sized at $W=0.84\mu\text{m}$, access transistors at $W=0.42\mu\text{m}$, and pull-up devices at $W=0.42\mu\text{m}$ to satisfy critical Cell Ratio ($CR=2$) layout constraints.  
* **Observation:** The generated butterfly curve captures real silicon phenomena, explicitly mapping out the $0.15\text{V}$ Read Disturb bounce where the bitline column leaks charge into the storage node during an active read cycle.  
###  Pre-charge Network & Parasitic Array Modeling
* **Implementation:** Designed a 3-PMOS equalization topology loaded with $100\text{ fF}$ lumped column capacitors to simulate a realistic bitline array matrix.  
* **Optimization:** Upscaled pull-up device widths to $W=4.0\mu\text{m}$ to overcome real channel resistance parameters, ensuring full $1.8\text{V}$ rail saturation within the strict $1.0\text{ns}$ pre-charge clock phase.

## phase-2_2
### Sense Amp Validation
[Role: SPICE Simulation Engineer]
Task: Generate a transient verification deck in Ngspice for a latch-based differential sense amplifier using sky130 primitives. 
Setup: Force an initial voltage difference of BL = 1.8V and BL_bar = 1.7V. Apply a pulsed clock to the Sense Amp Enable (SA_EN) pin at t = 1ns. 
Output: Simulate for 5ns and plot SA_OUT and SA_OUT_bar to verify full-swing rail-to-rail amplification.


### Series-Gated Write Driver & Timing Extraction
* **Implementation:** Constructed an AND-logic series pull-down tree configuration to actively prevent floating state noise during non-write operations.  
* **Quantitative Extraction:** Integrated automated `.measure` commands to extract precise performance metrics directly from the simulation engine solver matrix.  
* **Results:** Measured an exact mathematical Write Access Delay of **265.79 picoseconds ($0.265\text{ ns}$)**, comfortably passing the project requirement threshold of $2.5\text{ ns}$.  

###  Latch-Based Differential Sense Amplifier
* **Implementation:** Verified a high-speed latching strobe topology equipped with input isolation switches.  
* **Observation:** The dynamic transient waveforms successfully demonstrate physical clock feedthrough and charge injection glitches upon clock enablement at $1.5\text{ns}$, followed by an instant rail-to-rail differential latch split ($1.8\text{V}$ vs $0\text{V}$).  
