-- ============================================================================
-- MOTOR DE NORMALIZACIÓN - FUZZY MATCHING
-- Encuentra códigos de falla basado en descripciones sucias
-- ============================================================================

-- Función auxiliar: Levenshtein distance (distancia de edición)
-- Mide cuán diferentes son dos strings (0 = idéntico, mayor = más diferente)
-- En SQLite, esto es más básico pero funcional

-- ============================================================================
-- MÉTODO 1: BÚSQUEDA POR EQUIVALENCIAS EXACTAS
-- ============================================================================
-- Retorna el código cuando hay coincidencia exacta con una equivalencia registrada

CREATE VIEW v_busqueda_exacta AS
SELECT 
    cf.id_codigo,
    cf.codigo,
    cf.descripcion_oficial,
    cf.id_cliente,
    eq.equivalencia,
    1.0 as confianza,
    'EQUIVALENCIA EXACTA' as metodo
FROM tbl_codigo_falla cf
JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE eq.equivalencia IS NOT NULL;

-- ============================================================================
-- MÉTODO 2: BÚSQUEDA POR PALABRAS CLAVE (PARTIAL MATCH)
-- ============================================================================
-- Si la descripción de entrada contiene palabras de la descripción oficial

CREATE VIEW v_busqueda_parcial AS
SELECT 
    cf.id_codigo,
    cf.codigo,
    cf.descripcion_oficial,
    cf.id_cliente,
    cf.descripcion_oficial as equivalencia,
    0.75 as confianza,
    'COINCIDENCIA PARCIAL' as metodo
FROM tbl_codigo_falla cf;

-- ============================================================================
-- FUNCIÓN PRINCIPAL: NORMALIZAR DESCRIPCIÓN
-- ============================================================================
-- Recibe: descripción sucia (ej: "atoramiento canula")
-- Retorna: código, confianza, método de match

-- En SQLite no hay funciones propias, así que usamos queries complejas
-- Para producción en SQL Server, crear una Function o Stored Procedure

CREATE VIEW v_normalizacion_resultado AS
WITH descripcion_entrada AS (
    SELECT 
        'atoramiento canula' as descripcion_entrada,
        1 as id_cliente
    
    UNION ALL
    SELECT 'sensor danado', 6
    
    UNION ALL  
    SELECT 'bowlfeder alarma', 1
    
    UNION ALL
    SELECT 'elevador no sube', 6
    
    UNION ALL
    SELECT 'g1 overload', 2
    
    UNION ALL
    SELECT 'fixture rota', 6
    
    UNION ALL
    SELECT 'conveyor parado', 6
),
-- Búsqueda por equivalencia exacta (mayor confianza)
match_exacto AS (
    SELECT 
        de.descripcion_entrada,
        de.id_cliente,
        cf.codigo,
        cf.descripcion_oficial,
        1.0 as confianza,
        'EQUIVALENCIA EXACTA' as metodo,
        1 as prioridad
    FROM descripcion_entrada de
    JOIN tbl_codigo_falla cf ON cf.id_cliente = de.id_cliente
    JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
    WHERE LOWER(TRIM(eq.equivalencia)) = LOWER(TRIM(de.descripcion_entrada))
),
-- Búsqueda por palabra clave (match parcial)
match_parcial AS (
    SELECT 
        de.descripcion_entrada,
        de.id_cliente,
        cf.codigo,
        cf.descripcion_oficial,
        0.8 as confianza,
        'COINCIDENCIA PARCIAL' as metodo,
        2 as prioridad
    FROM descripcion_entrada de
    JOIN tbl_codigo_falla cf ON cf.id_cliente = de.id_cliente
    WHERE 
        -- La entrada contiene alguna palabra clave del código
        (LOWER(de.descripcion_entrada) LIKE '%' || LOWER(SUBSTR(cf.codigo, 1, 3)) || '%')
        OR (LOWER(de.descripcion_entrada) LIKE '%' || LOWER(SUBSTR(cf.descripcion_oficial, 1, 5)) || '%')
),
-- Búsqueda fuzzy (LIKE con wildcard)
match_fuzzy AS (
    SELECT 
        de.descripcion_entrada,
        de.id_cliente,
        cf.codigo,
        cf.descripcion_oficial,
        0.6 as confianza,
        'BÚSQUEDA FUZZY' as metodo,
        3 as prioridad
    FROM descripcion_entrada de
    JOIN tbl_codigo_falla cf ON cf.id_cliente = de.id_cliente
    WHERE LOWER(cf.descripcion_oficial) LIKE '%' || LOWER(de.descripcion_entrada) || '%'
),
-- Consolidar resultados (elegir el mejor match)
todos_matches AS (
    SELECT * FROM match_exacto
    UNION ALL
    SELECT * FROM match_parcial
    WHERE descripcion_entrada NOT IN (SELECT descripcion_entrada FROM match_exacto)
    UNION ALL
    SELECT * FROM match_fuzzy
    WHERE descripcion_entrada NOT IN (SELECT descripcion_entrada FROM match_exacto UNION SELECT descripcion_entrada FROM match_parcial)
)
SELECT 
    descripcion_entrada,
    codigo,
    descripcion_oficial,
    confianza,
    metodo,
    CASE 
        WHEN confianza >= 0.9 THEN 'ALTA'
        WHEN confianza >= 0.7 THEN 'MEDIA'
        ELSE 'BAJA'
    END as nivel_confianza
FROM todos_matches
ORDER BY descripcion_entrada, prioridad, confianza DESC;

-- ============================================================================
-- TABLA DE TESTING - Para ejecutar pruebas
-- ============================================================================

CREATE TABLE tbl_test_descripciones (
    id_test INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    descripcion_sucia VARCHAR(255) NOT NULL,
    codigo_esperado VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES tbl_cliente(id_cliente)
);

INSERT INTO tbl_test_descripciones (id_cliente, descripcion_sucia, codigo_esperado) VALUES
-- DEXCOM
(1, 'atoramiento canula', 'M1 St02'),
(1, 'sensor danado', 'M1 St04'),
(1, 'bowlfeder alarma', 'M1 St02'),
(1, 'desalineacion gripper', 'M1 St02'),
(1, 'transferencia error', 'M2 St04'),
-- 3M
(2, 'g1 overload', 'G1 Over Load'),
(2, 'sobre carga generador', 'G1 Over Load'),
(2, 'corriente baja', 'G1 Corriente de grid baja'),
(2, 'arco supresor', 'G1 Arco Supresor'),
(2, 'plate curre limite', 'G1 Plate Curre fuera de limite'),
-- STRIKER (SAAC)
(6, 'atoramiento nido', 'ND ATORAMIENTOS'),
(6, 'fuga st2', 'ST2 FUGAS'),
(6, 'fixture danada', 'ST2 FXT'),
(6, 'rechazo vision', 'SV4 RECHAZOS'),
-- STRIKER (TSA)
(6, 'elevador falla', 'AX1 LIF'),
(6, 'motor conveyor', 'AX1 CON'),
(6, 'presion baja', 'AX2 PRE');
