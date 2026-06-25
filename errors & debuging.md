### Error-1:
Error: unknown subckt: xcell1 wl bl blb vdd vss q1 qb1 vsweep vss Simulation interrupted due to error!
CAUSE: The AI netlist script missed a critical token right at the instantiation line.
In SPICE syntax, whenever you create an instance of a subcircuit (any line starting with the letter X), the layout must follow this exact rule:
X_instance_name node1 node2 ... nodeN subcircuit_name
The script defined the subcircuit sram_6t_cell perfectly in Section 2, but in Section 4, it listed all the connection nodes for Xcell1 and Xcell2 and completely forgot to append the actual name sram_6t_cell at the very end of those lines. Ngspice looked at the last node (VSS), assumed that was the name of the subcircuit, couldn't find a subcircuit definition called "VSS", and threw a compilation error.

### Debug-1:
reason:The Squished Butterfly
In Read Static Noise Margin (RSNM) simulation, but the two loops (the "eyes" of the butterfly) are extremely narrow and squished
In a robust SRAM design,  two eyes are to be as wide and square as possible. The size of the largest square you can fit inside those loops decides how much noise voltage the cell can tolerate before it instantly corrupts its data. Right now,  cell has a very weak noise margin. If a tiny bit of electronic noise hits this cell during a read operation, it will experience a Read Disturb and flip its data accidentally.
<img width="602" height="532" alt="Screenshot 2026-06-25 120611" src="https://github.com/user-attachments/assets/ee55f407-0eff-4cbe-aea0-a858ac62d52a" />
solution:make the internal pull-down NMOS drivers much stronger by doubling their width ($W$) from 0.42 to 0.84
