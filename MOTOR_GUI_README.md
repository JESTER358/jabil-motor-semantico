# 🎨 Motor Semántico Jabil - GUI Web (motor-gui.html)

**Interfaz web completamente funcional para captura de fallos y normalización en tiempo real**

---

## 📋 Overview

`motor-gui.html` es una **interfaz web moderna y responsiva** que permite a los operarios:
- Capturar descripciones sucias/incompletas de fallos
- Recibir sugerencias automáticas de códigos estándar (top 3)
- Ver niveles de confianza de cada coincidencia
- Guardar capturas a la base de datos
- Consultar historial de detecciones

**Características principales:**
- ✅ **Completamente offline** - Usa sql.js (SQLite en el navegador)
- ✅ **Sin dependencias externas** - Solo HTML5 + CSS3 + JavaScript vanilla
- ✅ **Responsive** - Funciona en desktop, tablet, mobile
- ✅ **Motor semántico avanzado** - Fuzzy matching con 3 estrategias
- ✅ **Dark theme profesional** - Colores Jabil (#4eb3e6 blue)
- ✅ **Real-time suggestions** - Actualiza mientras escribes

---

## 🚀 Cómo Usar

### Requisitos
- Navegador moderno (Chrome, Firefox, Edge, Safari)
- El archivo `jabil_motor.db` en la misma carpeta que `motor-gui.html`

### Instrucciones de Ejecución

1. **Coloca ambos archivos en la misma carpeta:**
   ```
   /home/omar/Desktop/jabil-motor-semantico/
   ├── motor-gui.html
   └── jabil_motor.db
   ```

2. **Abre el archivo en el navegador:**
   - Opción 1: Haz doble clic en `motor-gui.html`
   - Opción 2: Desde terminal:
     ```bash
     cd /home/omar/Desktop/jabil-motor-semantico
     # En Mac/Linux:
     open motor-gui.html
     # O:
     firefox motor-gui.html
     ```

3. **Comienza a capturar fallos:**
   - Selecciona **Cliente** (DEXCOM, 3M, STRIKER, etc.)
   - Selecciona **Línea** (se activa después de cliente)
   - Selecciona **Máquina** (opcional)
   - Escribe descripción en el campo de texto
   - Verás 3 sugerencias aparecer automáticamente
   - Haz clic en una sugerencia para seleccionarla
   - Haz clic en **Guardar Captura** para almacenarla

---

## 🎯 Ejemplo Paso a Paso

### Escenario: Capturar fallo DEXCOM

**Paso 1: Seleccionar Cliente**
```
[Cliente] → Selecciona "DEXCOM"
```

**Paso 2: Ver líneas disponibles**
```
[Línea] → Se activa automáticamente
         → Muestra "DEXCOM" (única línea para DEXCOM)
```

**Paso 3: Seleccionar máquina (opcional)**
```
[Máquina] → Se activa automáticamente
          → Muestra máquinas de la línea DEXCOM
```

**Paso 4: Escribir descripción**
```
[Campo de descripción] → Escribe: "atoramiento canula"
                      → Sistema busca automáticamente...
```

**Paso 5: Ver sugerencias en tiempo real**
```
Resultado #1:
┌─────────────────────────────────────┐
│ M1 St02                             │
│ Falla por Carga de Canula Hub       │
│ Coincidencia #1        Alta (100%)  │
└─────────────────────────────────────┘

Resultado #2:
┌─────────────────────────────────────┐
│ M1 St04                             │
│ Falla por Carga de Inner Hub        │
│ Coincidencia #2        Media (72%)  │
└─────────────────────────────────────┘

Resultado #3:
┌─────────────────────────────────────┐
│ M2 St04                             │
│ Falla por transferencia de canula   │
│ Coincidencia #3        Media (68%)  │
└─────────────────────────────────────┘
```

**Paso 6: Seleccionar sugerencia**
```
→ Haz clic en "M1 St02"
→ Se marca como seleccionada (borde verde)
→ Aparece en panel derecho: "Código Seleccionado"
```

**Paso 7: Guardar captura**
```
→ Haz clic en botón [💾 Guardar Captura]
→ Mensaje: "✅ Captura guardada correctamente"
→ Aparece inmediatamente en "Últimas 10 Capturas"
→ El campo se vacía, listo para siguiente captura
```

**Paso 8: Consultar historial**
```
En el panel derecho verás:
─────────────────────────────
M1 St02
"atoramiento canula"
14:32 • 30 jun 2024
Conf: 100%
─────────────────────────────
```

---

## 🧠 Cómo Funciona el Motor Semántico

El sistema usa **3 estrategias de matching** simultáneamente:

### Estrategia 1: Word Matching (40% peso)
```
Input:  "atoramiento canula"
Base:   "atoramiento canula hub"

Palabras que coinciden:
- "atoramiento" ✓
- "canula" ✓

Score: 2/2 = 100% → 40% * 1.0 = 0.40
```

### Estrategia 2: Fuzzy Matching (40% peso)
```
Input:  "atoramiento canula"
Base:   "atoramiento canula hub"

Levenshtein distance = 4 (caracteres de diferencia)
Max length = 27
Similarity = 1 - (4/27) = 0.85 → 40% * 0.85 = 0.34
```

### Estrategia 3: Description Matching (20% peso)
```
Input:  "atoramiento canula"
Base:   "Falla por Carga de Canula Hub" (descripción oficial)

Similarity = 0.65 → 20% * 0.65 = 0.13
```

### Score Final
```
0.40 + 0.34 + 0.13 = 0.87 → "Alta" (87%)
```

---

## 📊 Niveles de Confianza

El sistema clasifica las coincidencias en 3 niveles:

| Nivel | Rango | Color | Significado |
|-------|-------|-------|-------------|
| **Alta** | ≥ 85% | 🟢 Verde | Coincidencia muy probable |
| **Media** | 65-84% | 🟠 Naranja | Coincidencia probable, revisar |
| **Baja** | < 65% | 🔴 Rojo | Coincidencia poco probable |

---

## 📱 Interfaz de Usuario

### Layout Principal (Desktop)
```
┌─────────────────────────────────────────────────────────┐
│  ⚙️ Motor Semántico Jabil                              │
└─────────────────────────────────────────────────────────┘

┌────────────────────────────────┬──────────────────────┐
│                                │                      │
│  PANEL IZQUIERDO               │  PANEL DERECHO       │
│  ─────────────────────────────  │  ──────────────────  │
│                                │                      │
│  1. Filtros Jerárquicos        │  💾 Guardar Captura  │
│     [Cliente dropdown]         │                      │
│     [Línea dropdown]           │  ℹ️ Código Elegido   │
│     [Máquina dropdown]         │     (solo si        │
│                                │      seleccionaste)  │
│  2. Descripción de Falla       │                      │
│     [Text area]                │  📋 Historial       │
│     (Escribe aquí)             │     (Top 10)        │
│                                │                      │
│  3. Sugerencias (Top 3)        │  📈 Estadísticas    │
│     [Suggestion 1]             │                      │
│     [Suggestion 2]             │                      │
│     [Suggestion 3]             │                      │
│                                │                      │
└────────────────────────────────┴──────────────────────┘
```

### Layout Responsive (Tablet/Mobile)
```
En pantallas menores a 1024px, el layout se convierte en una columna:
[Filtros]
[Descripción]
[Sugerencias]
[Historial]
[Estadísticas]
```

---

## 🗄️ Datos Disponibles

### Clientes Cargados
- **DEXCOM** - Línea de dispositivos médicos
- **3M** - Equipos RF Cosmos
- **ASIST** - Línea ASIST
- **IMED** - Línea IMED
- **BOSTON SC** - Línea Boston
- **STRIKER** - Módulos SAAC y TSA
- **MEDTRONIC** - Línea Medtronic
- **CEMENT MIXER** - Línea Cement Mixer

### Códigos Configurados
Cada cliente tiene 3-10 códigos de falla configurados con múltiples sinónimos:

**DEXCOM (7 códigos):**
```
M1 St01 - Check Empty Pallet St01
M1 St02 - Falla por Carga de Canula Hub
M1 St03 - Check Cannula Hubs St03
M1 St04 - Falla por Carga de Inner Hub
M1 St05 - Check Inner Hub St05
M1 St07 - Falla por Carga de Outer Hub
M2 St04 - Falla por transferencia de canula
```

**3M (5 códigos):**
```
G1 Over Load - Alarma Over Load - Generador 1
G1 Plate Current - Alarma Plate Current fuera de límite
G1 Arc Suppressor - Alarma Arco Supresor
G1 Grid Current - Alarma corriente de grid baja
G2 Over Load - Alarma Over Load - Generador 2
```

**STRIKER (15 códigos):**
- SAAC: 9 códigos (nidos, estaciones, visión)
- TSA: 5 códigos (elevador, conveyor, magneto, presión, sistema BIC)

---

## 🔌 Detalles Técnicos

### Arquitectura
```
motor-gui.html
├── HTML Structure (DOM)
├── CSS Styling (Dark theme responsive)
└── JavaScript Logic
    ├── sql.js Integration (In-browser SQLite)
    ├── Semantic Matching Engine
    │   ├── Levenshtein Distance
    │   ├── Word Boundary Matching
    │   └── Fuzzy Scoring
    ├── Database Operations
    │   ├── Query (SELECT)
    │   └── Execute (INSERT)
    └── UI Controllers
        ├── Dropdown Population
        ├── Real-time Suggestions
        ├── History Update
        └── Statistics
```

### Librerías Externas
- **sql.js** (CDN): https://sql.js.org/dist/sql-wasm.js
  - Permite ejecutar SQLite en el navegador
  - Tamaño: ~500KB
  - Sin servidor necesario

### Almacenamiento
- **Donde se guardan los datos**: En la tabla `tbl_captura_datos` dentro de `jabil_motor.db`
- **Persistencia**: Los cambios se guardan directamente en el archivo .db en disco
- **Sincronización**: No hay sincronización automática si cambias el archivo mientras está abierto
- **Respaldo**: Haz backup regular de `jabil_motor.db`

---

## ⚙️ Configuración Avanzada

### Ajustar Umbrales de Confianza

En el código JavaScript, busca la sección `CONFIGURATION` y modifica:

```javascript
app.MIN_CONFIDENCE_THRESHOLD: 0.4,    // Mínima confianza para mostrar
app.FUZZY_THRESHOLD: 0.5,             // Umbral de similitud fuzzy
app.TOP_SUGGESTIONS: 3,               // Cuántas sugerencias mostrar
```

### Cambiar Colores del Tema

En la sección `<style>`, busca las variables de color:

```css
--primary: #4eb3e6;     /* Azul Jabil */
--success: #27ae60;     /* Verde */
--danger: #e74c3c;      /* Rojo */
--bg-dark: #0f1419;     /* Fondo oscuro */
--border: #2d5a7b;      /* Bordes */
```

---

## 🐛 Troubleshooting

### Problema: "No se encontró jabil_motor.db"
**Solución:**
- Verifica que ambos archivos estén en la misma carpeta
- Revisa el nombre exacto del archivo (sensible a mayúsculas)
- Abre las DevTools (F12) y mira la consola para mensajes de error

### Problema: "No se cargan sugerencias"
**Solución:**
- Verifica que seleccionaste un cliente
- Escribe al menos 2 caracteres
- Abre la consola (F12) y busca errores

### Problema: "Las capturas no se guardan"
**Solución:**
- Verifica que seleccionaste cliente y código
- Revisa que el navegador permite escribir en el disco
- En algunos navegadores/sistemas, necesitas guardar el archivo como copia local primero

### Problema: Interfaz se ve rota/desalineada
**Solución:**
- Recarga la página (Ctrl+F5 o Cmd+Shift+R)
- Limpia el caché del navegador
- Prueba en otro navegador

---

## 📊 Estadísticas en Tiempo Real

El panel derecho muestra:
- **Capturas guardadas**: Total de registros en `tbl_captura_datos`
- **Cliente seleccionado**: Nombre del cliente actual
- **Confianza promedio**: Promedio de `confianza_match` para todas las capturas

Se actualiza automáticamente al:
- Cambiar de cliente
- Guardar una nueva captura

---

## 💾 Exportar Historial

Para descargar el historial completo:

1. Abre las DevTools (F12)
2. En la consola, ejecuta:
   ```javascript
   const data = queryDB('SELECT * FROM tbl_captura_datos ORDER BY timestamp DESC');
   console.table(data);
   // Copia, pega en Excel
   ```

O usa una herramienta como **SQLite Browser** para explorar `jabil_motor.db` directamente.

---

## 🔐 Notas de Seguridad

- ✅ **Completamente local**: No hay conexión a servidores externos (excepto CDN sql.js)
- ✅ **Sin registro**: No se recopila datos de usuario
- ⚠️ **Datos en memoria**: Cambios en el navegador se guardan en el disco, pero si cierras sin guardar se pierden

---

## 📝 Próximas Mejoras (Roadmap)

- [ ] Exportar historial a CSV/Excel
- [ ] Gráficos de estadísticas (Chart.js)
- [ ] Búsqueda en historial (filtros adicionales)
- [ ] Modo oscuro/claro (toggle)
- [ ] Caché de equivalencias para rendimiento
- [ ] Sincronización con servidor (opcional)
- [ ] Mobile app (Electron/PWA)
- [ ] Integración con Power Apps/Power BI

---

## 📞 Soporte Técnico

**Si encuentras problemas:**

1. Abre la consola (F12)
2. Copia los mensajes de error
3. Verifica que `jabil_motor.db` está en la misma carpeta
4. Intenta en otro navegador
5. Si persiste, haz backup y regenera la DB:
   ```bash
   cd /home/omar/Desktop/jabil-motor-semantico
   rm jabil_motor.db
   sqlite3 jabil_motor.db < schema.sql
   sqlite3 jabil_motor.db < populate_data.sql
   ```

---

## 📄 Licencia & Atribución

- Creado para: **Jabil Circuit**
- Motor Semántico: Fuzzy matching con Levenshtein distance
- Interfaz: HTML5 + CSS3 + JavaScript vanilla
- Database: SQLite + sql.js

---

**¡Listo para usar!** 🚀

Abre `motor-gui.html` en tu navegador y comienza a capturar fallos.
