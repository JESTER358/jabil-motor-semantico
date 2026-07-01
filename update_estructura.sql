-- Limpiar datos incorrectos y cargar estructura REAL
DELETE FROM tbl_captura_datos;
DELETE FROM tbl_equivalencias;
DELETE FROM tbl_codigo_falla;
DELETE FROM tbl_maquina;
DELETE FROM tbl_linea_produccion;
DELETE FROM tbl_cliente;

-- Insertar clientes reales
INSERT INTO tbl_cliente (nombre, descripcion) VALUES
('3M', 'Cliente 3M'),
('DEXCOM', 'Cliente DEXCOM'),
('ACIST', 'Cliente ACIST'),
('STRYKER', 'Cliente STRYKER'),
('IMED', 'Cliente IMED'),
('MEDTRONIC', 'Cliente MEDTRONIC - PLANTA 1'),
('BSI', 'Cliente BSI');

-- Insertar líneas de 3M
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(1, 'RF Cosmos'),
(1, 'High Flow'),
(1, 'Standard Flow');

-- Insertar líneas de DEXCOM
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(2, 'DSD05'),
(2, 'TSA 7'),
(2, 'TSA 6'),
(2, 'TSA 1'),
(2, 'TSA 5'),
(2, 'Fastline P5'),
(2, 'TSA 3'),
(2, 'Semi Automatica 3'),
(2, 'DSD06-C1');

-- Insertar líneas de ACIST
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(3, 'ATP'),
(3, 'BT2000'),
(3, 'A2000');

-- Insertar líneas de STRYKER
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(4, 'SAAC 5'),
(4, 'SAAC 6'),
(4, 'SAAC 3'),
(4, 'SAAC 2'),
(4, 'SAAC 1'),
(4, 'SAAC 4'),
(4, 'Cement Mixer (Stryker)'),
(4, 'Shawpak'),
(4, 'Neptune');

-- Insertar líneas de IMED
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(5, 'IMED');

-- Insertar líneas de MEDTRONIC
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(6, 'Mustang'),
(6, 'Surgisleeve');

-- Insertar líneas de BSI
INSERT INTO tbl_linea_produccion (id_cliente, nombre) VALUES
(7, 'Asurys'),
(7, 'Furlow');

-- Insertar máquinas de ejemplo (algunas por línea)
-- 3M - RF Cosmos
INSERT INTO tbl_maquina (id_linea, nombre, tipo) VALUES
(1, 'Generador RF', 'Máquina'),
(1, 'Selladora', 'Máquina');

-- DEXCOM - DSD05
INSERT INTO tbl_maquina (id_linea, nombre, tipo) VALUES
(4, 'Cell 1', 'Máquina'),
(4, 'Cell 2', 'Máquina');

-- ACIST - ATP
INSERT INTO tbl_maquina (id_linea, nombre, tipo) VALUES
(11, 'ATP Principal', 'Máquina');

-- STRYKER - SAAC 1
INSERT INTO tbl_maquina (id_linea, nombre, tipo) VALUES
(18, 'SAAC 1 Módulo A', 'Máquina');

-- Insertar códigos de falla (manteniendo los que funcionaban)
-- 3M
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(1, 'G1 Over Load', 'Alarma Over Load Generador 1', 'Generador', '1', 'Sobrecarga'),
(1, 'G1 Plate Current', 'Alarma Plate Current fuera de límite', 'Generador', '1', 'Corriente'),
(1, 'G1 Arco Supresor', 'Alarma Arco Supresor', 'Generador', '1', 'Arco'),
(1, 'G1 Corriente Grid', 'Alarma corriente de grid baja', 'Generador', '1', 'Corriente');

-- DEXCOM
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(2, 'M1 St02', 'Falla por Carga de Canula Hub', 'Módulo 1', 'St02', 'Atoramiento'),
(2, 'M1 St04', 'Falla por Carga de Inner Hub', 'Módulo 1', 'St04', 'Atoramiento'),
(2, 'M1 St07', 'Falla por Carga de Outer Hub', 'Módulo 1', 'St07', 'Atoramiento'),
(2, 'M2 St04', 'Falla por transferencia de canula', 'Módulo 2', 'St04', 'Transferencia');

-- ACIST
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(3, 'ATP01', 'Error ATP general', 'ATP', 'Principal', 'Falla'),
(3, 'BT01', 'Error BT2000', 'BT2000', 'Principal', 'Falla');

-- STRYKER
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(4, 'ND ATORAMIENTOS', 'Atoramientos en nidos', 'SAAC', 'Index', 'Atoramiento'),
(4, 'ND FUGA', 'Fuga en nido', 'SAAC', 'Index', 'Fuga'),
(4, 'ST2 FUGAS', 'Fuga en estación 2', 'SAAC', 'Est2', 'Fuga'),
(4, 'ST2 FXT', 'Fixture dañada estación 2', 'SAAC', 'Est2', 'Fixture'),
(4, 'ST2 MECANISMO', 'Sensor/Cilindro/Mecanismo dañado Est2', 'SAAC', 'Est2', 'Mecanismo');

-- IMED
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(5, 'IM01', 'Error IMED general', 'IMED', 'Principal', 'Falla');

-- MEDTRONIC
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(6, 'MD01', 'Error Mustang', 'Mustang', 'Principal', 'Falla');

-- BSI
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(7, 'BS01', 'Error BSI general', 'BSI', 'Principal', 'Falla');

-- Insertar equivalencias (sinónimos)
-- 3M
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(1, 'overload', 'sinonimo'),
(1, 'sobre carga', 'variacion'),
(1, 'g1 sobrecarga', 'variacion'),
(2, 'plate current', 'sinonimo'),
(2, 'corriente placa', 'sinonimo'),
(3, 'arco supresor', 'sinonimo'),
(4, 'corriente baja', 'sinonimo'),
(4, 'grid baja', 'sinonimo');

-- DEXCOM
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(5, 'atoramiento canula', 'sinonimo'),
(5, 'canula atascada', 'sinonimo'),
(5, 'bowlfeder alarma', 'sinonimo'),
(6, 'atoramiento inner', 'sinonimo'),
(6, 'inner hub atascado', 'sinonimo'),
(7, 'atoramiento outer', 'sinonimo'),
(8, 'transferencia error', 'sinonimo');

-- STRYKER
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(13, 'atoramiento nido', 'sinonimo'),
(14, 'fuga nido', 'sinonimo'),
(15, 'fuga st2', 'sinonimo'),
(16, 'fixture rota', 'sinonimo'),
(17, 'sensor danado', 'sinonimo');
