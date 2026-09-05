# 10 - Comandos Vivado (referencia rápida)

```tcl
# Reporte de utilización
report_utilization -file utilization.rpt

# Reporte de timing, peor path primero
report_timing -delay_type max -sort_by slack -max_paths 10

# Resumen de timing post-route
report_timing_summary -file timing_summary.rpt
```
