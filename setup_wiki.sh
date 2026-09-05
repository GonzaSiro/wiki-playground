#!/bin/bash
# Correr este script DENTRO de la carpeta wiki-playground.wiki (ya clonada)
# Genera toda la estructura de páginas de práctica con contenido dummy.

set -e

# ---------- Home ----------
cat > Home.md << 'EOF'
# Proyecto: Comparación de Arquitecturas FIR (Demo)

Este es un espacio de práctica para aprender a usar GitHub Wiki.
El contenido acá es **ficticio** — números y datos de ejemplo, no resultados reales.

## Índice

Ver la barra lateral para navegar por todas las secciones.

- [00 - Project Status](00-Project-Status)
- [01 - Introducción](01-Introduccion)
- [02 - Fundamentos](02-Fundamentos-Filtro-FIR)
- [03 - Arquitecturas FIR](03-Arquitecturas-FIR-Convencional)
- [04 - Implementación](04-Implementacion-Estructura-Proyecto)
- [05 - Simulación](05-Simulacion-Funcional)
- [06 - Síntesis e Implementación](06-Sintesis-Flujo-Vivado)
- [07 - Timing](07-Timing-Clock-Constraints)
- [08 - Resultados](08-Resultados-Recursos)
- [09 - Decisiones de Diseño](09-Decisiones-de-Diseno)
- [10 - Comandos Vivado](10-Comandos-Vivado)
- [11 - Referencias](11-Referencias)
EOF

# ---------- 00 - Project Status ----------
cat > 00-Project-Status.md << 'EOF'
# 00 - Project Status

| Etapa | Estado |
|---|---|
| RTL de las 5 arquitecturas FIR | ✅ Completo |
| Testbenches | ✅ Completo |
| Síntesis (report_utilization) | ✅ Completo |
| Timing (report_timing) | 🔄 En progreso |
| Comparación final | ⬜ Pendiente |

Última actualización: (fecha de ejemplo) 2026-09-05
EOF

# ---------- 01 - Introducción ----------
cat > 01-Introduccion.md << 'EOF'
# 01 - Introducción

Este proyecto compara 5 arquitecturas distintas de implementación de un filtro FIR
de 5 taps, evaluando trade-offs de área (LUTs, DSPs) contra timing (frecuencia máxima).

Ver [02 - Fundamentos](02-Fundamentos-Filtro-FIR) para la base teórica,
y [03 - Arquitecturas FIR](03-Arquitecturas-FIR-Convencional) para el detalle de cada implementación.
EOF

# ---------- 02 - Fundamentos ----------
cat > 02-Fundamentos-Filtro-FIR.md << 'EOF'
# 02 - Fundamentos: Filtro FIR

Un filtro FIR (Finite Impulse Response) calcula su salida como una suma ponderada
de un número finito de muestras de entrada pasadas:

y[n] = h0*x[n] + h1*x[n-1] + h2*x[n-2] + h3*x[n-3] + h4*x[n-4]

Ver también:
- [Estructura Transversal](02-Fundamentos-Estructura-Transversal)
- [Representación de Coeficientes](02-Fundamentos-Representacion-Coeficientes)
EOF

cat > 02-Fundamentos-Estructura-Transversal.md << 'EOF'
# Estructura Transversal (Direct Form)

Es la implementación más directa: una línea de retardo (tap delay line) con
un multiplicador y un sumador por coeficiente.

(Diagrama de bloques de ejemplo — reemplazar por el real)
EOF

cat > 02-Fundamentos-Representacion-Coeficientes.md << 'EOF'
# Representación de Coeficientes

Distintas formas de codificar los coeficientes afectan directamente el costo
de implementación en hardware:

- Binario estándar (multiplicador genérico)
- CSD (Canonic Signed Digit) — reduce cantidad de sumas parciales
- Distributed Arithmetic (DA) — reemplaza multiplicadores por ROM + shift-add
EOF

# ---------- 03 - Arquitecturas FIR ----------
cat > 03-Arquitecturas-FIR-Convencional.md << 'EOF'
# FIR Convencional

Implementación directa con multiplicadores genéricos.

**Datos de ejemplo (dummy):**

| Recurso | Cantidad |
|---|---|
| LUTs | 250 |
| DSPs | 5 |
| FFs | 96 |

Ver comparación completa en [08 - Resultados](08-Resultados-Comparacion).
EOF

cat > 03-Arquitecturas-FIR-CSD.md << 'EOF'
# FIR CSD (Canonic Signed Digit)

Reemplaza multiplicadores por sumas/restas de potencias de 2, usando la
representación CSD de cada coeficiente.

**Datos de ejemplo (dummy):**

| Recurso | Cantidad |
|---|---|
| LUTs | 180 |
| DSPs | 0 |
| FFs | 96 |
EOF

cat > 03-Arquitecturas-FIR-CV.md << 'EOF'
# FIR CV (Correction Vector)

Variante que elimina la lógica de extensión de signo mediante un vector de
corrección global (GCV) sumado una sola vez al final.

**Datos de ejemplo (dummy):**

| Recurso | Cantidad |
|---|---|
| LUTs | 160 |
| DSPs | 0 |
| FFs | 96 |
EOF

cat > 03-Arquitecturas-FIR-DA.md << 'EOF'
# FIR DA (Distributed Arithmetic)

Reemplaza los multiplicadores por una ROM de valores precomputados,
accedida bit-serial mediante una cadena de desplazamiento.

**Datos de ejemplo (dummy):**

| Recurso | Cantidad |
|---|---|
| LUTs | 90 |
| DSPs | 0 |
| FFs | 60 |

Nota: mayor latencia (procesamiento bit-serial) a cambio de mucho menor área.
EOF

cat > 03-Arquitecturas-FIR-TDF.md << 'EOF'
# FIR TDF Compensation (Transposed / 3:2 Compressors)

Usa árboles de compresores 3:2 (Wallace/Dadda-like) para sumar las parciales,
mejorando el timing respecto al FIR convencional.

**Datos de ejemplo (dummy):**

| Recurso | Cantidad |
|---|---|
| LUTs | 210 |
| DSPs | 0 |
| FFs | 110 |
EOF

# ---------- 04 - Implementación ----------
cat > 04-Implementacion-Estructura-Proyecto.md << 'EOF'
# 04 - Implementación: Estructura del Proyecto

```
rtl/
├── firs/
├── multipliers/
└── adders/
tb/
constrain/
```

Ver:
- [Módulos Verilog](04-Implementacion-Modulos-Verilog)
- [Testbenches](04-Implementacion-Testbenches)
- [Constraints](04-Implementacion-Constraints)
EOF

cat > 04-Implementacion-Modulos-Verilog.md << 'EOF'
# Módulos Verilog

Cada arquitectura FIR se selecciona en el top mediante `` `define ``:

```verilog
`define FIRfilter
//`define FIRfilterCSD
//`define FIRfilterCV
//`define FIRfilterTDFComp
```
EOF

cat > 04-Implementacion-Testbenches.md << 'EOF'
# Testbenches

Cada bloque (FIR, multiplicador, sumador) tiene su testbench dedicado para
verificación funcional antes de síntesis.
EOF

cat > 04-Implementacion-Constraints.md << 'EOF'
# Constraints

Archivos `.xdc` con:
- `create_clock` sobre el puerto de clock del top
- `set_property PACKAGE_PIN` / `IOSTANDARD` para I/O físicos

Ejemplo (dummy):

```tcl
create_clock -period 20.000 -name sys_clk_pin [get_ports CLKs]
```
EOF

# ---------- 05 - Simulación ----------
cat > 05-Simulacion-Funcional.md << 'EOF'
# 05 - Simulación Funcional

Verificación de que la salida del filtro coincide con el modelo de referencia
(ejemplo: comparación contra cálculo en punto flotante en Python/MATLAB).
EOF

cat > 05-Simulacion-Verificacion.md << 'EOF'
# Verificación

Checklist de casos de prueba (dummy):

- [ ] Impulso unitario
- [ ] Escalón
- [ ] Señal senoidal
- [ ] Casos límite (saturación)
EOF

cat > 05-Simulacion-Resultados.md << 'EOF'
# Resultados de Simulación

(Acá irían capturas de forma de onda o gráficos de comparación — placeholder)
EOF

# ---------- 06 - Síntesis e Implementación ----------
cat > 06-Sintesis-Flujo-Vivado.md << 'EOF'
# 06 - Flujo Vivado

1. `synth_design`
2. `opt_design`
3. `place_design`
4. `route_design`
5. `report_utilization` / `report_timing_summary`

Ver [10 - Comandos Vivado](10-Comandos-Vivado) para el detalle de cada comando usado.
EOF

cat > 06-Sintesis-Utilizacion-Recursos.md << 'EOF'
# Utilización de Recursos

Tabla resumen (dummy) de las 5 arquitecturas — ver detalle real en
[08 - Resultados: Recursos](08-Resultados-Recursos).
EOF

cat > 06-Sintesis-Primitivas.md << 'EOF'
# Primitivas

Primitivas Xilinx inferidas por arquitectura (ejemplo dummy):

| Arquitectura | Primitivas típicas |
|---|---|
| Convencional | DSP48E1 |
| CSD / CV / TDF | LUT6, CARRY4 |
| DA | RAMB18E1 (o distributed RAM), SRL |
EOF

cat > 06-Sintesis-Schematic.md << 'EOF'
# Schematic

(Acá irían capturas del schematic post-síntesis de Vivado — placeholder)
EOF

# ---------- 07 - Timing ----------
cat > 07-Timing-Clock-Constraints.md << 'EOF'
# 07 - Clock Constraints

Frecuencia objetivo de prueba (dummy): 50 MHz → período 20 ns.

```tcl
create_clock -period 20.000 -name sys_clk_pin [get_ports CLKs]
```
EOF

cat > 07-Timing-Worst-Slack.md << 'EOF'
# Worst Slack

Tabla dummy:

| Arquitectura | Período (ns) | WNS (ns) |
|---|---|---|
| Convencional | 20 | +10.89 |
| CSD | 20 | +13.20 |
| CV | 20 | +14.10 |
| DA | 20 | +16.50 |
| TDF | 20 | +11.40 |
EOF

cat > 07-Timing-Data-Path-Delay.md << 'EOF'
# Data Path Delay

Desglose dummy del path crítico: lógica de multiplicación/suma + routing.
EOF

cat > 07-Timing-Frequency-Sweep.md << 'EOF'
# Frequency Sweep

Barrido de período de clock para encontrar la frecuencia máxima de cada
arquitectura (dummy, a completar con datos reales).

| Arquitectura | Fmax estimada (MHz) |
|---|---|
| Convencional | ~110 |
| CSD | ~130 |
| CV | ~135 |
| DA | ~160 |
| TDF | ~115 |
EOF

# ---------- 08 - Resultados ----------
cat > 08-Resultados-Recursos.md << 'EOF'
# 08 - Resultados: Recursos

| Arquitectura | LUTs | DSPs | FFs |
|---|---|---|---|
| Convencional | 250 | 5 | 96 |
| CSD | 180 | 0 | 96 |
| CV | 160 | 0 | 96 |
| DA | 90 | 0 | 60 |
| TDF | 210 | 0 | 110 |
EOF

cat > 08-Resultados-Timing.md << 'EOF'
# Resultados: Timing

Ver [07 - Worst Slack](07-Timing-Worst-Slack) y [Frequency Sweep](07-Timing-Frequency-Sweep).
EOF

cat > 08-Resultados-Comparacion.md << 'EOF'
# Comparación General

| Arquitectura | LUTs | DSPs | Fmax (MHz) | Trade-off |
|---|---|---|---|---|
| Convencional | 250 | 5 | ~110 | Simple, usa DSPs |
| CSD | 180 | 0 | ~130 | Buen balance área/velocidad |
| CV | 160 | 0 | ~135 | Menor área que CSD |
| DA | 90 | 0 | ~160 | Mínima área, mayor latencia |
| TDF | 210 | 0 | ~115 | Compresores 3:2, sin DSPs |
EOF

cat > 08-Resultados-Analisis.md << 'EOF'
# Análisis

(Discusión de trade-offs — a completar con conclusiones reales del proyecto)
EOF

# ---------- 09 - Decisiones de Diseño ----------
cat > 09-Decisiones-de-Diseno.md << 'EOF'
# 09 - Decisiones de Diseño

Ejemplo de cómo documentar decisiones (formato sugerido):

## Decisión: Exclusión de BPS standalone para 64-QAM
**Contexto:** BPS standalone excede los recursos disponibles en la FPGA target.
**Decisión:** Se descarta como opción viable, justificado por costo de
implementación en hardware, no por costo computacional teórico.
**Alternativas consideradas:** pilot-aided CPR, DD-PLL con paralelismo.
EOF

# ---------- 10 - Comandos Vivado ----------
cat > 10-Comandos-Vivado.md << 'EOF'
# 10 - Comandos Vivado (referencia rápida)

```tcl
# Reporte de utilización
report_utilization -file utilization.rpt

# Reporte de timing, peor path primero
report_timing -delay_type max -sort_by slack -max_paths 10

# Resumen de timing post-route
report_timing_summary -file timing_summary.rpt
```
EOF

# ---------- 11 - Referencias ----------
cat > 11-Referencias.md << 'EOF'
# 11 - Referencias

- [IEEE Xplore](https://ieeexplore.ieee.org/)
- (Agregar aquí las referencias IEEE numeradas del proyecto real)
EOF

# ---------- Sidebar ----------
cat > _Sidebar.md << 'EOF'
### 🏠 [Home](Home)

**[00 - Project Status](00-Project-Status)**

**[01 - Introducción](01-Introduccion)**

**02 - Fundamentos**
- [Filtro FIR](02-Fundamentos-Filtro-FIR)
- [Estructura Transversal](02-Fundamentos-Estructura-Transversal)
- [Representación de Coeficientes](02-Fundamentos-Representacion-Coeficientes)

**03 - Arquitecturas FIR**
- [Convencional](03-Arquitecturas-FIR-Convencional)
- [CSD](03-Arquitecturas-FIR-CSD)
- [CV](03-Arquitecturas-FIR-CV)
- [DA](03-Arquitecturas-FIR-DA)
- [TDF Compensation](03-Arquitecturas-FIR-TDF)

**04 - Implementación**
- [Estructura del Proyecto](04-Implementacion-Estructura-Proyecto)
- [Módulos Verilog](04-Implementacion-Modulos-Verilog)
- [Testbenches](04-Implementacion-Testbenches)
- [Constraints](04-Implementacion-Constraints)

**05 - Simulación**
- [Simulación Funcional](05-Simulacion-Funcional)
- [Verificación](05-Simulacion-Verificacion)
- [Resultados](05-Simulacion-Resultados)

**06 - Síntesis e Implementación**
- [Flujo Vivado](06-Sintesis-Flujo-Vivado)
- [Utilización de Recursos](06-Sintesis-Utilizacion-Recursos)
- [Primitivas](06-Sintesis-Primitivas)
- [Schematic](06-Sintesis-Schematic)

**07 - Timing**
- [Clock Constraints](07-Timing-Clock-Constraints)
- [Worst Slack](07-Timing-Worst-Slack)
- [Data Path Delay](07-Timing-Data-Path-Delay)
- [Frequency Sweep](07-Timing-Frequency-Sweep)

**08 - Resultados**
- [Recursos](08-Resultados-Recursos)
- [Timing](08-Resultados-Timing)
- [Comparación](08-Resultados-Comparacion)
- [Análisis](08-Resultados-Analisis)

**[09 - Decisiones de Diseño](09-Decisiones-de-Diseno)**

**[10 - Comandos Vivado](10-Comandos-Vivado)**

**[11 - Referencias](11-Referencias)**
EOF

echo ""
echo "Listo. Se crearon $(ls *.md | wc -l) archivos .md"
echo ""
echo "Próximo paso:"
echo "  git add ."
echo "  git commit -m \"Agrego estructura completa de la wiki (demo)\""
echo "  git push"
