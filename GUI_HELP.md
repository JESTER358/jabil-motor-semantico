# 🚀 Guía de la GUI Web - Solución de Problemas

## ¿Qué archivo abro?

### **Opción 1: motor-gui-lite.html** ⭐ RECOMENDADO (SIN CDN)
```bash
firefox motor-gui-lite.html
```

✅ **Ventajas:**
- NO necesita conexión a internet (para CDN)
- Funciona 100% offline
- Datos hardcodeados para demostración
- Carga instantánea
- SIN dependencias externas

❌ **Desventajas:**
- Datos demo (no es la BD completa)
- Pero es perfecto para DEMOSTRACIÓN

**MEJOR PARA:** Demostración a tu coach sin problemas

---

### **Opción 2: motor-gui.html** (CON SQL.js)
```bash
firefox motor-gui.html
```

✅ **Ventajas:**
- Carga la BD SQLite real (jabil_motor.db)
- Todos los 8 clientes, 31 códigos, 50+ sinónimos
- Motor semántico completo

⚠️ **Requiere:**
- Conexión a internet (para descargar sql.js desde CDN)
- Que `jabil_motor.db` esté en la misma carpeta

❌ **Si da error "wasm failed":**
1. Usa `motor-gui-lite.html` en su lugar
2. O intenta en otro navegador (Chrome en lugar de Firefox)
3. O espera 30 segundos y recarga

**MEJOR PARA:** Producción con todos los datos reales

---

## Errores Comunes

### Error: "Cargando base de datos... Error: both async and sync fetching of the wasm failed"

**Solución rápida:**
```bash
# Cierra y abre en otro navegador
firefox motor-gui.html  # Intenta Firefox
# Si falla, intenta Chrome:
google-chrome motor-gui.html

# O usa la versión LITE que NO necesita CDN:
firefox motor-gui-lite.html  ← ⭐ MEJOR
```

### Error: "No se encontró jabil_motor.db"

**Causas:**
- `jabil_motor.db` no está en la misma carpeta que `motor-gui.html`
- O está en una subcarpeta

**Solución:**
```bash
# Verifica que ambos archivos están aquí:
ls -la ~/Desktop/jabil-motor-semantico/
# Deberías ver:
# motor-gui.html
# jabil_motor.db
# motor-gui-lite.html
```

---

## ¿Cuál uso para presentar a mi coach?

**OPCIÓN A: Super seguro (RECOMENDADO)**
```bash
firefox ~/Desktop/jabil-motor-semantico/motor-gui-lite.html
```
- No hay riesgo de errores CDN
- Funciona 100% garantizado
- Demuestra el concepto perfectamente
- Datos suficientes para demo

**OPCIÓN B: Con todos los datos**
```bash
firefox ~/Desktop/jabil-motor-semantico/motor-gui.html
```
- Requiere internet (para sql.js)
- Si funciona, impresiona más (muestra BD completa)
- Si falla, tu presentación se arruina

**RECOMENDACIÓN:** Usa LITE para la demo oficial. Si sobra tiempo, abre FULL después.

---

## Funciones de la GUI

### Filtros (izquierda)
1. Selecciona **Cliente** (DEXCOM, 3M, STRIKER, etc.)
2. Se carga **Línea** automáticamente
3. (Opcional) Selecciona **Máquina**

### Búsqueda Semántica
1. Escribe la descripción sucia: "atoramiento canula"
2. AUTOMÁTICAMENTE aparecen 3 sugerencias ordenadas por confianza
3. Haz clic en la que quieres

### Guardar
1. Se selecciona automáticamente en panel derecho
2. Clic en [💾 Guardar]
3. Aparece en el historial

### Historial (derecha)
- Últimas 10 capturas
- Cliente, descripción, código, timestamp, confianza

### Estadísticas
- Total de capturas
- Confianza promedio

---

## Ejemplo Completo (Demo)

```
1. Abre: firefox motor-gui-lite.html
2. Selecciona Cliente: "DEXCOM"
3. Línea: "DEXCOM" (auto)
4. Escribe: "ator"
   → Aparecen sugerencias
5. Escribe: "amiento canula"
   → M1 St02 con 100% (coincidencia exacta)
6. Clic en "M1 St02"
7. Clic en [💾 Guardar]
8. Aparece en historial:
   "M1 St02 | atoramiento canula | 14:32 | 100%"
9. Repite con otros clientes:
   - "corriente baja" → G1 Corriente (3M)
   - "elevador falla" → AX1 LIF (STRIKER)
```

**Tiempo:** 2-3 minutos. Impresionante.

---

## ¿Por qué dos versiones?

**motor-gui-lite.html:**
- Datos hardcodeados (demo)
- SIN dependencias externas
- Funciona offline
- 100% garantizado

**motor-gui.html:**
- Conecta a la BD real via SQL.js
- Todos los clientes y códigos
- Requiere internet (para CDN)
- Más potente pero puede fallar

**Decisión para ti:**
- **Demo a coach:** LITE
- **Producción después:** FULL

---

## Navegadores Soportados

| Navegador | LITE | FULL |
|-----------|------|------|
| Chrome | ✅ | ✅ |
| Firefox | ✅ | ✅ (a veces falla CDN) |
| Safari | ✅ | ✅ |
| Edge | ✅ | ✅ |

**Si FULL falla, intenta LITE.**

---

## ¿Cómo distribuir después?

Para producción con tu coach:

1. Entrega `motor-gui-lite.html` + `jabil_motor.db` en la misma carpeta
2. Instrucción: "Abre motor-gui-lite.html en Firefox o Chrome"
3. Listo. No necesita servidor, internet, nada.

---

## Soporte

Si algo falla:
1. Intenta en otro navegador
2. Limpia caché del navegador (Ctrl+Shift+Del)
3. Usa motor-gui-lite.html en lugar de motor-gui.html
4. Verifica que jabil_motor.db está en la misma carpeta

---

**¡Dale! Estás listo para demostrar.** 🚀
