# Constraints

Archivos `.xdc` con:
- `create_clock` sobre el puerto de clock del top
- `set_property PACKAGE_PIN` / `IOSTANDARD` para I/O físicos

Ejemplo (dummy):

```tcl
create_clock -period 20.000 -name sys_clk_pin [get_ports CLKs]
```
