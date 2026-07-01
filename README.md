# Motor Semántico DEXCOM

Herramienta para estandarización de códigos de downtime en líneas de producción Jabil DEXCOM.

## Características

- **247 códigos reales** desde operaciones DEXCOM (TSA, DSD05, Fast Line)
- **Motor semántico**: búsqueda inteligente que entiende sinónimos y variaciones
- **Historial de capturas**: registra todas las búsquedas y normalizaciones
- **Filtrado por línea**: solo ve códigos relevantes de la línea seleccionada

## Uso

Abrí directamente en el navegador: **[Live Demo](https://jester358.github.io/jabil-motor-semantico/)**

O localmente:
```bash
git clone https://github.com/JESTER358/jabil-motor-semantico.git
cd jabil-motor-semantico
# Abrí index.html en el navegador
```

## Cómo funciona

1. **Selecciona la línea** (TSA, DSD05, o Fast Line)
2. **Tipea la descripción de la falla** (ej: "sensor roto", "atoramiento conveyor")
3. **El motor** busca coincidencias por:
   - Equivalencias exactas (100% confianza)
   - Palabras clave (80-90% confianza)
   - Descripción parcial (50-70% confianza)
4. **Guardá** el código normalizado en el historial

## Datos

- **TSA**: 73 códigos (módulos AX1, AX2, AX3, BIC + generales)
- **DSD05**: 86 códigos (6 módulos + periféricos)
- **Fast Line**: 87 códigos (4 módulos + generales)

Total: **246 códigos** + **143 equivalencias semánticas**

## Arquitectura

Monolito HTML/CSS/JS funcional (MVP). Lógica SQL lista para integrar con SQL Server / Power Apps.

## Créditos

Desarrollado para Jabil | DEXCOM Manufacturing Line Optimization
