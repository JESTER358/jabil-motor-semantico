# DEXCOM MOTOR SEMÁNTICO - INSTRUCCIONES PARA CLAUDE (WEB)

**IMPORTANTE: Leer ESTO primero. No mirar el código frontend.**

---

## 🎯 QUÉ ES EL MOTOR

El motor semántico es un **MOTOR DE NORMALIZACIÓN DE DATOS** que:

1. **Recibe**: Descripción sucia/pobre del operario (ej: "elevador falla", "AX1 lif", "motor parado")
2. **Procesa**: Busca el código estándar DEXCOM más cercano (ej: "AX1 LIF", "MTR STOP")
3. **Devuelve**: Código normalizado + confianza del match (100%, 75%, 50%)

---

## 📁 ESTRUCTURA DEL REPO

```
jabil-motor-semantico/
├── dexcom_motor_semantico.sql        ← LA LÓGICA DEL MOTOR (TSQL/SQL Server)
├── IMED_codigos_completos.sql        ← Motor IMED (mismo patrón)
├── 3M_codigos_completos.sql          ← Motor 3M (mismo patrón)
├── STRIKER_codigos_completos.sql     ← Motor STRIKER (mismo patrón)
├── motor-gui-lite.html               ← DEMO visual (IGNORE - solo visualización)
├── index.html                        ← Selector de motores (IGNORE - solo UI)
├── motor-imed.html                   ← Demo IMED (IGNORE - solo visualización)
├── motor-3m.html                     ← Demo 3M (IGNORE - solo visualización)
├── motor-striker.html                ← Demo STRIKER (IGNORE - solo visualización)
└── [archivos de documentación]

```

---

## ⚠️ IGNORAR ESTOS ARCHIVOS

- **.html** - Son demostraciones visuales en navegador. **NO SON PRODUCCIÓN.**
- **GitHub Pages** - Bloqueado por firewall Jabil. **NO USAR.**
- **index.html** - Es un selector visual. **NO ES LA LÓGICA.**

---

## ✅ ENFOCARSE EN ESTO

### El archivo PRINCIPAL:

**`dexcom_motor_semantico.sql`** (28 KB)

Este archivo contiene la lógica COMPLETA del motor en **T-SQL puro**:

```sql
-- PASO 1: Crear tabla con 223 códigos DEXCOM
CREATE TABLE tbl_dexcom_codigos (
    codigo_id INT PRIMARY KEY,
    codigo VARCHAR(50),
    descripcion VARCHAR(255),
    linea_id INT,
    equivalencias VARCHAR(500)
);

INSERT INTO tbl_dexcom_codigos VALUES
(1, 'AX1 LIF', 'Elevador Auxiliar 1 Falla', 1, 'ax1 lif|AX1LIF|elevador falla|elevator fail'),
(2, 'BIC CON', 'Conector Bicicleta Roto', 1, 'bic con|conector falla'),
... (223 total)

-- PASO 2: Crear función de matching (EXACTA > PARCIAL > FUZZY)
CREATE FUNCTION fn_normalizar_dexcom(
    @descripcion_cruda VARCHAR(500),
    @linea_id INT
) RETURNS TABLE AS
SELECT TOP 3
    codigo,
    descripcion,
    linea_id,
    CASE WHEN UPPER(TRIM(@descripcion_cruda)) = UPPER(codigo) THEN 'EXACTA'
         WHEN [match parcial] THEN 'PARCIAL'
         ELSE 'FUZZY' END AS tipo_match,
    CASE WHEN exacta THEN 100 WHEN parcial THEN 75 ELSE 50 END AS confianza_pct
FROM tbl_dexcom_codigos
WHERE [matching logic]
ORDER BY confianza DESC

-- PASO 3: Crear VIEW para Power BI
CREATE VIEW v_dexcom_downtime_normalizado AS
SELECT
    d.id,
    d.linea,
    d.descripcion_cruda AS [ANTES (Sucio)],
    n.codigo AS [DESPUÉS (Normalizado)],
    n.confianza_pct,
    d.minutos_downtime
FROM View_Downtime_All d
LEFT JOIN fn_normalizar_dexcom(d.Comments, d.LineId) n ON 1=1
```

---

## 🔄 FLUJO DE DATOS EN PRODUCCIÓN

```
SQL Server: View_Downtime_All
    ↓
    [raw data: "elevador falla", "mtr stop", "fl ax1"]
    ↓
fn_normalizar_dexcom() ← 223 códigos, matching logic
    ↓
    [normalized: "AX1 LIF" (100%), "MTR STOP" (100%), "FL AX1" (100%)]
    ↓
v_dexcom_downtime_normalizado
    ↓
Power BI (Dashboard con datos limpios)
```

---

## 📋 CÓDIGOS DEXCOM

**223 códigos únicos distribuidos en:**

- **TSA**: 73 códigos (línea de producción 1)
- **DSD05**: 86 códigos (línea de producción 2)
- **Fast Line**: 87 códigos (línea de producción 3)
- **Total**: 246 con equivalencias/sinónimos (13 compartidos entre líneas)

**Formato de código**: Descriptivo, 3-20 caracteres
- `AX1 LIF` - Elevador Auxiliar 1 Falla
- `BIC CON` - Conector Bicicleta Roto
- `MTR STOP` - Motor Parado
- `FL AX1` - Fast Line Auxiliar 1

**Matching strategy**:
1. EXACTA (100%) - `"AX1 LIF"` = `"AX1 LIF"`
2. PARCIAL (75%) - `"AX1 lif"` contiene `"AX1"` del código
3. FUZZY (50%) - Búsqueda aproximada de primeros 3 caracteres

---

## 🎯 LO QUE CLAUDE DEBE HACER

**SOLO con `dexcom_motor_semantico.sql`:**

1. ✅ Analizar la estructura de la tabla de códigos
2. ✅ Entender la lógica de matching (EXACTA/PARCIAL/FUZZY)
3. ✅ Crear equivalentes en T-SQL si se necesita (ya está completo)
4. ✅ Adaptar a otros clientes (IMED, 3M, STRIKER) - **MISMO PATRÓN**

**NO HACER:**

- ❌ No mirar HTML (no es producción)
- ❌ No usar GitHub Pages
- ❌ No confundir demo visual con lógica real
- ❌ No crear código nuevo - el motor YA EXISTE completo

---

## 💾 DÓNDE VA EN PRODUCCIÓN

**Servidor**: `MXTIJC1SQL01`
**Base de datos**: `JabilProd`
**Tabla fuente**: `View_Downtime_All` (datos sucios del piso)
**Tabla**: `tbl_dexcom_codigos` (223 códigos)
**Función**: `fn_normalizar_dexcom()` (matching logic)
**Vista**: `v_dexcom_downtime_normalizado` (datos limpios)

**Power BI** → Conecta a `v_dexcom_downtime_normalizado`

---

## 🚀 RESUMEN PARA CLAUDE

"El motor es un T-SQL puro. Está en `dexcom_motor_semantico.sql`.
Contiene:
- 223 códigos DEXCOM en tabla
- Función con matching EXACTA/PARCIAL/FUZZY
- Vista que Power BI consume

Todo lo demás (HTML, demos) es visual solamente.
El código está 100% listo para producción."

---

**Fecha**: 21 Julio 2026
**Estado**: ✅ LISTO PARA PRODUCCIÓN
**Stack**: T-SQL, SQL Server 2016+, Power BI

