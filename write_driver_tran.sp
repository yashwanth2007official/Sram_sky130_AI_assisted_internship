cat << 'EOF' > write_driver_tran.sp
* Fully Integrated SRAM Write Cycle Transient Verification (Fixed Capacitance)
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

*** 2. SUBSYSTEM MODULES ***
.subckt sram_6t_cell WL BL BLB VDD VSS Q QB
XNM1 QB Q   VSS VSS sky130_fd_pr__nfet_01v8 W=0.84 L=0.15
XNM2 Q  QB  VSS VSS sky130_fd_pr__nfet_01v8 W=0.84 L=0.15
XPM1 QB Q   VDD VDD sky130_fd_pr__pfet_01v8 W=0.21 L=0.15
XPM2 Q  QB  VDD VDD sky130_fd_pr__pfet_01v8 W=0.21 L=0.15
XMA1 BLB WL QB  VSS sky130_fd_pr__nfet_01v8 W=0.30 L=0.15
XMA2 BL  WL Q   VSS sky130_fd_pr__nfet_01v8 W=0.30 L=0.15
.ends

.subckt sram_precharge PRE_B BL BLB VDD
XPM1 BL  PRE_B VDD VDD sky130_fd_pr__pfet_01v8 W=0.84 L=0.15
XPM2 BLB PRE_B VDD VDD sky130_fd_pr__pfet_01v8 W=0.84 L=0.15
XPM3 BL  PRE_B BLB VDD sky130_fd_pr__pfet_01v8 W=0.42 L=0.15
.ends

.subckt write_driver WRITE_EN DATA_IN DATA_IN_B BL BLB VSS
XN1 BL       WRITE_EN  mid_l VSS sky130_fd_pr__nfet_01v8 W=2.0 L=0.15
XN2 mid_l    DATA_IN_B VSS   VSS sky130_fd_pr__nfet_01v8 W=2.0 L=0.15
XN3 BLB      WRITE_EN  mid_r VSS sky130_fd_pr__nfet_01v8 W=2.0 L=0.15
XN4 mid_r    DATA_IN   VSS   VSS sky130_fd_pr__nfet_01v8 W=2.0 L=0.15
.ends

*** 3. SYSTEM INSTANTIATION & LOADS ***
Vdd VDD 0 DC 1.8
Vss VSS 0 DC 0

Xpre   PRE_B  BL BLB VDD      sram_precharge
Xcell1 WL     BL BLB VDD VSS  Q QB sram_6t_cell
Xdrv1  WRITE_EN DATA_IN DATA_IN_B BL BLB VSS write_driver

* FIXED: Added bitline array load capacitors to store pre-charge voltage
C_bl  BL  0 100f
C_blb BLB 0 100f

*** 4. TIMING SIGNAL INJECTION ***
Vpc PRE_B 0 PULSE(0 1.8 1ns 0.01ns 0.01ns 4ns 5ns)
Vwl WL 0 PULSE(0 1.8 1.5ns 0.01ns 0.01ns 2ns 5ns)
Vwen WRITE_EN 0 PULSE(0 1.8 1.7ns 0.01ns 0.01ns 1.5ns 5ns)

Vdata  DATA_IN   0 DC 0
Vdatab DATA_IN_B 0 DC 1.8

*** 5. INITIAL CONDITIONS ***
.ic v(q)=1.8 v(qb)=0 v(bl)=0 v(blb)=0

*** 6. SIMULATION DIRECTIVE ***
.tran 0.01ns 3.5ns uic

*** 7. GRAPHICAL DISPLAY ***
.control
run
set xbrushwidth=2
plot v(pre_b) v(bl) v(q) title 'Successful Integrated SRAM Write Cycle Timeline'
.endc

.end
