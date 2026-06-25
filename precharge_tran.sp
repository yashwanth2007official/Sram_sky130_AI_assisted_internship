* SRAM Pre-charge Circuit Transient Verification
* Target: SkyWater 130nm PDK (1.8V Operation)

*** 1. MOCK SUBCIRCUIT DEFINITIONS FOR SKY130 ***
.subckt sky130_fd_pr__pfet_01v8 d g s b W=0.42 L=0.15
.model mock_pfet pmos (level=1 vto=-0.4 kp=40u)
M0 d g s b mock_pfet w={W} l={L}
.ends

*** 2. MODULE: 3-PMOS PRE-CHARGE CIRCUIT ***
.subckt sram_precharge PRE_B BL BLB VDD
* Pull-up PMOS for BL and BLB
XPM1 BL  PRE_B VDD VDD sky130_fd_pr__pfet_01v8 W=0.84 L=0.15
XPM2 BLB PRE_B VDD VDD sky130_fd_pr__pfet_01v8 W=0.84 L=0.15
* Equalizer PMOS between bitlines
XPM3 BL  PRE_B BLB VDD sky130_fd_pr__pfet_01v8 W=0.42 L=0.15
.ends

*** 3. POWER SUPPLIES & TIME-VARYING CLOCK INJECTION ***
Vdd VDD 0 DC 1.8

* Pulse Generator for PRE_B (Active-Low Pre-charge Clock)
* Syntax: PULSE(Vinitial Vpulse delay rise fall width period)
* Starts at 1.8V (OFF), drops to 0V (ON) at 1ns, stays low for 2ns
Vclk PRE_B 0 PULSE(1.8 0 1ns 0.05ns 0.05ns 2ns 5ns)

*** 4. INSTANTIATION & BITLINE CAPACITANCE LOAD ***
Xpre1 PRE_B BL BLB VDD sram_precharge

* Adding large capacitors to simulate the heavy load of a 1024-row array
C_bl  BL  0 100f
C_blb BLB 0 100f

*** 5. INITIAL CONDITIONS & SIMULATION DIRECTIVE ***
* Force bitlines to start at 0V so we can watch them charge up
.ic v(bl)=0 v(blb)=0

* Run a transient simulation from 0 to 5 nanoseconds with a 0.01ns resolution
.tran 0.01ns 5ns

*** 6. CONTROL BLOCK FOR GRAPHING ***
.control
run
set xbrushwidth=2
plot v(pre_b) v(bl) v(blb) title 'SRAM Pre-charge & Bitline Transient Response'
.endc

.end
