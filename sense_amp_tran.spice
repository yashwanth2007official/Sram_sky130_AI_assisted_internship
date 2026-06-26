* Latch-Based Differential Sense Amplifier Transient Verification
* Target: SkyWater 130nm PDK (1.8V Operation)

*** 1. MOCK SUBCIRCUIT DEFINITIONS ***
.subckt sky130_fd_pr__nfet_01v8 d g s b W=0.42 L=0.15
.model mock_nfet nmos (level=1 vto=0.4 kp=120u)
M0 d g s b mock_nfet w={W} l={L}
.ends

.subckt sky130_fd_pr__pfet_01v8 d g s b W=0.21 L=0.15
.model mock_pfet pmos (level=1 vto=-0.4 kp=40u)
M0 d g s b mock_pfet w={W} l={L}
.ends

*** 2. MODULE: LATCH-BASED SENSE AMPLIFIER ***
.subckt voltage_sense_amp VDD VSS SA_EN BL BLB SA_OUT SA_OUTB
* Cross-coupled inverter pair (The Core Latch)
XNM1 SA_OUT  SA_OUTB tail VSS sky130_fd_pr__nfet_01v8 W=0.84 L=0.15
XNM2 SA_OUTB SA_OUT  tail VSS sky130_fd_pr__nfet_01v8 W=0.84 L=0.15
XPM1 SA_OUT  SA_OUTB VDD  VDD sky130_fd_pr__pfet_01v8 W=0.42 L=0.15
XPM2 SA_OUTB SA_OUT  VDD  VDD sky130_fd_pr__pfet_01v8 W=0.42 L=0.15

* Pass transistors connecting Bitlines to the internal latch outputs
XISO1 SA_OUT  BL  VDD VDD sky130_fd_pr__pfet_01v8 W=0.42 L=0.15
XISO2 SA_OUTB BLB VDD VDD sky130_fd_pr__pfet_01v8 W=0.42 L=0.15

* Tail NMOS enabling switch
XENABLE tail SA_EN VSS VSS sky130_fd_pr__nfet_01v8 W=1.2 L=0.15
.ends

*** 3. POWER SUPPLIES & ENABLING STROBE CLOCK ***
Vdd VDD 0 DC 1.8
Vss VSS 0 DC 0

* SA_EN starts at 0V, fires high to 1.8V at 1.5ns to activate amplification
Vstrobe SA_EN 0 PULSE(0 1.8 1.5ns 0.05ns 0.05ns 2ns 5ns)

*** 4. INSTANTIATION ***
XSA1 VDD VSS SA_EN BL BLB SA_OUT SA_OUTB voltage_sense_amp

*** 5. INITIAL CONDITIONS (Simulating the 100mV Read Delta) ***
* BL stays at 1.8V, BLB drops slightly to 1.7V due to a mock 6T cell read
.ic v(bl)=1.8 v(blb)=1.7 v(sa_out)=1.8 v(sa_outb)=1.7

*** 6. SIMULATION DIRECTIVE & PLOT ***
.tran 0.01ns 4ns

.control
run
set xbrushwidth=2
plot v(sa_en) v(sa_out) v(sa_outb) title 'Sense Amplifier Latching Response'
.endc

.end
