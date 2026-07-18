-- ============================================================
-- STRIKER: CODIGOS DE FALLA COMPLETOS
-- Generado desde: Codigo de Falla para Tiempo Muerto 3.xlsx (hoja Stryker )
-- ============================================================


-- ============================================================
-- SECCION: INDEX
-- ============================================================

-- INDEX - NIDOS (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(1, 'ND ATORAMIENTOS', 'Atoramientos en nidos: ND ATORAMIENTOS', '', 'NIDOS'),
(1, 'ND FUGA', 'Fuga en mismo nido en estacion#2,3: ND FUGA', '', 'NIDOS');

-- INDEX - Estacion#2  prueba de Fuga (3 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(2, 'ST2 FUGAS', 'Fuga en estacion #3: ST2 FUGAS', '', 'Estacion#2  prueba de Fuga'),
(2, 'ST2 FXT', 'Fixtura dañada: ST2 FXT', '', 'Estacion#2  prueba de Fuga'),
(2, 'ST2 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision: ST2 MECANISMO', '', 'Estacion#2  prueba de Fuga');

-- INDEX - Estacion#3 Rechazo (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(3, 'ST3 FUGAS', 'Exceso de Fugas: ST3 FUGAS', '', 'Estacion#3 Rechazo'),
(3, 'ST3 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision: ST3 MECANISMO', '', 'Estacion#3 Rechazo');

-- INDEX - Estacion#4 Sistema de vicion (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(4, 'SV4 RECHAZOS', 'Maquina lenta por que tarda en dectectar componentes DRV,HOUSING,BASKET Y WELD-RING: SV4 RECHAZOS', '', 'Estacion#4 Sistema de vicion'),
(4, 'SV4 PROBLEMAS CON GOLDEN SAMPLE', 'No detecta en liberacion o pasa como buenas las golden sample de liberacion de calidad: SV4 PROBLEMAS CON GOLDEN SAMPLE', '', 'Estacion#4 Sistema de vicion');

-- INDEX - Estacion#5 Press Fit (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(5, 'ST5 RECHAZOS', 'Rechazos por DRV tapado: ST5 RECHAZOS', '', 'Estacion#5 Press Fit'),
(5, 'ST5 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision: ST5 MECANISMO', '', 'Estacion#5 Press Fit');

-- INDEX - Estacion#6 Pick and Place (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(6, 'ST6 P&P MECANISMO', 'Sensor Dañado,cilindro dañado,servo driver dañado y sensor en no pocision: ST6 P&P MECANISMO', '', 'Estacion#6 Pick and Place'),
(6, 'ST6 P&P ATORAMIENTOS', 'Atoramientos en nidos de index: ST6 P&P ATORAMIENTOS.', '', 'Estacion#6 Pick and Place');


-- ============================================================
-- SECCION: ROBOT DE CAP
-- ============================================================

-- ROBOT DE CAP - FEEDER (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(7, 'CAP FDR', 'Atoramientos,no avanza el cap: CAP FDR', '', 'FEEDER');

-- ROBOT DE CAP - Sistema de Vision (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(8, 'SV RBT', 'No pasa golden sample de calidad y rechazos de cap: SV RBT', '', 'Sistema de Vision');

-- ROBOT DE CAP - Robot (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(9, 'CAP RBT', 'Colision de robot,sensor dañado,gripper dañado o cualquier componente dañado: CAP RBT', '', 'Robot');


-- ============================================================
-- SECCION: ROBOT DE HAUSING Y BASKET
-- ============================================================

-- ROBOT DE HAUSING Y BASKET - FEEDER de Alimentacion de Basket (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(10, 'BSKT FDR', 'Atoramientos,no avanza el basket en riel de feeder: BSKT FDR', '', 'FEEDER de Alimentacion de Basket');

-- ROBOT DE HAUSING Y BASKET - FEEDER de Alimentacion de Housing (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(11, 'HSG FDR', 'Atoramientos,no avanza el Housing en riel de feeder: HSG FDR', '', 'FEEDER de Alimentacion de Housing');

-- ROBOT DE HAUSING Y BASKET - Robot (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(12, 'HSG RBT', 'Colision de robot,sensor dañado,gripper dañado o cualquier componente dañado:HSG RBT', '', 'Robot');

-- ROBOT DE HAUSING Y BASKET - Estacion de Rechazo (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(13, 'RZO RBT', 'Rechazos por componentes DRV,HOUSING,BASKET Y WELD-RING: RZO RBT', '', 'Estacion de Rechazo');


-- ============================================================
-- SECCION: CONVEYOR
-- ============================================================

-- CONVEYOR - Nidos (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(14, 'ND CONVEYOR', 'Pieza mal colocada en mismo nido: ND CONVEYOR', '', 'Nidos');

-- CONVEYOR - Estacion#8 de Pad (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(15, 'ST8 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision: ST8 MECANISMO', '', 'Estacion#8 de Pad');

-- CONVEYOR - Estacion#9 de Verificador de Etiqueta RFID (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(16, 'ST9 RECHAZOS', 'Rechazos por etiqueta RFID en mala condicion: ST9 RECHAZOS', '', 'Estacion#9 de Verificador de Etiqueta RFID'),
(16, 'ST9 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision:ST9 MECANISMO', '', 'Estacion#9 de Verificador de Etiqueta RFID');

-- CONVEYOR - Estacion#10 de Grabado aser (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(17, 'ST10 IMPRESIÓN', 'Grabado incompleto, fecha,lote o referencia mal colocada al momento de un cambio de orden o modelo: ST10 IMPRESIÓN', '', 'Estacion#10 de Grabado aser'),
(17, 'ST10 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision:ST10 MECANISMO', '', 'Estacion#10 de Grabado aser');

-- CONVEYOR - Estacion#11 de Verificador de Alineacion de Etiqueta RFID (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(18, 'ST11 RECHAZOS', 'Rechazos por etiqueta desalineada: ST11 RECHAZOS', '', 'Estacion#11 de Verificador de Alineacion de Etiqueta RFID'),
(18, 'ST11 MECANISMO', 'Sistema de vision en no pocision: ST11 MECANISMO', '', 'Estacion#11 de Verificador de Alineacion de Etiqueta RFID');

-- CONVEYOR - Estacion#12 de Rechazo (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(19, 'ST12 MECANISMO', 'Sensor Dañado,cilindro dañado o sensor en no pocision: ST12 MECANISMO', '', 'Estacion#12 de Rechazo');


-- ============================================================
-- SECCION: NAUTILUS
-- ============================================================

-- NAUTILUS - Sistema de Etiquetado RFID (6 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(20, 'RFID IMPRESIÓN', 'Oportunidad en la Impresión de etiqueta por ejemplo inclinada hacia un costado: RFID IMPRESIÓN', '', 'Sistema de Etiquetado RFID'),
(20, 'RFID X', 'Exceso de etiqueta con X el equipo se alarma: RFID X', '', 'Sistema de Etiquetado RFID'),
(20, 'RFID EMPALME', 'Se rompe rollo por union debil: RFID EMPALME', '', 'Sistema de Etiquetado RFID'),
(20, 'RFID ATORAMIENTOS EN RODILLOS', 'Atoramientos en mecanismo interno de etiquetaRFID  es necesario desarmar: RFID ATORAMIENTOS EN RODILLOS', '', 'Sistema de Etiquetado RFID'),
(20, 'RFID ALARMAS', 'Alarmas en equipo: RFID ALARMAS', '', 'Sistema de Etiquetado RFID'),
(20, 'RFID COMPONENTE DAÑADO', 'Remplazo de servomotor,remplazo de pad de cabezal de aplicador de etiqueta,remplazo de cable de comunicación o cualquier componente del equipo: RFID COMPONENTE DAÑADO', '', 'Sistema de Etiquetado RFID');


-- ============================================================
-- SECCION: BRANSON
-- ============================================================

-- BRANSON - Pick and Place #1 (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(21, 'BSN P&P1 ATORAMIENTOS', 'Atoramiento en nido de index: BSN P&P1 ATORAMIENTOS', '', 'Pick and Place #1'),
(21, 'BSN P&P1 MECANISMO', 'Sensor Dañado,cilindro dañado,servo driver dañado y sensor en no pocision: BSN P&P1 MECANISMO', '', 'Pick and Place #1');

-- BRANSON - Pick and Place #2 (2 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(22, 'BSN P&P2 RECHAZOS', 'Rechazos por un alarma en sistema de sellado laser: BSN P&P2 RECHAZOS', '', 'Pick and Place #2'),
(22, 'BSN P&P2 MECANISMO', 'Sensor Dañado,cilindro dañado,servo driver dañado y sensor en no pocision: BSN P&P2 MECANISMO', '', 'Pick and Place #2');

-- BRANSON - Index (1 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(23, 'BSN INDEX', 'No avanza index,motor dañado: BSN INDEX', '', 'Index');

-- BRANSON - Sistema de sellado Laser (3 fallas)
INSERT INTO striker_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, area) VALUES
(24, 'BSN ALARMAS', 'Alarmas en equipo: BSN ALARMAS', '', 'Sistema de sellado Laser'),
(24, 'BSN SELLADO PARCIAL', 'Scrap por sellado parcial: BSN SELLADO PARCIAL', '', 'Sistema de sellado Laser'),
(24, 'BSN SOBRESELLADO', 'Scrap por sobresellado: BSN SOBRESELLADO', '', 'Sistema de sellado Laser');


-- ============================================================
-- RESUMEN TOTAL
-- INDEX: 13 codigos
-- ROBOT DE CAP: 3 codigos
-- ROBOT DE HAUSING Y BASKET: 4 codigos
-- CONVEYOR: 9 codigos
-- NAUTILUS: 6 codigos
-- BRANSON: 8 codigos
-- TOTAL: 43 codigos
-- ============================================================
