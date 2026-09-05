# 09 - Decisiones de Diseño

Ejemplo de cómo documentar decisiones (formato sugerido):

## Decisión: Exclusión de BPS standalone para 64-QAM
**Contexto:** BPS standalone excede los recursos disponibles en la FPGA target.
**Decisión:** Se descarta como opción viable, justificado por costo de
implementación en hardware, no por costo computacional teórico.
**Alternativas consideradas:** pilot-aided CPR, DD-PLL con paralelismo.
