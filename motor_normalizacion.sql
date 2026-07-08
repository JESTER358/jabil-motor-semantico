-- ============================================================
-- motor semantico dexcom estandarizacion de codigos de downtime
-- jabil tijuana | lineas: 1=fast line, 2=tsa, 3=dsd05
-- sql server 2016+ compatible
-- ============================================================
-- importante: la fuente de verdad es codigos_historial.
-- esa tabla es plana no hay joins a tbl_codigo_falla
-- ni a tbl_equivalencias desde aca. el motor busca directo
-- sobre descripcion con 3 niveles de confianza.
-- ============================================================


-- ============================================================
-- seccion 1: sp principal
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
    -- limpieza basica de la entrada antes de buscar.
    -- lower + trim para que "  sensor roto  " matchee igual
    -- que "sensor roto". sin esto el operador tiene que ser
    -- perfecto al tipear y eso nunca pasa en piso.
    -- --------------------------------------------------------
    DECLARE @desc_limpia VARCHAR(255);
    SET @desc_limpia = LOWER(LTRIM(RTRIM(@descripcion)));

    -- --------------------------------------------------------
    -- tabla temporal para acumular candidatos de las 3 
    -- estrategias y despues devolver el top 3 consolidado.
    -- usar tabla temp en lugar de multiples select + return
    -- porque power apps necesita un solo resultset limpio.
    -- --------------------------------------------------------
    CREATE TABLE #candidatos (
        codigo          VARCHAR(50),
        descripcion     VARCHAR(255),
        modulo          VARCHAR(100),
        confianza_pct   INT,
        metodo          VARCHAR(20)
    );

    -- --------------------------------------------------------
    -- estrategia 1: coincidencia exacta (confianza 100%)
    -- la descripcion del operador es identica (en minusculas)
    -- a la descripcion registrada en el historico.
    -- caso tipico: el operador copio el nombre del codigo.
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
    -- estrategia 2: coincidencia por palabras (confianza 75%)
    -- divide la entrada del operador por espacios y busca cada
    -- palabra en la columna descripcion por separado.
    -- util cuando el operador escribe "canula atorada" pero el
    -- codigo dice "atoramiento en canula" las palabras clave
    -- estan ahi aunque el orden o la forma morfologica difieran.
    --
    -- implementacion sin clr ni fts: string_split (sql 2016+)
    -- con like por cada token. si cualquier palabra matchea,
    -- el registro califica. filtramos tokens de 1 caracter
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
       -- excluir los que ya subieron por exacta para no duplicar
       AND NOT EXISTS (
             SELECT 1 FROM #candidatos c
             WHERE c.codigo = ch.codigo
       )
    ORDER BY ch.id_historial;

    -- --------------------------------------------------------
    -- estrategia 3: fuzzy con subcadena completa (confianza 50%)
    -- busca la descripcion limpia completa como substring
    -- dentro del campo descripcion. menos preciso que parcial
    -- pero captura casos donde el operador escribe una frase
    -- que esta contenida en la descripcion oficial.
    -- es la red de seguridad llega aqui lo que no matcheo
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
       -- solo los que no subieron en ninguna estrategia anterior
       AND codigo NOT IN (SELECT codigo FROM #candidatos)
    ORDER BY id_historial;

    -- --------------------------------------------------------
    -- devolver el top 3 global ordenado por confianza desc.
    -- si no hay nada, el select devuelve 0 filas power apps
    -- puede manejar eso mas limpio que una fila con nulls.
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
-- seccion 2: vista de referencia
-- para que el equipo pueda consultar el catalogo completo
-- sin tener que recordar los id_linea de memoria.
-- util tambien para depurar cuando el motor no matchea.
-- ============================================================

IF OBJECT_ID('dbo.v_referencia_dexcom', 'V') IS NOT NULL
    DROP VIEW dbo.v_referencia_dexcom;
GO

CREATE VIEW dbo.v_referencia_dexcom AS
SELECT
    -- nombre legible de la linea en lugar del id numerico
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
-- seccion 3: casos de prueba
-- ejecutar despues de poblar codigos_historial.
-- el id_linea va como int directo no mas lookup por nombre.
-- ============================================================

-- prueba 1: atoramiento en canula dsd05 (id=3)
-- esperado: match por exacta o parcial sobre "atoramiento" o "canula"
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'atoramiento canula',
    @linea_id    = 3;

-- prueba 2: sensor roto fast line (id=1)
-- esperado: match exacta si "sensor roto" esta textual, sino parcial
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'sensor roto',
    @linea_id    = 1;

-- prueba 3: elevador sin movimiento tsa (id=2)
-- el operador no usa la palabra exacta del codigo, confia en parcial
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'elevador no sube',
    @linea_id    = 2;

-- prueba 4: bowl feeder con alarma tsa (id=2)
-- "bowlfeeder" puede variar ("bowl feeder", "bowl-feeder") fuzzy lo captura
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'bowlfeeder alarma',
    @linea_id    = 2;

-- prueba 5: falta de material dsd05 (id=3)
-- frase corta y directa, deberia matchear exacta
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'falta material',
    @linea_id    = 3;

-- prueba 6: conveyor detenido fast line (id=1)
-- "parado" vs "detenido" parcial por "conveyor", fuzzy si no
EXEC dbo.sp_estandarizar_downtime
    @descripcion = 'conveyor parado',
    @linea_id    = 1;
