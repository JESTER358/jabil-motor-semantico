-- ============================================================
-- MOTOR SEMANTICO DEXCOM -- Estandarizacion de Codigos de Downtime
-- Jabil Tijuana | Lineas: 1=Fast Line, 2=TSA, 3=DSD05
-- SQL Server 2016+ compatible
-- ============================================================
-- IMPORTANTE: La fuente de verdad es codigos_historial.
-- Esa tabla es plana -- no hay JOINs a tbl_codigo_falla
-- ni a tbl_equivalencias desde aca. El motor busca directo
-- sobre descripcion con 3 niveles de confianza.
-- ============================================================


-- ============================================================
-- SECCION 1: SP PRINCIPAL
-- ============================================================

IF OBJECT_ID('dbo.sp_estandarizar_downtime', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_estandarizar_downtime;
GO

CREATE PROCEDURE dbo.sp_estandarizar_downtime
    @descripcion    VARCHAR(255),   -- Texto libre del operador ("atoramiento canula", etc.)
    @linea_id       INT             -- 1=Fast Line, 2=TSA, 3=DSD05
AS
BEGIN
    SET NOCOUNT ON;

    -- --------------------------------------------------------
    -- Limpieza basica de la entrada antes de buscar.
    -- LOWER + TRIM para que "  Sensor Roto  " matchee igual
    -- que "sensor roto". Sin esto el operador tiene que ser
    -- perfecto al tipear y eso nunca pasa en piso.
    -- --------------------------------------------------------
    DECLARE @desc_limpia VARCHAR(255);
    SET @desc_limpia = LOWER(LTRIM(RTRIM(@descripcion)));

    -- --------------------------------------------------------
    -- Tabla temporal para acumular candidatos de las 3 
    -- estrategias y despues devolver el TOP 3 consolidado.
    -- Usar tabla temp en lugar de multiples SELECT + RETURN
    -- porque Power Apps necesita un solo resultset limpio.
    -- --------------------------------------------------------
    CREATE TABLE #candidatos (
        codigo          VARCHAR(50),
        descripcion     VARCHAR(255),
        modulo          VARCHAR(100),
        confianza_pct   INT,
        metodo          VARCHAR(20)
    );

    -- --------------------------------------------------------
    -- ESTRATEGIA 1: Coincidencia exacta (confianza 100%)
    -- La descripcion del operador es identica (en minusculas)
    -- a la descripcion registrada en el historico.
    -- Caso tipico: el operador copio el nombre del codigo.
    -- --------------------------------------------------------
    INSERT INTO #candidatos (codigo, descripcion, modulo, confianza_pct, metodo)
    SELECT TOP 3
        codigo,
        descripcion,
        modulo,
        100,
        'EXACTA'
    FROM codigos_historial
    WHERE linea_id = @linea_id
      AND LOWER(LTRIM(RTRIM(descripcion))) = @desc_limpia
    ORDER BY id_historial;

    -- --------------------------------------------------------
    -- ESTRATEGIA 2: Coincidencia por palabras (confianza 75%)
    -- Divide la entrada del operador por espacios y busca cada
    -- palabra en la columna descripcion por separado.
    -- Util cuando el operador escribe "canula atorada" pero el
    -- codigo dice "atoramiento en canula" -- las palabras clave
    -- estan ahi aunque el orden o la forma morfologica difieran.
    --
    -- Implementacion sin CLR ni FTS: STRING_SPLIT (SQL 2016+)
    -- con LIKE por cada token. Si cualquier palabra matchea,
    -- el registro califica. Filtramos tokens de 1 caracter
    -- porque "y", "a", "e" son ruido puro.
    -- --------------------------------------------------------
    INSERT INTO #candidatos (codigo, descripcion, modulo, confianza_pct, metodo)
    SELECT DISTINCT TOP 3
        ch.codigo,
        ch.descripcion,
        ch.modulo,
        75,
        'PARCIAL'
    FROM codigos_historial ch
    INNER JOIN STRING_SPLIT(@desc_limpia, ' ') tokens
           ON LEN(TRIM(tokens.value)) > 1
          AND LOWER(ch.descripcion) LIKE '%' + TRIM(tokens.value) + '%'
    WHERE ch.linea_id = @linea_id
      -- Excluir los que ya subieron por EXACTA para no duplicar
      AND NOT EXISTS (
            SELECT 1 FROM #candidatos c
            WHERE c.codigo = ch.codigo
      )
    ORDER BY ch.id_historial;

    -- --------------------------------------------------------
    -- ESTRATEGIA 3: Fuzzy con subcadena completa (confianza 50%)
    -- Busca la descripcion limpia completa como substring
    -- dentro del campo descripcion. Menos preciso que PARCIAL
    -- pero captura casos donde el operador escribe una frase
    -- que esta contenida en la descripcion oficial.
    -- Es la red de seguridad -- llega aqui lo que no matcheo
    -- con exacta ni con keywords individuales.
    -- --------------------------------------------------------
    INSERT INTO #candidatos (codigo, descripcion, modulo, confianza_pct, metodo)
    SELECT TOP 3
        codigo,
        descripcion,
        modulo,
        50,
        'FUZZY'
    FROM codigos_historial
    WHERE linea_id = @linea_id
      AND LOWER(descripcion) LIKE '%' + @desc_limpia + '%'
      -- Solo los que no subieron en ninguna estrategia anterior
      AND codigo NOT IN (SELECT codigo FROM #candidatos)
    ORDER BY id_historial;

    -- --------------------------------------------------------
    -- Devolver el TOP 3 global ordenado por confianza desc.
    -- Si no hay nada, el SELECT devuelve 0 filas -- Power Apps
    -- puede manejar eso mas limpio que una fila con NULLs.
    -- --------------------------------------------------------
    SELECT TOP 3
        codigo,
        descripcion,
        modulo,
        confianza_pct,
        metodo
    FROM #candidatos
    ORDER BY confianza_pct DESC, codigo;

    DROP TABLE #candidatos;
END;
GO


-- ============================================================
-- SECCION 2: VISTA DE REFERENCIA
-- Para que el equipo pueda consultar el catalogo completo
-- sin tener que recordar los id_linea de memoria.
-- Util tambien para depurar cuando el motor no matchea.
-- ============================================================

IF OBJECT_ID('dbo.v_referencia_dexcom', 'V') IS NOT NULL
    DROP VIEW dbo.v_referencia_dexcom;
GO

CREATE VIEW dbo.v_referencia_dexcom AS
SELECT
    -- Nombre legible de la linea en lugar del id numerico
    CASE linea_id
        WHEN 1 THEN 'Fast Line'
        WHEN 2 THEN 'TSA'
        WHEN 3 THEN 'DSD05'
        ELSE        'Desconocida'
    END                 AS linea,
    linea_id,
    codigo,
    descripcion,
    modulo,
    id_historial
FROM codigos_historial;
GO


-- ============================================================
-- SECCION 3: CASOS DE PRUEBA
-- Ejecutar despues de poblar codigos_historial.
-- El id_linea va como INT directo -- no mas lookup por nombre.
-- ============================================================

-- Prueba 1: Atoramiento en canula -- DSD05 (id=3)
-- Esperado: match por EXACTA o PARCIAL sobre "atoramiento" o "canula"
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'atoramiento canula',
    @linea_id    = 3;

-- Prueba 2: Sensor roto -- Fast Line (id=1)
-- Esperado: match EXACTA si "sensor roto" esta textual, sino PARCIAL
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'sensor roto',
    @linea_id    = 1;

-- Prueba 3: Elevador sin movimiento -- TSA (id=2)
-- El operador no usa la palabra exacta del codigo, confia en PARCIAL
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'elevador no sube',
    @linea_id    = 2;

-- Prueba 4: Bowl feeder con alarma -- TSA (id=2)
-- "bowlfeeder" puede variar ("bowl feeder", "bowl-feeder") -- FUZZY lo captura
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'bowlfeeder alarma',
    @linea_id    = 2;

-- Prueba 5: Falta de material -- DSD05 (id=3)
-- Frase corta y directa, deberia matchear EXACTA
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'falta material',
    @linea_id    = 3;

-- Prueba 6: Conveyor detenido -- Fast Line (id=1)
-- "parado" vs "detenido" -- PARCIAL por "conveyor", FUZZY si no
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'conveyor parado',
    @linea_id    = 1;
