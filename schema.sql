-- ============================================================================
-- MOTOR SEMÁNTICO JABIL - SCHEMA SQL
-- Normalización de códigos de falla en líneas de producción
-- ============================================================================

-- Tabla de clientes
CREATE TABLE IF NOT EXISTS tbl_cliente (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- Tabla de líneas de producción
CREATE TABLE IF NOT EXISTS tbl_linea_produccion (
    id_linea INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    FOREIGN KEY (id_cliente) REFERENCES tbl_cliente(id_cliente),
    UNIQUE(id_cliente, nombre)
);

-- Tabla de máquinas/equipos
CREATE TABLE IF NOT EXISTS tbl_maquina (
    id_maquina INTEGER PRIMARY KEY AUTOINCREMENT,
    id_linea INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    descripcion VARCHAR(255),
    FOREIGN KEY (id_linea) REFERENCES tbl_linea_produccion(id_linea),
    UNIQUE(id_linea, nombre)
);

-- Tabla de códigos de falla estándar
CREATE TABLE IF NOT EXISTS tbl_codigo_falla (
    id_codigo INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    descripcion_oficial VARCHAR(255) NOT NULL,
    modulo VARCHAR(100),
    estacion VARCHAR(100),
    tipo_falla VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES tbl_cliente(id_cliente),
    UNIQUE(id_cliente, codigo)
);

-- Tabla de equivalencias (sinónimos, variaciones, typos)
CREATE TABLE IF NOT EXISTS tbl_equivalencias (
    id_equivalencia INTEGER PRIMARY KEY AUTOINCREMENT,
    id_codigo INTEGER NOT NULL,
    equivalencia VARCHAR(255) NOT NULL,
    tipo_variacion VARCHAR(50), -- 'typo', 'abreviacion', 'sinonimo', 'variacion'
    FOREIGN KEY (id_codigo) REFERENCES tbl_codigo_falla(id_codigo)
);

-- Tabla de capturas de datos (historial)
CREATE TABLE IF NOT EXISTS tbl_captura_datos (
    id_captura INTEGER PRIMARY KEY AUTOINCREMENT,
    id_maquina INTEGER,
    id_cliente INTEGER NOT NULL,
    descripcion_entrada VARCHAR(255) NOT NULL,
    codigo_detectado VARCHAR(50),
    confianza_match REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_maquina) REFERENCES tbl_maquina(id_maquina),
    FOREIGN KEY (id_cliente) REFERENCES tbl_cliente(id_cliente)
);

-- Tabla de códigos por línea (modelo flat para carga desde Excel)
CREATE TABLE IF NOT EXISTS codigos_historial (
    id_historial INTEGER PRIMARY KEY AUTOINCREMENT,
    linea_id INTEGER NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    modulo VARCHAR(100),
    FOREIGN KEY (linea_id) REFERENCES tbl_linea_produccion(id_linea)
);

-- Índices para optimización
CREATE INDEX IF NOT EXISTS idx_linea_cliente ON tbl_linea_produccion(id_cliente);
CREATE INDEX IF NOT EXISTS idx_maquina_linea ON tbl_maquina(id_linea);
CREATE INDEX IF NOT EXISTS idx_codigo_cliente ON tbl_codigo_falla(id_cliente);
CREATE INDEX IF NOT EXISTS idx_equivalencia_codigo ON tbl_equivalencias(id_codigo);
CREATE INDEX IF NOT EXISTS idx_captura_cliente ON tbl_captura_datos(id_cliente);
CREATE INDEX IF NOT EXISTS idx_captura_maquina ON tbl_captura_datos(id_maquina);
CREATE INDEX IF NOT EXISTS idx_historial_linea ON codigos_historial(linea_id);
