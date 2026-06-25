### Error-1:RSNM
Error: (Unknown subckt: xcell1 wl bl blb vdd vss q1 qb1 vsweep vss Simulation interrupted due to error!  
CAUSE: The AI netlist script missed a critical token right at the instantiation line.
In SPICE syntax, whenever you create an instance of a subcircuit (any line starting with the letter X), the layout must follow this exact rule:  
X_instance_name node1 node2 ... nodeN subcircuit_name
The script defined the subcircuit sram_6t_cell perfectly in Section 2, but in Section 4, it listed all the connection nodes for Xcell1 and Xcell2 and completely forgot to append the actual name sram_6t_cell at the very end of those lines. Ngspice looked at the last node (VSS), assumed that was the name of the subcircuit, couldn't find a subcircuit definition called "VSS", and threw a compilation error.

### Debug-1:RSNM
REASON: The Squished Butterfly  
In Read Static Noise Margin (RSNM) simulation, but the two loops (the "eyes" of the butterfly) are extremely narrow and squished
In a robust SRAM design,  two eyes are to be as wide and square as possible. The size of the largest square you can fit inside those loops decides how much noise voltage the cell can tolerate before it instantly corrupts its data. Right now,  cell has a very weak noise margin. If a tiny bit of electronic noise hits this cell during a read operation, it will experience a Read Disturb and flip its data accidentally.  
<img width="602" height="532" alt="Screenshot 2026-06-25 120611" src="https://github.com/user-attachments/assets/ee55f407-0eff-4cbe-aea0-a858ac62d52a" />  
SOLUTION: :make the internal pull-down NMOS drivers much stronger by doubling their width ($W$) from 0.42 to 0.84
<img width="607" height="506" alt="Screenshot 2026-06-25 121459" src="https://github.com/user-attachments/assets/a94ddf14-1134-45a4-8b6a-451c85ed7a85" />



### Error-2:Amplifier
PROBLEM: The graph's time axis goes from -1.0 to 1.0 seconds instead of 0 to 4 nanoseconds, and there are no colored lines.  
<img width="607" height="532" alt="Screenshot 2026-06-25 180744" src="https://github.com/user-attachments/assets/dc45a7ae-39f1-475f-b68c-f7ee130b07da" />  
CAUSE: It means the simulation crashed at time zero ($t=0$) before it could even start the clock.  
FIX: Replace the floating initial conditions for BL and BLB with independent DC voltage sources (Vbl and Vblb).

### Error-3:Amplifier
PROBLEM: The circuit is executing a weird jump: v(sa_out) (the blue line) drops down to 0.6V instantly at time zero ($t=0$), long before your red enable signal (sa_en) even fires at 1.5ns.  
<img width="600" height="502" alt="Screenshot 2026-06-25 181834" src="https://github.com/user-attachments/assets/79d45604-a296-4de2-ab4b-8c770284ca6a" />  
CAUSE: Our simulation directive was simply written as .tran 0.01ns 4ns, Ngspice ignored our (.ic) Initial Condition commands at $t=0$, calculated the resting state using the unbalanced bitlines ($1.8\text{V}$ vs $1.7\text{V}$), and pre-biased the blue output node down to 0.6V. 
FIX: Append the uic 

### Error-4:Write
PROBLEM: The write driver turns completely OFF and goes to sleep right when it needs to be on.  
<img width="587" height="505" alt="Screenshot 2026-06-25 204044" src="https://github.com/user-attachments/assets/ae238cd9-ccda-4dce-8a1b-6e9f8190ccf4" />  
CAUSE: DATA_IN connected directly to the gate of the pulldown transistor. Because DATA_IN is to 0V (since a digital 0) the transistor's gate receives 0V  
FIX: Need to use  AND configuration between two NMOS transistors in series for each bitline:  
   1)Transistor 1 opens when WRITE_EN is high.  
   2)Transistor 2 opens only if the corresponding data line (DATA_IN or DATA_IN_B) tells it to pull down.  


