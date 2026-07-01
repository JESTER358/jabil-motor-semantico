-- ============================================================================
-- DEMO DEL MOTOR SEMÁNTICO
-- Ver el motor en acción: entrada sucia → código normalizado
-- ============================================================================

-- ============================================================================
-- PARTE 1: ESTADO ACTUAL - Sin Motor (Lo que pasa ahora en Jabil)
-- ============================================================================

.print "╔════════════════════════════════════════════════════════════════════╗"
.print "║                    ANTES: SIN MOTOR SEMÁNTICO                      ║"
.print "║  Los operarios escriben descripciones inconsistentes, con typos    ║"
.print "╚════════════════════════════════════════════════════════════════════╝"
.print ""

SELECT 
    '1. Operario escribe: "atoramiento canula"' as PROBLEMA,
    'El sistema NO sabe si es código M1 St02' as RESULTADO
UNION ALL
SELECT
    '2. Otro escribe: "bowlfeder alarma"',
    'Podría ser M1 St02 también, pero el sistema no lo entiende'
UNION ALL
SELECT
    '3. Otro escribe: "sensor q falla" (typo)',
    'Sistema confundido, ¿qué código es?'
UNION ALL
SELECT
    '4. Base de datos termina con INCONSISTENCIAS',
    'Datos sucios → reportes Power BI incorrectos'
;

.print ""
.print "💥 PROBLEMA: Mucho trabajo manual limpiando datos"
.print ""

-- ============================================================================
-- PARTE 2: CON MOTOR SEMÁNTICO (Lo que hace el MVP)
-- ============================================================================

.print "╔════════════════════════════════════════════════════════════════════╗"
.print "║                 DESPUÉS: CON MOTOR SEMÁNTICO                       ║"
.print "║  El motor DETECTA automáticamente el código correcto               ║"
.print "╚════════════════════════════════════════════════════════════════════╝"
.print ""

-- Mostrar los clientes y sus líneas
.print "📍 CLIENTES REGISTRADOS:"
SELECT 
    id_cliente,
    nombre as CLIENTE,
    descripcion
FROM tbl_cliente
ORDER BY id_cliente;

.print ""
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""

-- Demo por cliente
.print "✨ DEMO CLIENTE: DEXCOM"
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""
.print "Códigos de falla registrados para DEXCOM:"
SELECT 
    codigo as CÓDIGO,
    descripcion_oficial as DESCRIPCIÓN,
    modulo as MÓDULO,
    estacion as ESTACIÓN
FROM tbl_codigo_falla
WHERE id_cliente = 1
LIMIT 7;

.print ""
.print "Sinónimos y variaciones registradas:"
SELECT 
    cf.codigo as CÓDIGO,
    eq.equivalencia as VARIACIÓN,
    eq.tipo_variacion as TIPO
FROM tbl_codigo_falla cf
JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE cf.id_cliente = 1
LIMIT 10;

.print ""
.print "🔍 EJEMPLOS DE NORMALIZACIÓN (DEXCOM):"
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""

-- Query de demostración: buscar matches para descripciones sucias
WITH test_dexcom AS (
    SELECT 'atoramiento canula' as descripcion_entrada, 1 as id_cliente
    UNION ALL SELECT 'sensor danado', 1
    UNION ALL SELECT 'bowlfeder alarma', 1
    UNION ALL SELECT 'desalineacion gripper', 1
)
SELECT 
    '1️⃣ ' || td.descripcion_entrada as "ENTRADA SUCIA",
    cf.codigo as "→ CÓDIGO DETECTADO",
    cf.descripcion_oficial as DESCRIPCIÓN,
    '✓' as MATCH
FROM test_dexcom td
JOIN tbl_codigo_falla cf ON cf.id_cliente = td.id_cliente
JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE LOWER(TRIM(eq.equivalencia)) = LOWER(TRIM(td.descripcion_entrada))
ORDER BY td.descripcion_entrada;

.print ""
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""
.print "✨ DEMO CLIENTE: 3M (RF COSMOS)"
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""

.print "Códigos de falla registrados para 3M:"
SELECT 
    codigo as CÓDIGO,
    descripcion_oficial as DESCRIPCIÓN
FROM tbl_codigo_falla
WHERE id_cliente = 2;

.print ""
.print "🔍 EJEMPLOS DE NORMALIZACIÓN (3M):"
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""

WITH test_3m AS (
    SELECT 'g1 overload' as descripcion_entrada, 2 as id_cliente
    UNION ALL SELECT 'sobre carga generador', 2
    UNION ALL SELECT 'corriente baja', 2
    UNION ALL SELECT 'arco supresor', 2
)
SELECT 
    '2️⃣ ' || t3m.descripcion_entrada as "ENTRADA SUCIA",
    cf.codigo as "→ CÓDIGO DETECTADO",
    cf.descripcion_oficial as DESCRIPCIÓN,
    '✓' as MATCH
FROM test_3m t3m
JOIN tbl_codigo_falla cf ON cf.id_cliente = t3m.id_cliente
JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE LOWER(TRIM(eq.equivalencia)) = LOWER(TRIM(t3m.descripcion_entrada))
ORDER BY t3m.descripcion_entrada;

.print ""
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""
.print "✨ DEMO CLIENTE: STRIKER (SAAC & TSA)"
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""

.print "Códigos de falla SAAC y TSA:"
SELECT 
    codigo as CÓDIGO,
    descripcion_oficial as DESCRIPCIÓN,
    tipo_falla as TIPO
FROM tbl_codigo_falla
WHERE id_cliente = 6
ORDER BY codigo;

.print ""
.print "🔍 EJEMPLOS DE NORMALIZACIÓN (STRIKER):"
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""

WITH test_striker AS (
    SELECT 'atoramiento nido' as descripcion_entrada, 6 as id_cliente
    UNION ALL SELECT 'fuga st2', 6
    UNION ALL SELECT 'fixture danada', 6
    UNION ALL SELECT 'elevador falla', 6
    UNION ALL SELECT 'motor conveyor', 6
)
SELECT 
    '3️⃣ ' || ts.descripcion_entrada as "ENTRADA SUCIA",
    cf.codigo as "→ CÓDIGO DETECTADO",
    cf.descripcion_oficial as DESCRIPCIÓN,
    '✓' as MATCH
FROM test_striker ts
JOIN tbl_codigo_falla cf ON cf.id_cliente = ts.id_cliente
JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE LOWER(TRIM(eq.equivalencia)) = LOWER(TRIM(ts.descripcion_entrada))
ORDER BY ts.descripcion_entrada;

.print ""
.print "╔════════════════════════════════════════════════════════════════════╗"
.print "║                         RESUMEN DEL MVP                            ║"
.print "╚════════════════════════════════════════════════════════════════════╝"
.print ""

SELECT 
    (SELECT COUNT(*) FROM tbl_cliente) as 'CLIENTES REGISTRADOS',
    (SELECT COUNT(*) FROM tbl_linea_produccion) as 'LÍNEAS DE PRODUCCIÓN',
    (SELECT COUNT(*) FROM tbl_codigo_falla) as 'CÓDIGOS DE FALLA',
    (SELECT COUNT(*) FROM tbl_equivalencias) as 'SINÓNIMOS/VARIACIONES'
;

.print ""
.print "📊 ESTADÍSTICAS POR CLIENTE:"
.print ""

SELECT 
    tc.nombre as CLIENTE,
    COUNT(DISTINCT tcf.codigo) as 'CÓDIGOS',
    COUNT(DISTINCT te.id_equivalencia) as 'SINÓNIMOS'
FROM tbl_cliente tc
LEFT JOIN tbl_codigo_falla tcf ON tc.id_cliente = tcf.id_cliente
LEFT JOIN tbl_equivalencias te ON tcf.id_codigo = te.id_codigo
GROUP BY tc.id_cliente, tc.nombre
ORDER BY tc.id_cliente;

.print ""
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
.print ""
.print "✅ BENEFICIOS DEL MOTOR:"
.print ""
.print "1. ⚡ AUTOMATIZACIÓN: Normaliza descripciones en tiempo real"
.print "2. 🎯 CONSISTENCIA: Un código oficial por falla"
.print "3. 📈 CALIDAD DE DATOS: Reportes Power BI precisos"
.print "4. ⏱️  AHORRO DE TIEMPO: No más limpieza manual"
.print "5. 🔍 TRAZABILIDAD: Historial de detecciones en tbl_captura_datos"
.print ""
.print "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
