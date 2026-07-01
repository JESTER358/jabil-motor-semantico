# ⚡ Quick Start - Motor GUI

## 1️⃣ Abre el archivo
```bash
cd /home/omar/Desktop/jabil-motor-semantico
# Haz doble clic en motor-gui.html O:
firefox motor-gui.html
```

**Asegúrate que ambos archivos están en la misma carpeta:**
- ✓ `motor-gui.html`
- ✓ `jabil_motor.db`

---

## 2️⃣ Selecciona Cliente
```
[Cliente] → DEXCOM
```

---

## 3️⃣ Escribe una falla
```
[Descripción] → "atoramiento canula"
```

---

## 4️⃣ Verás sugerencias automáticas

```
✓ M1 St02 (Alta 100%)
✓ M1 St04 (Media 72%)
✓ M2 St04 (Media 68%)
```

---

## 5️⃣ Selecciona & Guarda
```
Haz clic en "M1 St02" → [💾 Guardar] → ✅ Listo
```

---

## 📝 Ejemplos para Probar

| Cliente | Descripción | Código Esperado |
|---------|-------------|-----------------|
| DEXCOM | atoramiento canula | M1 St02 |
| DEXCOM | inner hub atascado | M1 St04 |
| 3M | g1 overload | G1 Over Load |
| 3M | corriente baja | G1 Corriente de grid baja |
| STRIKER | elevador falla | AX1 LIF |
| STRIKER | conveyor parado | AX1 CON |

---

## 🎯 Que Esperar

- ✅ Sugerencias en **tiempo real** mientras escribes
- ✅ **3 mejores coincidencias** con confianza %
- ✅ Historial de **últimas 10 capturas** (por cliente)
- ✅ Estadísticas de **confianza promedio**
- ✅ **Completamente offline** - sin internet necesario

---

## 🐛 Algo no funciona?

1. Abre DevTools (F12) y mira la consola
2. Recarga la página (Ctrl+F5)
3. Verifica que `jabil_motor.db` exista en la carpeta
4. Intenta en otro navegador (Chrome, Firefox)

---

## 📊 Panel de Información

### Lado Izquierdo (Main)
- Filtros jerárquicos
- Campo de descripción
- Sugerencias en vivo

### Lado Derecho (Sidebar)
- Botón guardar
- Código seleccionado
- Historial últimas 10
- Estadísticas globales

---

## 💾 Dónde se guardan los datos?

Los registros se guardan en la tabla `tbl_captura_datos` dentro de `jabil_motor.db`.

Para ver el historial en SQL:
```bash
sqlite3 jabil_motor.db "SELECT * FROM tbl_captura_datos LIMIT 10;"
```

---

## ⚡ Shortcuts

| Acción | Atajo |
|--------|-------|
| Guardar | Ctrl+Enter (en campo descripción) |
| Recargar DB | F5 |
| DevTools | F12 |

---

🚀 **¡A capturar fallos!**
