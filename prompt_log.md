
# AI Prompt & Generation Log
**AI MODEL USED:** Gemini-3.5 Pro,Gpt-5.5,Opus-4.6 Sonnet  
**Goal:** Step-by-step circuit verification of SRAM blocks using actual Sky130 PDK models.

---

# Week 1: OpenRAM Architecture & Infrastructure

### phase-1_1: Compilation Flow Deconstruction
* **My Prompt:**
* [Role: Senior VLSI Architecture & Memory Compiler Expert]
*  **Task**: Analyze the structural layout of the repository 'ShonTaware/SRAM_SKY130'. Deconstruct its compilation flow into a sequence of 5 distinct, executable research tasks suitable for an undergraduate engineering intern. 
* **AI Response Summary:** Provided a highly structured 5-phase breakdown separating EDA provisioning, bitcell RSNM analysis, array peripheral design, layout generation, and OpenRAM integration.

### phase-1_2: Layer Mappings for OpenRAM
* **My Prompt:**  
* [Role: Open-Source EDA Tool Automation Script]  
 **Context:** Porting the SkyWater 130nm process node to the OpenRAM Python framework. Task: Generate a Codex-style python snippet for a 'tech.py' file that explicitly defines the interconnect metal stack and GDS layer mapping indices.  
* **AI Response Summary:** Generated a clean Python dictionary explicitly linking the Sky130 standard DRC routing layers to the OpenRAM `tech.py` format.

### phase-1_3: Environment Provisioning (EDA Tools)
* **My Prompt:** Write an automated bash setup script template (.sh) that installs dependencies, clones, compiles, and registers the absolute execution paths for 'Magic', 'Ngspice', and 'Xschem' on Ubuntu LTS.
* **AI Response Summary:** Output a complete bash script fetching the dependencies for the EDA tools and exporting them to the `.bashrc` path.

---
# Weeks 2 & 3: Circuit Design & Verification (Sky130 PDK)
## phase-2_1: 6T Bitcell Operation & Read Disturb Stability
**My Prompt:**  
[Role: Memory Bitcell Reliability Engineer]  
**Context:** SkyWater 130nm PDK (1.8V nominal, TT corner).  
**Task:** Deconstruct the electrical behavior of an un-optimized 6T SRAM cell during a static Read cycle. Mathematically and physically explain the 'Read Disturb' phenomenon where the internal storage node '0' bounces above ground due to the voltage divider between the access pass-gate transistor and the pull-down transistor. Provide the exact sizing formulas for the Cell Ratio (CR) to maintain static stability.  
**AI Response Summary:** Explained the voltage divider effect between the Access Pass-Gate and the Pull-Down NMOS. Advised scaling the pull-down transistor width relative to the access device ($CR = W_{PD}/W_{PG}$) to suppress the internal node bounce during access.
## phase-2_2: Butterfly Curve & Static Noise Margin (RSNM) Netlist
**My Prompt:**  
[Role: VLSI Analog Automation Expert]  
**Context:** SkyWater 130nm PDK (1.8V operation, TT corner, hsa compatibility mode).  
**Task:** Write a production-grade Ngspice simulation netlist to measure the Read Static Noise Margin (RSNM) of a 6T SRAM cell.   
**Include:** Inclusion of actual sky130 nfet and pfet primitive subcircuits (sky130_fd_pr__nfet_01v8) with layout-realistic device scaling ($W_{PD}=0.84\mu m, W_{PG}=0.42\mu m, W_{PU}=0.42\mu m$).   
**Read condition bias:** Wordline (WL), Bitline (BL), and Bitline-Bar (BLB) held statically at 1.8V.Latch feedback isolation using cross-coupled half-cells to allow dual DC voltage sweeps (0V to 1.8V) into the storage nodes.An automated .control block that plots the regular and flipped voltage transfer curves (VTC) to render the RSNM Butterfly Curve.   
**AI Response Summary:** Provided a highly accurate SPICE deck replacing mock models with true SkyWater 130nm TT corner parameters and upscaled the PMOS/NMOS widths to meet the $0.42\mu\text{m}$ physical boundary limits.  
**Generated File**: `read_snm_6t.spice`  
**Result:** Output successfully simulated a true-silicon butterfly curve mapping a physical 0.15V Read Disturb bounce.  
## phase-2_3: High-Drive Pre-charge Circuit Architecture
**My Prompt:**
[Role: Custom Memory Peripheral Designer]  
**Context:** SkyWater 130nm process technology (1.8V supply).
**Task:** Design a 3-transistor PMOS pre-charge and equalization network for an SRAM bitline column. The circuit must include two pull-up PMOS devices for BL and BLB, and an equalization PMOS bridging BL and BLB directly. Explain the structural necessity of the equalization device in preventing differential offset errors during subsequent high-speed sense amplifier strobing.  
**AI Response Summary:** Ai explained that the equalization transistor guarantees both bitlines start at the exact same potential, preventing accidental differential offsets that could corrupt the Sense Amplifier.
## phase-2_4: Bitline Behavior & Parasitic Array RC Modeling
**My Prompt:**
[Role: VLSI Parasitic & Signal Integrity Engineer]   
**Context:** SkyWater 130nm model parameters with a simulated 128-row column matrix.  
**Task:** Integrate the 3-PMOS pre-charge network with the 6T bitcell, loading both BL and BLB with a conservative 100fF lumped parasitic column capacitance. Run a transient analysis with an active-low pre-charge pulse (PRE_B). Debug the RC delay mismatch where minimum-sized PMOS switches ($W=0.42\mu m$) fail to pull the bitlines above 1.3V within a tight 1.0ns pre-charge clock window, and calculate the required transistor upscaling to achieve full 1.8V rail saturation.  
**AI Response Summary:** Analyzed the RC time constant delay caused by physical channel resistance in the Sky130 PMOS models. Provided an updated script upsizing the PMOS pull-up network to $4.0\mu\text{m}$ to fully saturate the heavy bitline load on time.  
**Generated File:** `precharge_tran.spice`  
## phase-2_5: Write Driver Circuit Matrix & Write Margin Optimization
**My Prompt:**
[Role: High-Speed Digital Circuit Designer]  
**Context:**  SkyWater 130nm library models.  
**Task:** Develop a series-gated AND-type Write Driver circuit that actively prevents floating-state noise injection when Write Enable (WRITE_EN) is low. Define the engineering criteria for 'Write Margin' and specify how the sizing of the write driver's pull-down NMOS networks ($W=2.0\mu m$) is optimized to successfully discharge the pre-charged bitline and overpower the internal PMOS pull-up device of the 6T cell during a cell state overwrite.  
**AI Response Summary:** Advised a series-gated AND-logic pull-down tree configuration. To ensure a high Write Margin, Gemini upscaled the driver NMOS widths to $2.0\mu\text{m}$ to easily overpower the internal $0.42\mu\text{m}$ PMOS pull-up network of the 6T cell.
## phase-2_6: Wordline Control, Timing Sequence & Access Time Extraction
**My Prompt:**
[Role: Static Timing Analysis (STA) Engineer]  
**Context:** Fully integrated SRAM memory column running on true Sky130 PDK models.  
**Task:** Construct an integrated transient verification testbench that models the complete write sequence pipeline. Choreograph a precise chronographic clock injection schema: Pre-charge active from 0-1ns, Wordline (WL) activated at 1.5ns, and Write Enable (WEN) toggled high at 1.7ns with DATA_IN=0. Embed automated SPICE .measure directives to calculate the exact 'Write Access Delay' by measuring the time delta between WEN reaching 50% VDD and the internal cell node Q dropping to 50% VDD, validating it against a target system speed limit of 2.5ns.  
**AI Response Summary:** Generated a fully integrated transient timing deck with chronographic clock signals and SPICE .measure directives.  
**Generated File:** `precharge_tran.spice`  
**Result:** Terminal .measure output confirmed an exact Write Access Delay of 265.79 picoseconds (Target was < 2.5ns).  
## phase-2_7: Latch-Based Differential Sense Amplifier Verification
**My Prompt:**
[Role: Advanced Analog Layout & Simulation Expert]  
**Context:** SkyWater 130nm process node.  
**Task:** Generate a transient verification deck for an active-isolation latch-based voltage sense amplifier. Force a mock read differential onto the bitlines by biasing BL at 1.8V and BLB at 1.7V ($100mV$ delta). Control the cross-coupled inverter latch with a high-speed tail NMOS current switch driven by a strobe signal (SA_EN) active at 1.5ns. Run a 3.2ns transient simulation to analyze physical non-idealities like clock feedthrough and charge injection, and verify full-swing rail-to-rail amplification.  
**AI Response Summary:** Provided a latch-based voltage sense amplifier deck with an active isolation strobe using the real Sky130 tt corner models.  
**Generated File:** `sense_amp_tran.spice`  
**Result:** Plotted dynamic waveforms demonstrating realistic clock feedthrough glitches followed by a clean, instant rail-to-rail differential digital split (1.8V vs 0V).
## phase-2_8: Row & Column Decoder Architectural Basics
**My Prompt:**  
[Role: Memory Subsystem Micro-Architect]  
**Task:** Define the logical and structural design specifications for a row and column decoding subsystem tailored for a 32-Kbit (1024 rows x 32 columns) macro architecture. Calculate the total number of primary address input bits required. Explain how cascading static CMOS logic gates (AND/NAND pre-decoders) are arranged to assert a single Wordline out of 1024 while holding non-targeted rows securely at ground potential.  
**AI Response Summary:** Ai calculated that to access 1024 discrete rows, a 10-bit Row Decoder ($2^{10} = 1024$) is required, utilizing cascading static CMOS AND/NAND gate trees to isolate untargeted data rows.
