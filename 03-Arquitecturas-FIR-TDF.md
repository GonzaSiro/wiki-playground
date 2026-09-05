# FIR TDF Compensation (Transposed / 3:2 Compressors)

Usa árboles de compresores 3:2 (Wallace/Dadda-like) para sumar las parciales,
mejorando el timing respecto al FIR convencional.

**Datos de ejemplo (dummy):**

| Recurso | Cantidad |
|---|---|
| LUTs | 210 |
| DSPs | 0 |
| FFs | 110 |
