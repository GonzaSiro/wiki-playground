# 07 - Clock Constraints

Frecuencia objetivo de prueba (dummy): 50 MHz → período 20 ns.

```tcl
create_clock -period 20.000 -name sys_clk_pin [get_ports CLKs]
```
