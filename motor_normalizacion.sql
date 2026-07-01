-- ============================================================
-- MOTOR SEMANTICO DEXCOM -- Estandarizacion de Codigos de Downtime
-- Jabil Tijuana | Lineas: TSA, DSD05, Fast Line
-- SQL Server 2016+ compatible
-- ============================================================

-- ============================================================
-- SECCION 1: STORED PROCEDURE PRINCIPAL
-- ============================================================

-- Eliminar si ya existe (para poder recrear sin error)
IF OBJECT_ID('dbo.sp_normalizar_codigo_dexcom', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_normalizar_codigo_dexcom;
GO

CREATE PROCEDURE dbo.sp_normalizar_codigo_dexcom
    @descripcion    VARCHAR(255),   -- Texto libre del operador (ej: "atoramiento canula")
    @linea          VARCHAR(50)     -- Nombre de la linea: TSA, DSD05, Fast Line
AS
BEGIN
    SET NOCOUNT ON;

    -- --------------------------------------------------------
    -- Variables de trabajo
    -- --------------------------------------------------------
    DECLARE @id_linea       INT;
    DECLARE @desc_limpia    VARCHAR(255);

    -- Normalizar entrada: minusculas y sin espacios extra
    SET @desc_limpia = LOWER(LTRIM(RTRIM(@descripcion)));

    -- Resolver el id_linea a partir del nombre recibido
    -- DEXCOM es id_cliente = 1 en tbl_cliente
    SELECT @id_linea = lp.id_linea
    FROM tbl_linea_produccion lp
    INNER JOIN tbl_cliente c ON lp.id_cliente = c.id_cliente
    WHERE c.id_cliente = 1                          -- Solo DEXCOM
      AND LOWER(lp.nombre) = LOWER(@linea);

    -- Si la linea no existe en DEXCOM, retornar vacio con aviso
    IF @id_linea IS NULL
    BEGIN
        SELECT
            NULL           AS codigo,
            NULL           AS descripcion_oficial,
            0              AS confianza_pct,
            'LINEA_NO_ENCONTRADA' AS metodo;
        RETURN;
    END;

    -- --------------------------------------------------------
    -- ESTRATEGIA 1: Coincidencia exacta con equivalencias (100%)
    -- Busca si la descripcion del operador coincide exactamente
    -- con alguna equivalencia registrada para esa linea.
    -- --------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM tbl_codigo_falla   cf
        INNER JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
        INNER JOIN codigos_historial ch ON cf.id_codigo = ch.id
        WHERE ch.linea_id = @id_linea
          AND cf.id_cliente = 1
          AND LOWER(LTRIM(RTRIM(eq.equivalencia))) = @desc_limpia
    )
    BEGIN
        SELECT TOP 1
            cf.codigo,
            cf.descripcion_oficial,
            100             AS confianza_pct,
            'EXACTA'        AS metodo
        FROM tbl_codigo_falla   cf
        INNER JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
        INNER JOIN codigos_historial ch ON cf.id_codigo = ch.id
        WHERE ch.linea_id = @id_linea
          AND cf.id_cliente = 1
          AND LOWER(LTRIM(RTRIM(eq.equivalencia))) = @desc_limpia
        ORDER BY cf.id_codigo;

        RETURN;
    END;

    -- --------------------------------------------------------
    -- ESTRATEGIA 2: Coincidencia parcial con equivalencias (80%)
    -- Busca si alguna palabra de la descripcion oficial aparece
    -- contenida dentro del texto que escribio el operador.
    -- Se filtra ademas por la linea de produccion de DEXCOM.
    -- --------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM tbl_codigo_falla   cf
        INNER JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
        INNER JOIN codigos_historial ch ON cf.id_codigo = ch.id
        WHERE ch.linea_id = @id_linea
          AND cf.id_cliente = 1
          AND @desc_limpia LIKE '%' + LOWER(LTRIM(RTRIM(eq.equivalencia))) + '%'
    )
    BEGIN
        SELECT TOP 1
            cf.codigo,
            cf.descripcion_oficial,
            80              AS confianza_pct,
            'PARCIAL'       AS metodo
        FROM tbl_codigo_falla   cf
        INNER JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
        INNER JOIN codigos_historial ch ON cf.id_codigo = ch.id
        WHERE ch.linea_id = @id_linea
          AND cf.id_cliente = 1
          AND @desc_limpia LIKE '%' + LOWER(LTRIM(RTRIM(eq.equivalencia))) + '%'
        ORDER BY cf.id_codigo;

        RETURN;
    END;

    -- --------------------------------------------------------
    -- ESTRATEGIA 3: Fuzzy con wildcards sobre descripcion oficial (60%)
    -- Busca si la descripcion oficial del codigo contiene
    -- alguna subcadena de lo que escribio el operador.
    -- Es la red de seguridad -- menos precisa pero mas amplia.
    -- --------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM tbl_codigo_falla   cf
        INNER JOIN codigos_historial ch ON cf.id_codigo = ch.id
        WHERE ch.linea_id = @id_linea
          AND cf.id_cliente = 1
          AND LOWER(cf.descripcion_oficial) LIKE '%' + @desc_limpia + '%'
    )
    BEGIN
        SELECT TOP 1
            cf.codigo,
            cf.descripcion_oficial,
            60              AS confianza_pct,
            'FUZZY'         AS metodo
        FROM tbl_codigo_falla   cf
        INNER JOIN codigos_historial ch ON cf.id_codigo = ch.id
        WHERE ch.linea_id = @id_linea
          AND cf.id_cliente = 1
          AND LOWER(cf.descripcion_oficial) LIKE '%' + @desc_limpia + '%'
        ORDER BY cf.id_codigo;

        RETURN;
    END;

    -- --------------------------------------------------------
    -- Sin resultado: ninguna estrategia encontro coincidencia
    -- --------------------------------------------------------
    SELECT
        NULL            AS codigo,
        NULL            AS descripcion_oficial,
        0               AS confianza_pct,
        'SIN_MATCH'     AS metodo;
END;
GO


-- ============================================================
-- SECCION 2: VISTA DE REFERENCIA RAPIDA POR LINEA
-- Muestra todos los codigos activos de DEXCOM agrupados
-- por linea de produccion junto con sus equivalencias.
-- Util para consulta rapida y para depurar el motor.
-- ============================================================

IF OBJECT_ID('dbo.v_codigos_dexcom_por_linea', 'V') IS NOT NULL
    DROP VIEW dbo.v_codigos_dexcom_por_linea;
GO

CREATE VIEW dbo.v_codigos_dexcom_por_linea AS
SELECT
    lp.nombre           AS linea,
    cf.codigo,
    cf.descripcion_oficial,
    ch.modulo,
    eq.equivalencia,
    -- Cuenta cuantas equivalencias tiene cada codigo (referencia)
    COUNT(eq.id_equivalencia) OVER (PARTITION BY cf.id_codigo) AS total_equivalencias
FROM tbl_codigo_falla       cf
INNER JOIN tbl_cliente          c  ON cf.id_cliente  = c.id_cliente
INNER JOIN codigos_historial    ch ON cf.id_codigo   = ch.id
INNER JOIN tbl_linea_produccion lp ON ch.linea_id    = lp.id_linea
LEFT  JOIN tbl_equivalencias    eq ON cf.id_codigo   = eq.id_codigo
WHERE c.id_cliente = 1      -- Filtro DEXCOM
;
GO


-- ============================================================
-- SECCION 3: CASOS DE PRUEBA CON DATOS REALES DEXCOM
-- Ejecutar despues de poblar las tablas de referencia.
-- Resultados esperados basados en codigos de downtime activos.
-- ============================================================

-- Prueba 1: Atoramiento en canula -- linea DSD05
-- Esperado: M1 St02 | EXACTA o PARCIAL
EXEC dbo.sp_normalizar_codigo_dexcom
    @descripcion = 'atoramiento canula',
    @linea       = 'DSD05';

-- Prueba 2: Sensor roto -- linea Fast Line
-- Esperado: FL AX1 SS | EXACTA o PARCIAL
EXEC dbo.sp_normalizar_codigo_dexcom
    @descripcion = 'sensor roto',
    @linea       = 'Fast Line';

-- Prueba 3: Elevador sin movimiento -- linea TSA
-- Esperado: AX1 LIF | PARCIAL o FUZZY
EXEC dbo.sp_normalizar_codigo_dexcom
    @descripcion = 'elevador no sube',
    @linea       = 'TSA';

-- Prueba 4: Alarma en bowl feeder -- linea TSA
-- Esperado: AX1 BF SP | EXACTA o PARCIAL
EXEC dbo.sp_normalizar_codigo_dexcom
    @descripcion = 'bowlfeeder alarma',
    @linea       = 'TSA';

-- Prueba 5: Sin material en linea -- linea DSD05
-- Esperado: FMAT | EXACTA
EXEC dbo.sp_normalizar_codigo_dexcom
    @descripcion = 'falta material',
    @linea       = 'DSD05';

-- Prueba 6: Conveyor detenido -- linea Fast Line
-- Esperado: FL AX1 CON | PARCIAL o FUZZY
EXEC dbo.sp_normalizar_codigo_dexcom
    @descripcion = 'conveyor parado',
    @linea       = 'Fast Line';
