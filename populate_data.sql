-- ============================================================================
-- POBLACIÓN DE DATOS - 8 CLIENTES Y SUS GLOSARIOS
-- ============================================================================

-- INSERTAR CLIENTES
INSERT INTO tbl_cliente (nombre, descripcion) VALUES
('DEXCOM', 'Línea de manufactura de dispositivos médicos DEXCOM'),
('3M', 'Línea de productos 3M con equipos RF Cosmos'),
('ASIST', 'Línea ASIST - Encargado 1'),
('IMED', 'Línea IMED - Encargado 4'),
('BOSTON SC', 'Línea Boston SC - Encargado 1'),
('STRIKER', 'Línea STRIKER con módulos SAAC y TSA'),
('MEDTRONIC', 'Línea MEDTRONIC - Encargado 3'),
('CEMENT MIXER', 'Línea CEMENT MIXER - Encargado 3');

-- ============================================================================
-- CLIENTE: DEXCOM
-- ============================================================================
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(1, 'DSD05', 'Línea DSD05 - DEXCOM'),
(1, 'TSA', 'Línea TSA - DEXCOM'),
(1, 'Fast Line', 'Línea Fast Line - DEXCOM');

-- Máquinas DSD05
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(1, 'Cell 1 - Load/Check', 'Célula', 'Módulo 1 - Carga y verificación de hubs'),
(1, 'Cell 2 - Cannula', 'Célula', 'Módulo 2 - Ensamble de cánula y aguja'),
(1, 'Cell 3 - Inner Hub', 'Célula', 'Módulo 3 - Inner Hub assembly'),
(1, 'Cell 4 - Syringe', 'Célula', 'Módulo 4 - Jeringa y occlusion'),
(1, 'Cell 5 - DH/CB', 'Célula', 'Módulo 5 - Hub S/A press'),
(1, 'Cell 6 - Patch', 'Célula', 'Módulo 6 - Parche y sellado'),
(1, 'Tray Handler', 'Carga', 'Load/Unload Tray Handler'),
(1, 'Periféricos', 'General', 'Equipos periféricos DSD05');

-- Máquinas TSA
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(2, 'AX1', 'Módulo', 'Módulo AX1 - Stripper Plate'),
(2, 'AX2', 'Módulo', 'Módulo AX2 - Needle Carriage'),
(2, 'AX3', 'Módulo', 'Módulo AX3 - Inner Housing'),
(2, 'BIC', 'Módulo', 'Módulo BIC'),
(2, 'Periféricos TSA', 'General', 'Equipos periféricos TSA');

-- Máquinas Fast Line
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(3, 'FL AX1', 'Módulo', 'Fast Line Módulo AX1 - Stripper Plate'),
(3, 'FL AX2', 'Módulo', 'Fast Line Módulo AX2 - Needle Carriage'),
(3, 'FL AX3', 'Módulo', 'Fast Line Módulo AX3 - Inner Housing'),
(3, 'FL AX4', 'Módulo', 'Fast Line Módulo AX4 - BIC'),
(3, 'FL Periféricos', 'General', 'Fast Line equipos periféricos');

-- Códigos de falla DSD05 (sample representativo)
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(1, 'M1 St01', 'Check Empty Pallet St01', '1', 'St01', 'Verificación'),
(1, 'M1 St02', 'Falla por Carga de Canula Hub', '1', 'St02', 'Atoramiento del Canula Hub'),
(1, 'M1 St03', 'Check Cannula Hubs St03', '1', 'St03', 'Verificación'),
(1, 'M1 St04', 'Falla por Carga de Inner Hub', '1', 'St04', 'Atoramiento del Inner Hub'),
(1, 'M1 St05', 'Check Inner Hub St05', '1', 'St05', 'Verificación'),
(1, 'M1 St07', 'Falla por Carga de Outer Hub', '1', 'St07', 'Atoramiento del Outer Hub'),
(1, 'M2 St04', 'Falla por transferencia de canula', '2', 'St04', 'Material');

INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
-- M1 St02
(2, 'atoramiento canula', 'sinonimo'),
(2, 'atoramiento canula hub', 'variacion'),
(2, 'canula atascada', 'sinonimo'),
(2, 'bowlfeder alarma', 'sinonimo'),
(2, 'desalineacion inline', 'variacion'),
(2, 'desalineacion p&p', 'variacion'),
(2, 'falla sensores st02', 'variacion'),
-- M1 St04
(4, 'atoramiento inner', 'sinonimo'),
(4, 'inner hub atascado', 'sinonimo'),
(4, 'bowlfeder alarmado', 'variacion'),
-- M2 St04
(7, 'falla transferencia canula', 'sinonimo'),
(7, 'transferencia error', 'variacion'),
(7, 'material error', 'sinonimo');

-- ============================================================================
-- CLIENTE: 3M (RF COSMOS)
-- ============================================================================
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(2, 'RF COSMOS', 'Línea de equipos RF Cosmos');

INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(2, 'Generador 1', 'Generador', 'Generador de RF'),
(2, 'Generador 2', 'Generador', 'Generador de RF'),
(2, 'Selladora de Bolsa', 'Selladora', 'Máquina de sellado'),
(2, 'Pad Printer', 'Impresora', 'Impresora de pads'),
(2, 'Uson', 'Equipo', 'Sistema Uson'),
(2, 'Horno', 'Horno', 'Horno de curado'),
(2, 'Dispensador Medical', 'Dispensador', 'Dispensador médico'),
(2, 'UV', 'Lámpara', 'Lámpara UV');

INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(2, 'G1 Over Load', 'Alarma Over Load - Generador 1', 'Generador', '1', 'Sobrecarga'),
(2, 'G1 Plate Curre fuera de limite', 'Alarma Plate Current fuera de límite', 'Generador', '1', 'Corriente'),
(2, 'G1 Arco Supresor', 'Alarma Arco Supresor', 'Generador', '1', 'Arco'),
(2, 'G1 Corriente de grid baja', 'Alarma corriente de grid baja', 'Generador', '1', 'Corriente'),
(2, 'G2 Over Load', 'Alarma Over Load - Generador 2', 'Generador', '2', 'Sobrecarga');

INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
-- G1 Over Load
(8, 'overload', 'abreviacion'),
(8, 'sobre carga', 'variacion'),
(8, 'alarma generador', 'sinonimo'),
(8, 'g1 sobrecarga', 'variacion'),
-- G1 Plate Current
(9, 'plate curre limite', 'typo'),
(9, 'corriente placa fuera', 'sinonimo'),
(9, 'plate current error', 'sinonimo'),
-- G1 Arco
(10, 'arco generador', 'sinonimo'),
(10, 'supresor alarma', 'variacion'),
(10, 'arco supresor falla', 'variacion'),
-- G1 Corriente grid
(11, 'corriente baja', 'sinonimo'),
(11, 'grid baja', 'sinonimo'),
(11, 'corriente grid', 'variacion');

-- ============================================================================
-- CLIENTE: STRIKER (SAAC - TSA)
-- ============================================================================
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(6, 'SAAC 1', 'Línea SAAC módulo 1'),
(6, 'SAAC 2', 'Línea SAAC módulo 2'),
(6, 'TSA 1', 'Línea TSA módulo 1'),
(6, 'TSA 2', 'Línea TSA módulo 2');

-- SAAC
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(4, 'ROBOT CAP', 'Robot', 'Robot de capsula'),
(4, 'ROBOT HOUSING', 'Robot', 'Robot de housing'),
(4, 'CONVEYOR', 'Conveyor', 'Banda transportadora'),
(4, 'NAUTILUS', 'Equipo', 'Sistema Nautilus'),
(4, 'BRANSON', 'Soldadora', 'Soldadora Branson');

-- TSA
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(6, 'AX1 Elevador', 'Elevador', 'Elevador módulo AX1'),
(6, 'AX1 Conveyor', 'Conveyor', 'Conveyor módulo AX1'),
(6, 'AX2 Prensa', 'Prensa', 'Prensa módulo AX2'),
(6, 'AX3 Verificación', 'Verificador', 'Verificación AX3'),
(6, 'BIC Sistema', 'Equipo', 'Sistema BIC');

-- Códigos SAAC
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(6, 'ND ATORAMIENTOS', 'Atoramientos en nidos', 'NIDOS', 'Index', 'Atoramiento'),
(6, 'ND FUGA', 'Fuga en nido', 'NIDOS', 'Index', 'Fuga'),
(6, 'ST2 FUGAS', 'Fuga en estación 2', 'Est2', 'Prueba Fuga', 'Fuga'),
(6, 'ST2 FXT', 'Fixture dañada estación 2', 'Est2', 'Prueba Fuga', 'Fixture'),
(6, 'ST2 MECANISMO', 'Sensor/Cilindro/Mecanismo dañado Est2', 'Est2', 'Prueba Fuga', 'Mecanismo'),
(6, 'SV4 RECHAZOS', 'Rechazos sistema visión Est4', 'Est4', 'Visión', 'Rechazo'),
(6, 'ST5 RECHAZOS', 'Rechazos prensa Est5', 'Est5', 'Press Fit', 'Rechazo'),
(6, 'ST6 P&P MECANISMO', 'Mecanismo P&P Est6', 'Est6', 'Pick Place', 'Mecanismo'),
(6, 'ST6 P&P ATORAMIENTOS', 'Atoramientos P&P Est6', 'Est6', 'Pick Place', 'Atoramiento');

-- Códigos TSA
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(6, 'AX1 LIF', 'Falla por elevador AX1', 'AX1', 'Elevador', 'Elevador'),
(6, 'AX1 CON', 'Falla por conveyor AX1', 'AX1', 'Conveyor', 'Conveyor'),
(6, 'AX1 MAG', 'Falla por magneto AX1', 'AX1', 'Magneto', 'Magneto'),
(6, 'AX2 PRE', 'Falla por presión AX2', 'AX2', 'Presión', 'Presión'),
(6, 'BIC SIS', 'Falla sistema BIC', 'BIC', 'General', 'Sistema');

INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
-- SAAC
(16, 'atoramiento nido', 'sinonimo'),
(16, 'nido atascado', 'sinonimo'),
(17, 'fuga nido', 'sinonimo'),
(18, 'fuga st2', 'abreviacion'),
(18, 'estacion 2 fuga', 'variacion'),
(19, 'fixture rota', 'sinonimo'),
(19, 'fixture danada', 'variacion'),
(20, 'sensor danado', 'sinonimo'),
(20, 'cilindro falla', 'sinonimo'),
(21, 'rechazo vision', 'sinonimo'),
(21, 'vision error', 'variacion'),
-- TSA
(26, 'elevador falla', 'sinonimo'),
(26, 'elevador no sube', 'sinonimo'),
(26, 'ax1 elevador', 'variacion'),
(27, 'conveyor parado', 'sinonimo'),
(27, 'motor conveyor', 'sinonimo'),
(28, 'magneto error', 'variacion'),
(29, 'presion baja', 'sinonimo'),
(30, 'sistema bic', 'variacion');

-- ============================================================================
-- CLIENTES: ASIST, IMED, BOSTON SC, MEDTRONIC, CEMENT MIXER
-- (Datos mínimos para demo - estos se completarían con sus glosarios reales)
-- ============================================================================

-- ASIST
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(3, 'ASIST Principal', 'Línea ASIST');
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(7, 'Máquina ASIST 1', 'Equipo', 'Equipo principal ASIST');
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(3, 'AS01', 'Falla general ASIST', 'Principal', '1', 'Error');
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(31, 'error asist', 'sinonimo');

-- IMED
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(4, 'IMED Principal', 'Línea IMED');
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(8, 'Máquina IMED 1', 'Equipo', 'Equipo principal IMED');
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(4, 'IM01', 'Falla general IMED', 'Principal', '1', 'Error');
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(32, 'error imed', 'sinonimo');

-- BOSTON SC
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(5, 'BOSTON SC Principal', 'Línea BOSTON SC');
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(9, 'Máquina BOSTON 1', 'Equipo', 'Equipo principal BOSTON');
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(5, 'BS01', 'Falla general BOSTON SC', 'Principal', '1', 'Error');
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(33, 'error boston', 'sinonimo');

-- MEDTRONIC
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(7, 'MEDTRONIC Principal', 'Línea MEDTRONIC');
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(10, 'Máquina MEDTRONIC 1', 'Equipo', 'Equipo principal MEDTRONIC');
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(7, 'MD01', 'Falla general MEDTRONIC', 'Principal', '1', 'Error');
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(34, 'error medtronic', 'sinonimo');

-- CEMENT MIXER
INSERT INTO tbl_linea_produccion (id_cliente, nombre, descripcion) VALUES
(8, 'CEMENT MIXER Principal', 'Línea CEMENT MIXER');
INSERT INTO tbl_maquina (id_linea, nombre, tipo, descripcion) VALUES
(11, 'Máquina CEMENT 1', 'Equipo', 'Equipo principal CEMENT MIXER');
INSERT INTO tbl_codigo_falla (id_cliente, codigo, descripcion_oficial, modulo, estacion, tipo_falla) VALUES
(8, 'CM01', 'Falla general CEMENT MIXER', 'Principal', '1', 'Error');
INSERT INTO tbl_equivalencias (id_codigo, equivalencia, tipo_variacion) VALUES
(35, 'error cement', 'sinonimo');
