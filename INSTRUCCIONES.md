# Motor Semántico Jabil - Instrucciones de Uso

## Estado Actual

Base de datos actualizada con estructura real:
- 7 clientes
- 29 líneas de producción
- 18 códigos de falla
- 30+ equivalencias (sinónimos/variaciones)

---

## Cómo Usar

### Opción 1: GUI Web (Recomendado)

Abre en tu navegador:

```
firefox ~/Desktop/jabil-motor-semantico/motor-gui-lite.html
```

O desde el gestor de archivos, doble clic en `motor-gui-lite.html`.

Características:
- Filtros jerárquicos (Cliente > Línea > Máquina)
- Búsqueda semántica en tiempo real
- Top 3 sugerencias con confianza
- Historial y estadísticas
- Sin necesidad de internet

### Opción 2: Demo CLI

```bash
cd ~/Desktop/jabil-motor-semantico
bash run_mvp.sh
```

Muestra la demo completa en 30 segundos.

### Opción 3: Explorador Interactivo

```bash
bash explore_db.sh
```

Menú con 7 opciones para explorar la BD.

---

## Ejemplo de Uso

1. Abre motor-gui-lite.html
2. Selecciona Cliente: "DEXCOM"
3. Línea se auto-rellena: "DSD05" (u otra)
4. Escribe: "atoramiento canula"
5. Automáticamente aparecen sugerencias:
   - M1 St02 (100%)
   - M1 St04 (72%)
6. Clic en M1 St02
7. Clic en Guardar
8. Aparece en historial

---

## Solución de Problemas

### Error: "Cargando base de datos..."

Solución:
1. Cierra el navegador
2. Abre motor-gui-lite.html en Firefox o Chrome
3. Si sigue fallando, lee GUI_HELP.md

### Motor no encuentra una línea

Verifica que:
1. Escribiste el cliente correctamente
2. La línea está en la lista para ese cliente
3. Consulta ESTRUCTURA_ACTUAL.md para ver todas las líneas

---

## Archivos Principales

- motor-gui-lite.html: GUI web sin dependencias
- jabil_motor.db: Base de datos SQLite
- update_estructura.sql: Script con estructura actualizada
- ESTRUCTURA_ACTUAL.md: Lista de clientes y líneas
- GUI_HELP.md: Solución de problemas

---

## Para Presentar a tu Coach

1. Lee EXECUTIVE_SUMMARY.md (2 min)
2. Abre motor-gui-lite.html (10 min demo)
3. Muestra cómo funciona con un ejemplo real
4. Entrega la carpeta completa

---

## Próximos Pasos

1. Completar glosarios con códigos de falla reales de cada línea
2. Testing masivo con datos históricos
3. Migración a SQL Server
4. Integración con Power Apps

