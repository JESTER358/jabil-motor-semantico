# 🚀 Motor Semántico Jabil - MVP

**Normalización automática de códigos de falla en líneas de producción**

---

## 📋 Descripción

Este MVP implementa un **motor semántico** que:

✅ Identifica automáticamente códigos de falla a partir de descripciones sucias/incompletas  
✅ Maneja typos, abreviaciones y variaciones  
✅ Mantiene historial de detecciones para auditoria  
✅ Integrable con Power BI / Power Apps  
✅ Escalable a SQL Server production  

### Problema que resuelve

**Actualmente en Jabil:**
- Operarios escriben descripciones de error libre (inconsistentes)
- Alguien debe limpiar manualmente los datos antes de reportes
- Múltiples variaciones del mismo error → datos inconsistentes
- Esto consume MUCHO tiempo

**Con el motor:**
- Descripción sucia → Código oficial automático
- Ejemplos:
  - "atoramiento canula" → `M1 St02`
  - "sensor danado" → `M1 St04`
  - "g1 overload" → `G1 Over Load`
  - "elevador falla" → `AX1 LIF`

---

## 📁 Estructura de Archivos

```
jabil-motor-semantico/
├── schema.sql           # Definición de tablas
├── populate_data.sql    # Datos de los 8 clientes
├── motor_normalizacion.sql  # Lógica de fuzzy matching
├── demo.sql             # Ejemplos ejecutables
├── run_mvp.sh           # Script para ejecutar todo
└── README.md            # Este archivo
```

---

## 🔧 Instalación y Ejecución

### Requisitos
- SQLite 3 (instalado por defecto en Linux/Mac)
- O SQL Server si estás en producción

### Opción 1: Ejecutar TODO en una línea (recomendado)

```bash
cd ~/Desktop/jabil-motor-semantico
sqlite3 jabil_motor.db < schema.sql && sqlite3 jabil_motor.db < populate_data.sql && sqlite3 jabil_motor.db < motor_normalizacion.sql && sqlite3 jabil_motor.db < demo.sql
```

### Opción 2: Paso a paso

```bash
# 1. Crear base de datos y schema
sqlite3 jabil_motor.db < schema.sql

# 2. Poblar con datos de los 8 clientes
sqlite3 jabil_motor.db < populate_data.sql

# 3. Crear el motor de normalización
sqlite3 jabil_motor.db < motor_normalizacion.sql

# 4. Ver la demo
sqlite3 jabil_motor.db < demo.sql
```

### Opción 3: Interactivo (para investigar)

```bash
sqlite3 jabil_motor.db

# Dentro de sqlite3:
> .read schema.sql
> .read populate_data.sql
> .read motor_normalizacion.sql
> SELECT * FROM tbl_cliente;
> SELECT * FROM tbl_codigo_falla WHERE id_cliente = 1;
```

---

## 📊 Esquema de Base de Datos

### Tablas Principales

#### `tbl_cliente`
```
id_cliente | nombre | descripcion
1          | DEXCOM | Línea de manufactura DEXCOM
2          | 3M     | Línea de productos 3M
...
```

#### `tbl_linea_produccion`
```
id_linea | id_cliente | nombre | descripcion
1        | 1          | DEXCOM | Línea principal DEXCOM
4        | 6          | SAAC 1 | Línea SAAC módulo 1
...
```

#### `tbl_maquina`
```
id_maquina | id_linea | nombre | tipo
1          | 1        | Módulo 1 - Cell 1 Check Empty Pallet | Máquina
...
```

#### `tbl_codigo_falla`
Almacena los códigos OFICIALES de falla
```
id_codigo | id_cliente | codigo | descripcion_oficial | modulo | estacion
2         | 1          | M1 St02| Falla por Carga de Canula Hub | 1 | St02
...
```

#### `tbl_equivalencias`
Sinónimos, typos, abreviaciones del código
```
id_equivalencia | id_codigo | equivalencia | tipo_variacion
5               | 2         | atoramiento canula | sinonimo
6               | 2         | atoramiento canula hub | variacion
...
```

#### `tbl_captura_datos`
Historial de detecciones (auditoria)
```
id_captura | id_maquina | id_cliente | descripcion_entrada | codigo_detectado | confianza_match | timestamp
1          | 5          | 1          | atoramiento canula  | M1 St02         | 1.0             | 2024-06-30...
...
```

---

## 🔍 Cómo funciona el Motor

### Estrategia de Matching (en orden de confianza)

1. **EQUIVALENCIA EXACTA** (Confianza: 1.0)
   - Busca coincidencia exacta en `tbl_equivalencias`
   - Ejemplo: "atoramiento canula" → `M1 St02` ✓

2. **COINCIDENCIA PARCIAL** (Confianza: 0.8)
   - Verifica si palabras clave del código/descripción aparecen en la entrada
   - Ejemplo: "elevador falla" contiene "elevador" → `AX1 LIF` ✓

3. **BÚSQUEDA FUZZY** (Confianza: 0.6)
   - LIKE con wildcards
   - Útil para typos menores
   - Ejemplo: "conveyor parado" LIKE `%conveyor%` → `AX1 CON`

---

## 📈 Ejemplos de Uso

### Ejemplo 1: DEXCOM
```sql
-- Entrada sucia
INPUT: "atoramiento canula"

-- Motor ejecuta:
SELECT codigo, descripcion_oficial, confianza
FROM tbl_codigo_falla cf
JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE LOWER(eq.equivalencia) = LOWER("atoramiento canula")
  AND cf.id_cliente = 1;

-- Output:
M1 St02 | Falla por Carga de Canula Hub | 1.0 ✓
```

### Ejemplo 2: 3M
```sql
INPUT: "g1 overload"
OUTPUT: G1 Over Load | Alarma Over Load | 1.0 ✓
```

### Ejemplo 3: STRIKER
```sql
INPUT: "elevador falla"
OUTPUT: AX1 LIF | Falla por elevador AX1 | 0.8 (parcial)

INPUT: "motor conveyor"
OUTPUT: AX1 CON | Falla por conveyor AX1 | 0.8 (parcial)
```

---

## 🔄 Integración con Power BI / Power Apps

### Opción 1: Power Apps (Recomendado para MVP)

En Power Apps, crear un formulario que:
1. Captura descripción de error
2. Llama al motor (SP o Query)
3. Muestra código sugerido
4. Usuario confirma o corrige
5. Guarda en `tbl_captura_datos`

```powerapps
// Pseudo-código Power Apps
OnSelect de botón "Detectar":
    Set(varCodigoDetectado, 
        SQL(
            "SELECT codigo FROM tbl_codigo_falla 
             WHERE id_cliente = @cliente 
             AND codigo IN (
                SELECT codigo FROM MOTOR WHERE descripcion = @entrada
             )"
        )
    );
    TextInput_Codigo.Value = varCodigoDetectado;
```

### Opción 2: Power BI (Reporting)

En Power BI, usar `tbl_captura_datos` para:
- Dashboard de códigos detectados vs. escritos
- Tasa de coincidencia por máquina/cliente
- Historial de falsos positivos para mejorar motor

---

## 🚀 Migración a SQL Server (Producción)

### Paso 1: Export desde SQLite
```bash
sqlite3 jabil_motor.db ".dump" > backup.sql
```

### Paso 2: Ajustar Sintaxis para SQL Server
- Cambiar `INTEGER PRIMARY KEY AUTOINCREMENT` → `INT PRIMARY KEY IDENTITY(1,1)`
- Cambiar funciones SQLite → funciones SQL Server
- Cambiar `LOWER(TRIM(...))` → `LOWER(LTRIM(RTRIM(...)))`

### Paso 3: Crear Stored Procedure en SQL Server

```sql
CREATE PROCEDURE sp_normalizar_codigo_falla
    @descripcion_entrada VARCHAR(255),
    @id_cliente INT
AS
BEGIN
    -- Búsqueda exacta
    SELECT TOP 1
        codigo,
        descripcion_oficial,
        1.0 as confianza,
        'EXACTA' as metodo
    FROM tbl_codigo_falla cf
    JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
    WHERE LOWER(LTRIM(RTRIM(eq.equivalencia))) = LOWER(LTRIM(RTRIM(@descripcion_entrada)))
      AND cf.id_cliente = @id_cliente;
    
    -- Búsqueda parcial si no encontró exacta
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT TOP 1
            codigo,
            descripcion_oficial,
            0.8 as confianza,
            'PARCIAL' as metodo
        FROM tbl_codigo_falla
        WHERE id_cliente = @id_cliente
          AND (LOWER(descripcion_oficial) LIKE '%' + LOWER(@descripcion_entrada) + '%'
               OR LOWER(codigo) LIKE '%' + LOWER(SUBSTRING(@descripcion_entrada, 1, 3)) + '%');
    END
END
```

### Paso 4: Conectar desde Power Apps
```
Data Source: SQL Server
Connection: [tu-servidor-jabil].database.windows.net
Database: Jabil_Produccion
Procedure: sp_normalizar_codigo_falla
```

---

## 📝 Próximos Pasos (Mejoras Futuras)

- [ ] Machine Learning para mejorar fuzzy matching
- [ ] Panel de "Falsos Negativos" para agregar nuevos sinónimos
- [ ] API REST para integración externa
- [ ] Webhooks para sincronizar datos en tiempo real
- [ ] Testing masivo contra descripciones reales
- [ ] OCR para capturar descripciones desde fotos

---

## 💡 Tips de Uso

### Agregar nuevo código/sinónimo
```sql
-- 1. Agregar código si no existe
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla)
VALUES (1, 'M1 St10', 'Nueva falla DEXCOM', 'Módulo 1', 'St10', 'Tipo');

-- 2. Agregar sinónimos/variaciones
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion)
VALUES (LAST_INSERT_ID(), 'nueva falla', 'sinonimo');
```

### Ver historial de detecciones
```sql
SELECT 
    descripcion_entrada,
    codigo_detectado,
    confianza_match,
    timestamp,
    (SELECT nombre FROM tbl_cliente WHERE id_cliente = tc.id_cliente) as cliente
FROM tbl_captura_datos tc
WHERE id_cliente = 1
ORDER BY timestamp DESC
LIMIT 100;
```

### Mejorar confianza del motor
```sql
-- Ver qué sinonimos están generando falsos positivos
SELECT eq.equivalencia, COUNT(*) as coincidencias
FROM tbl_captura_datos tc
JOIN tbl_equivalencias eq ON tc.codigo_detectado = ...
GROUP BY eq.equivalencia
HAVING coincidencias > 10;
```

---

## 📞 Soporte

Este MVP fue creado para demostración. En producción:
- Implementar logging detallado
- Crear monitores para falsos positivos
- Hacer backups regularmente
- Documentar cada cambio a equivalencias

---

**¡Listo para demostrarlo en Jabil!** 🎉

