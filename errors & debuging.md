### Error-1:
Error: unknown subckt: xcell1 wl bl blb vdd vss q1 qb1 vsweep vss Simulation interrupted due to error!
CAUSE: The AI netlist script missed a critical token right at the instantiation line.
In SPICE syntax, whenever you create an instance of a subcircuit (any line starting with the letter X), the layout must follow this exact rule:
X_instance_name node1 node2 ... nodeN subcircuit_name
The script defined the subcircuit sram_6t_cell perfectly in Section 2, but in Section 4, it listed all the connection nodes for Xcell1 and Xcell2 and completely forgot to append the actual name sram_6t_cell at the very end of those lines. Ngspice looked at the last node (VSS), assumed that was the name of the subcircuit, couldn't find a subcircuit definition called "VSS", and threw a compilation error.

### Debug-1:
