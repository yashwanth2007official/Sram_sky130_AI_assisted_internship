# Week 1: Research Fundamentals, PDK Integration & AI-Assisted Architecture Exploration

## Project Overview
This repository contains the foundational research, environment specifications, and AI-assisted engineering methodology for a **32 Kbit (1024x32 / 4 KB) SRAM Macro**. The design targets the open-source **Google SkyWater 130nm PDK** node, an operating voltage of **1.8V**, and an optimized access time of **< 2.5ns** using the **OpenRAM** memory compiler framework.

Our baseline structural reference is modeled after the `ShonTaware/SRAM_SKY130` implementation. 

---

## Technical Specifications & Architectural Hierarchy
The 4 KB memory macro is architected as a hierarchical array of 1024 rows by 32 columns. To manage data access cycles efficiently, the memory is decomposed into the following core sub-blocks:

* **6T SRAM Core Array:** A matrix of bistable latches holding individual bits using symmetrical cross-coupled CMOS inverters and dual pass-transistor access gates.
* **Pre-charge Circuit:** An active-low PMOS network used to charge and equalize the highly capacitive bitlines ($BL$ and $\overline{BL}$) to $V_{DD}$ prior to read execution.
* **Latch-Based Sense Amplifier:** A highly localized differential comparator that amplifies tiny bitline voltage swings ($\Delta V \approx 100\text{–}200\text{ mV}$) to full-swing CMOS logic rails.
* **Write Driver:** Sized with high-drive-strength tri-state logic to force bitlines to absolute ground, overpowering the 6T cell's internal feedback loop during a write state.
* **Peripheral Decoders & Timing Controls:** D-Flip-Flops (D-FF) and address line decoders that synchronize internal timing clocks and activate specific rows via the Wordline (`WL`).

---

## Open-Source EDA Tool Interconnect
The end-to-end framework bridges independent open-source tools into an automated compilation pipeline:

```text
  +------------------+     +--------------------+     +-------------------+
  |  Xschem (.xsch)  | --> |  Ngspice Netlist   | --> | Pre-Layout (.sp)  |
  | Schematic Editor |     |  Circuit Simulator |     | Simulation Check  |
  +------------------+     +--------------------+     +-------------------+
                                                                |
                                                                v
  +------------------+     +--------------------+     +-------------------+
  |   OpenRAM (.py)  | <-- | Magic VLSI Layout  | <-- | Custom Seed Cells |
  | Memory Compiler  |     |  DRC & GDS Extract |     | (GDS, SPICE, LEF) |
  +------------------+     +--------------------+     +-------------------+

```
# Weeks 2 & 3: Transistor-Level Circuit Design & SPICE Verification

## Project Overview
This stage of the internship focuses entirely on the transistor-level circuit design, stability analysis, and functional verification of critical SRAM peripheral and core blocks. All simulations utilize the open-source **Xschem** schematic editor and **Ngspice** circuit simulator, targeted at the **Google SkyWater 130nm PDK** node operating at 1.8V.

The primary objective is to verify circuit building blocks to achieve a target macro access time of < 2.5ns.

---

## Circuit Blocks Covered & Verified

### 1. 6T SRAM Bitcell
* **Core Latch:** Implemented using cross-coupled CMOS inverter primitives (`sky130_fd_pr__nfet_01v8` and `sky130_fd_pr__pfet_01v8`).
* **Sizing Optimization:** Set Cell Ratio (CR) to 2.0 to eliminate read disturb and ensure a robust Read Static Noise Margin (RSNM).
* **Characterization:** Plotted Voltage Transfer Characteristics (VTC) to generate the signature "Butterfly Curve".

### 2. Pre-charge Circuit
* Built using a 3-PMOS transistor topology (two pull-ups, one equalization switch).
* Successfully charges and equilibrates the highly capacitive bitlines ($BL$ and $\overline{BL}$) to exactly 1.8V during the active-low `PRE_B` cycle phase.

### 3. Latch-Based Sense Amplifier
* Designed a high-speed, cross-coupled differential sense amplifier.
* Amplifies a micro-volt bitline differential voltage ($\Delta V \approx 100mV$) to full rail-to-rail digital CMOS logic outputs upon activation of the `SA_EN` pulse signal.

### 4. Write Driver
* Utilizes high-drive-strength tri-state inverter structures to pull the targeted bitline cleanly to 0V (GND), forcefully overpowering the internal feedback loop of the 6T cell during write cycles.

---

## Master Timing Sequence & Choreography

The successful execution of a complete memory access cycle follows a strict chronographic sequence verified in our transient simulation decks:

1. **Pre-charge Phase:** `PRE_B` drops LOW $\rightarrow$ Bitlines hit 1.8V symmetrically $\rightarrow$ `PRE_B` returns HIGH.
2. **Decode Phase:** Row address lines stabilize $\rightarrow$ Row decoder drives selected Wordline (`WL`) HIGH.
3. **Discharge Phase:** Target 6T cell develops localized differential voltage ($\Delta V$) on bitlines.
4. **Sense Phase:** `SA_EN` transitions HIGH $\rightarrow$ $\Delta V$ is instantly snapped to full logic values $\rightarrow$ `WL` returns LOW.

---

## Simulation Waveforms & Results
*(Place your generated Ngspice waveform images below)*

### 6T Bitcell Butterfly Curve (RSNM)
`![6T Cell Butterfly Curve](Simulation_Results/butterfly_curve.png)`

### Transient Simulation: Read/Write Clock Cycles
`![Transient Access Sequence](Simulation_Results/transient_timing.png)`
