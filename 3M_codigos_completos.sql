-- ============================================================
-- 3M: CODIGOS DE FALLA COMPLETOS
-- Generado desde: Codigo de Falla 3M y Acist (1).xlsx (hoja 3M)
-- Codigos preservados EXACTOS del origen (typos incluidos)
-- ============================================================

-- ============================================================
-- SECCION 01: RF COSMOS
-- ============================================================

-- RF Cosmos - Generador 1 (5 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(1, 'G1 Over Load', 'Alarma Over Load', '', 'RF Cosmos', 'Generador 1'),
(1, 'G1 Plate Curre fuera de limite', 'Alarma Plate Curre no llego a su limite', '', 'RF Cosmos', 'Generador 1'),
(1, 'G1 Arco Supresor', 'Alarma Arco Supresor', '', 'RF Cosmos', 'Generador 1'),
(1, 'G1 Corriente de grid baja', 'Alarma corriente de grid baja', '', 'RF Cosmos', 'Generador 1'),
(1, 'G1 Switch de cambio', 'Alarma Switch de cambio de ciclo dañado', '', 'RF Cosmos', 'Generador 1');

-- RF Cosmos - Nido 1 al 8 (5 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(2, 'ND Sobre sellado', 'Sobre sellado', '', 'RF Cosmos', 'Nido 1 al 8'),
(2, 'ND Sobre debil', 'Sellado debil', '', 'RF Cosmos', 'Nido 1 al 8'),
(2, 'ND Sobre roto', 'Sellado roto', '', 'RF Cosmos', 'Nido 1 al 8'),
(2, 'NDM Mandril dañado', 'Mandril dañado o desalineado', '', 'RF Cosmos', 'Nido 1 al 8'),
(2, 'NDB Buffer dañado', 'Buffer dañado', '', 'RF Cosmos', 'Nido 1 al 8');

-- RF Cosmos - Generador 2 (4 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(3, 'G2 Over Load', 'Alarma Over Load', '', 'RF Cosmos', 'Generador 2'),
(3, 'G2 Plate Curre fuera de limite', 'Alarma Plate Curre no llego a su limite', '', 'RF Cosmos', 'Generador 2'),
(3, 'G2 Arco Supresor', 'Alarma Arco Supresor', '', 'RF Cosmos', 'Generador 2'),
(3, 'G2 Corriente de grid baja', 'Alarma corriente de grid baja', '', 'RF Cosmos', 'Generador 2');

-- RF Cosmos - Dado de corte (1 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(4, 'DC Rebaba dura', 'Rebaba dura', '', 'RF Cosmos', 'Dado de corte');


-- ============================================================
-- SECCION 02: SELLADORA DE BOLSA
-- ============================================================

-- Selladora de Bolsa - Selladora (2 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(5, 'SB Sobre sellado', 'Sobre sellado', '', 'Selladora de Bolsa', 'Selladora'),
(5, 'SB Sobre debil', 'Sellado debil', '', 'Selladora de Bolsa', 'Selladora');


-- ============================================================
-- SECCION 03: PAD PRINTER
-- ============================================================

-- Pad Printer - Estampado (2 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(6, 'PP Ilegible', 'Impresion ilegible', '', 'Pad Printer', 'Estampado'),
(6, 'PP Pedal danado', 'Pedal no da senal de star', '', 'Pad Printer', 'Estampado');


-- ============================================================
-- SECCION 04: USON
-- ============================================================

-- Uson - Prueba de Fuga (2 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(7, 'PF Fuga', 'exceso de fuga', '', 'Uson', 'Prueba de Fuga'),
(7, 'PF Conector danado', 'Conector denado', '', 'Uson', 'Prueba de Fuga');


-- ============================================================
-- SECCION 05: HORNO
-- ============================================================

-- Horno - Curado (2 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(8, 'HC resistencia danada', 'Resistencia danada', '', 'Horno', 'Curado'),
(8, 'HC Thermocople danado', 'Thermocople danado', '', 'Horno', 'Curado');


-- ============================================================
-- SECCION 06: DISPENSADOR MEDICAL
-- ============================================================

-- Dispensador Medical - Dispensado (2 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(9, 'DM Falta de solvente', 'Falta de solvente', '', 'Dispensador Medical', 'Dispensado'),
(9, 'DM exceso de solvente', 'exceso de solbente', '', 'Dispensador Medical', 'Dispensado');


-- ============================================================
-- SECCION 07: UV
-- ============================================================

-- UV - Curado UV (3 fallas)
INSERT INTO m3_tipos_falla (estacion_id, codigo_unico, falla_comun, accion_correctiva, equipo, estacion) VALUES
(10, 'UV curado debil', 'curado debil', '', 'UV', 'Curado UV'),
(10, 'UV potencia baja', 'potencia fuera de rango', '', 'UV', 'Curado UV'),
(10, 'UV Fibra danada', 'Fibra danada', '', 'UV', 'Curado UV');

-- ============================================================
-- RESUMEN TOTAL
-- RF Cosmos: prefijos DC/G1/G2/ND/NDB/NDM (15 codigos)
-- Selladora de Bolsa: prefijos SB (2 codigos)
-- Pad Printer: prefijos PP (2 codigos)
-- Uson: prefijos PF (2 codigos)
-- Horno: prefijos HC (2 codigos)
-- Dispensador Medical: prefijos DM (2 codigos)
-- UV: prefijos UV (3 codigos)
-- TOTAL: 28 codigos
-- ============================================================
