-- ============================================================
-- IMED: CODIGOS DE FALLA COMPLETOS
-- Generado desde: 04_Codigos de Falla_General.xlsx (hoja IMED)
-- ============================================================


-- ============================================================
-- SECCION 01: EXPULSORES
-- ============================================================

-- EXPULSORES - NO EXPULSA (12 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(1, 'EXP001', 'Sensores mal conectados', 'Se conectan, posicionan y ajustan correctamente', 'No Expulsa'),
(1, 'EXP002', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Expulsa'),
(1, 'EXP003', 'Servomotor o amplificador dañado', 'Se remplaza equipo dañado', 'No Expulsa'),
(1, 'EXP004', 'Transducer dañado', 'Se remplaza transducer,posiciona y se ajusta', 'No Expulsa'),
(1, 'EXP005', 'Mangueras Hidraulicas mal conectadas', 'Se conectan correctamente', 'No Expulsa'),
(1, 'EXP006', 'Permisos Maquina-Robot Mal configurados', 'Se configuran permisos de acuerdo a WI', 'No Expulsa'),
(1, 'EXP007', 'Fuera de parametros, mal ajustados', 'Se ajustan conforme a WI', 'No Expulsa'),
(1, 'EXP008', 'Se Atoran Barras Placa Expulsora', 'Se reemplazan barras', 'No Expulsa'),
(1, 'EXP009', 'Cable señal dañado o con falso contacto', 'Se cambia cable y/o se aprietan contactos', 'No Expulsa'),
(1, 'EXP010', 'Mecanismo de molde No lubricado y mal ajustado', 'Se entrega molde a Tool Room', 'No Expulsa'),
(1, 'EXP011', 'Apertura de Molde fuera de posicion', 'Se ajustan parametros y/o remplaza transducer', 'No Expulsa'),
(1, 'EXP012', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza fusible, relay o tarjeta I/O', 'No Expulsa');

-- EXPULSORES - NO REGRESA (11 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(2, 'EXP013', 'Placa o barras sueltas', 'Se ajustan correctamente', 'No Regresa'),
(2, 'EXP014', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Regresa'),
(2, 'EXP015', 'Servomotor o amplificador dañado', 'Se remplaza equipo dañado', 'No Regresa'),
(2, 'EXP016', 'Transducer dañado', 'Se remplaza transducer, posiciona y se ajusta', 'No Regresa'),
(2, 'EXP017', 'Se atoran barras o placa expulsora', 'Se entrega molde a Tool Room', 'No Regresa'),
(2, 'EXP018', 'Permisos Maquina-Robot Mal configurados', 'Se configuran permisos de acuerdo a WI y Molde', 'No Regresa'),
(2, 'EXP019', 'Fuera de parametros, mal ajustados', 'Se ajustan parametros conforme a WI', 'No Regresa'),
(2, 'EXP020', 'Cable señal dañado o con falso contacto', 'Se cambia cable y/o se aprietan contactos', 'No Regresa'),
(2, 'EXP021', 'Mecanismo de molde No lubricado y mal ajustado', 'Se entrega molde a tool room', 'No Regresa'),
(2, 'EXP022', 'Apertura Molde Fuera Posicion', 'Se ajustan parametros conforme a WI y/o remplaza transducer', 'No Regresa'),
(2, 'EXP023', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza fusible, relay o tarjeta I/O', 'No Regresa');

-- EXPULSORES - PIERDEN POSICION (4 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(3, 'EXP024', 'Transducer desajustado o dañado.', 'Se remplaza transducer, posiciona y se ajusta', 'Pierden Posicion'),
(3, 'EXP025', 'Tarjeta control defectuosa.', 'Se remplaza tarjeta I/O', 'Pierden Posicion'),
(3, 'EXP026', 'Perdida de voltaje señal de control', 'Se remplaza relay y/o se aprietan conexiones', 'Pierden Posicion'),
(3, 'EXP027', 'Servomotor dañado', 'Se remplaza Servomotor', 'Pierden Posicion');


-- ============================================================
-- SECCION 02: CLAMP
-- ============================================================

-- CLAMP - NO CIERRA (11 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(4, 'CLM028', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Cierra'),
(4, 'CLM029', 'Servo Motor o Amplificador dañado', 'Se remplaza equipo dañado', 'No Cierra'),
(4, 'CLM030', 'Transducer dañado', 'Se remplaza transducer, posiciona y se ajusta', 'No Cierra'),
(4, 'CLM031', 'No Entra Alta Presion (candado)', 'Se remplaza valvula y/o Ajustan parametros', 'No Cierra'),
(4, 'CLM032', 'Permisos Maquina-Robot Mal configurados', 'Se configuran permisos de acuerdo a WI y Molde', 'No Cierra'),
(4, 'CLM033', 'Fuera de parametros o mal ajustados', 'Se ajustan parametros conforme a WI', 'No Cierra'),
(4, 'CLM034', 'Ejectores Fuera de Posicion', 'Se cambia vlavula y/o Se ajustan parametros', 'No Cierra'),
(4, 'CLM035', 'Cable señal dañado o con falso contacto', 'Se cambia cable y/o se aprietan contactos', 'No Cierra'),
(4, 'CLM036', 'Falta de lubricacion', 'Se corrige sistema de lubricacion automatica', 'No Cierra'),
(4, 'CLM037', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza fusible, relay o tarjeta I/O', 'No Cierra'),
(4, 'CLM038', 'Pierde ajuste Altura de Molde', 'Se ajustan parametros y/o remplaza transducer', 'No Cierra');

-- CLAMP - NO ABRE (10 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(5, 'CLM039', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Abre'),
(5, 'CLM040', 'Servo Motor o Amplificador dañado', 'Se remplaza equipo dañado', 'No Abre'),
(5, 'CLM041', 'Transducer dañado', 'Se remplaza transducer, posiciona y se ajusta', 'No Abre'),
(5, 'CLM042', 'Permisos Maquina-Robot Mal configurados', 'Se configuran permisos de acuerdo a WI y Molde', 'No Abre'),
(5, 'CLM043', 'Fuera de parametros o mal ajustados', 'Se ajustan parametros conforme a WI', 'No Abre'),
(5, 'CLM044', 'No se libera candado Alta Presion', 'Se cambia vlavula y/o Se ajustan parametros', 'No Abre'),
(5, 'CLM045', 'Cable señal dañado o con falso contacto', 'Se cambia cable y/o se aprietan contactos', 'No Abre'),
(5, 'CLM046', 'Falta de lubricacion', 'Se corrige sistema de lubricacion automatica', 'No Abre'),
(5, 'CLM047', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza fusible, relay o tarjeta I/O', 'No Abre'),
(5, 'CLM048', 'Pierde ajuste Altura de Molde', 'Se ajustan parametros y/o remplaza transducer', 'No Abre');

-- CLAMP - PIERDE POSICION (5 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(6, 'CLM049', 'Transducer desajustado o dañado.', 'Se remplaza transducer y/o Ajustan parametros', 'Pierde Posicion'),
(6, 'CLM050', 'Tarjeta control defectuosa.', 'Se remplaza tarjeta', 'Pierde Posicion'),
(6, 'CLM051', 'Perdida de voltaje en señal de control', 'Se remplaza fusible, relay o tarjeta I/O', 'Pierde Posicion'),
(6, 'CLM052', 'Servomotor dañado', 'Se remplaza servomotor', 'Pierde Posicion'),
(6, 'CLM053', 'Mal ajuste Proteccion de Molde', 'Se ajustan parametros y/o remplaza transducer', 'Pierde Posicion');


-- ============================================================
-- SECCION 03: INYECCION
-- ============================================================

-- INYECCION - NO INYECTA (11 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(7, 'INY054', 'No hay señal Cierre de Alta Presion', 'Se remplaza fusible, relay o tarjeta I/O', 'No Inyecta'),
(7, 'INY055', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Inyecta'),
(7, 'INY056', 'Servomotor o Amplificador dañados', 'Se remplaza equipo dañado', 'No Inyecta'),
(7, 'INY057', 'Transducer dañado', 'Se remplaza transducer, posiciona y se ajusta', 'No Inyecta'),
(7, 'INY058', 'No alcanzo tamaño de tiro', 'Se ajustan parametros conforme a WI', 'No Inyecta'),
(7, 'INY059', 'Carro Inyeccion fuera de posicion', 'Se cambia vlavula, se ajustan limit switch', 'No Inyecta'),
(7, 'INY060', 'Cable señal dañado o con falso contacto', 'Se cambia cable y/o se aprietan contactos', 'No Inyecta'),
(7, 'INY061', 'Baja Temperaturas Barril', 'Se ejecuta Autotuning y/o Ajaustan Parametros', 'No Inyecta'),
(7, 'INY062', 'Fuera de Parametros de Inyeccion', 'Se ajustan parametros conforme a WI', 'No Inyecta'),
(7, 'INY063', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza fusible, relay o tarjeta I/O', 'No Inyecta'),
(7, 'INY064', 'Tornillo Quebrado', 'Se remplaza tornillo dañado', 'No Inyecta');

-- INYECCION - NO CARGA (9 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(8, 'INY065', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Carga'),
(8, 'INY066', 'Servomotor o Amplificador dañados', 'Se remplaza equipo dañado', 'No Carga'),
(8, 'INY067', 'Transducer dañado', 'Se remplaza transducer, posiciona y se ajusta', 'No Carga'),
(8, 'INY068', 'No tiene material', 'Se agrega material y se ajusta tamaño de tiro', 'No Carga'),
(8, 'INY069', 'Cable señal dañado o con falso contacto', 'Se cambia cable y/o se aprietan terminales', 'No Carga'),
(8, 'INY070', 'Baja Temperaturas de Barril', 'Ajuste autotuning, cambia resistencia y/o Se ajustan parametros', 'No Carga'),
(8, 'INY071', 'Fuera de Parametros de carga', 'Se corrigen parametros conforme a WI', 'No Carga'),
(8, 'INY072', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza fusible, relay o tarjeta I/O', 'No Carga'),
(8, 'INY073', 'Tornillo Quebrado', 'Se remplaza tornillo', 'No Carga');

-- INYECCION - MAL INYECCION (9 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(9, 'INY074', 'Tornillo o barril desgastado', 'Se remplaza tornillo o barril', 'Mal Inyeccion'),
(9, 'INY075', 'Check Valve desgastada', 'Se remplaza Check Valve completa', 'Mal Inyeccion'),
(9, 'INY076', 'Inconsistencia en Resistencia Barril', 'Ajuste autotuning, cambia resistencia y/o Se ajustan parametros', 'Mal Inyeccion'),
(9, 'INY077', 'Puntos negros y contaminacion', 'Limpieza tornillo y barril', 'Mal Inyeccion'),
(9, 'INY078', 'Mal dosificacion material, garganta muy fria', 'Se agrega material, se ajusta temperatura y tamaño de tiro', 'Mal Inyeccion'),
(9, 'INY079', 'Tornillo inyeccion incorrecto', 'Se remplaza tornillo con ESPEC correcto', 'Mal Inyeccion'),
(9, 'INY080', 'Mal set-up temperaturas', 'Se ajustan parametros conforme a WI', 'Mal Inyeccion'),
(9, 'INY081', 'Fuera rango parametros MIN-MAX temperaturas', 'Se corrigen parametros conforme a WI', 'Mal Inyeccion'),
(9, 'INY082', 'Fuera parametros RPM o Back Pressure', 'Se corrigen parametros conforme a WI', 'Mal Inyeccion');

-- INYECCION - PIERDE POSICION (3 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(10, 'INY083', 'Transducer desajustado o dañado.', 'Se remplaza transducer y/o Ajustan parametros', 'Pierde Posicion'),
(10, 'INY084', 'Tarjeta control defectuosa.', 'Se remplaza tarjeta', 'Pierde Posicion'),
(10, 'INY085', 'Perdida de voltaje en señal de control', 'Se remplaza fusible, relay o tarjeta I/O', 'Pierde Posicion');

-- INYECCION - TEMPERATURA (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(11, 'INY086', 'Thermocouple dañado', 'Se remplaza termocouple', 'Temperatura'),
(11, 'INY087', 'Resitencia dañada', 'Se remplaza resistencia', 'Temperatura'),
(11, 'INY088', 'Fusible dañado', 'Se remplaza fusible', 'Temperatura'),
(11, 'INY089', 'Contactor dañado', 'Se remplaza contactor', 'Temperatura'),
(11, 'INY090', 'Relay dañado', 'Se remplaza relay', 'Temperatura'),
(11, 'INY091', 'Apagadas', 'Se prenden resistencias', 'Temperatura'),
(11, 'INY092', 'Auto tuning temperaturas.', 'Se ejecuta calibracion', 'Temperatura'),
(11, 'INY093', 'No hay señal tarjeta resistencias/thermocoples', 'Se remplaza tarjeta y/o relay de salida dañada', 'Temperatura');


-- ============================================================
-- SECCION 04: CARRO INYECCION
-- ============================================================

-- CARRO INYECCION - NO AVANZA (6 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(12, 'CIN094', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Avanza'),
(12, 'CIN095', 'Servo motor o amplificador dañado', 'Se remplaza servo y/o amplificador', 'No Avanza'),
(12, 'CIN096', 'limit Switch desajustado o dañado', 'Se remplaza LS y/o Se ajsuta LS', 'No Avanza'),
(12, 'CIN097', 'Cable señal dañado o con falso contacto', 'Se repara cable y/o se ajustan terminales flojas', 'No Avanza'),
(12, 'CIN098', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza tarjeta y/o se cambia relay de salida dañado', 'No Avanza'),
(12, 'CIN099', 'Guarda de purga defectuosa', 'Se coloca guarda en posicion, se ajusta LS y/o se cambia LS', 'No Avanza');

-- CARRO INYECCION - NO RETRAE (6 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(13, 'CIN100', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Retrae'),
(13, 'CIN101', 'Servo motor o amplificador dañado', 'Se remplaza servo y/o amplificador', 'No Retrae'),
(13, 'CIN102', 'limit Switch desajustado o dañado', 'Se remplaza LS y/o Se ajsuta LS', 'No Retrae'),
(13, 'CIN103', 'Cable señal dañado o con falso contacto', 'Se repara cable y/o se ajustan terminales flojas', 'No Retrae'),
(13, 'CIN104', 'No hay señal de voltaje a valvula o servo motor', 'Se remplaza tarjeta y/o se cambia relay de salida dañado', 'No Retrae'),
(13, 'CIN105', 'Guarda de purga defectuosa', 'Se coloca guarda en posicion, se ajusta LS y/o se cambia LS', 'No Retrae');


-- ============================================================
-- SECCION 05: CORE PULL
-- ============================================================

-- CORE PULL - NO ABREN (10 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(14, 'CRP106', 'Sensores o Limit Switch mal conectados', 'Se conectan correctamente y ajustan', 'No Abren'),
(14, 'CRP107', 'Funsion desactivada', 'Se activa funsion', 'No Abren'),
(14, 'CRP108', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Abren'),
(14, 'CRP109', 'Mangueras Hidraulicas mal conectadas', 'Se conectan correctamente', 'No Abren'),
(14, 'CRP110', 'Fuera de parametros, mal ajustados', 'Se ajustan parametros conforme a WI', 'No Abren'),
(14, 'CRP111', 'Cable señal dañado o con falso contacto', 'Se repara cable y/o se ajustan terminales flojas', 'No Abren'),
(14, 'CRP112', 'Apertura de Molde fuera de posicion', 'Se corrigen parametros conforme a WI y/o cambio transducer', 'No Abren'),
(14, 'CRP113', 'No hay señal de voltaje a valvula', 'Se remplaza fusible, relay o tarjeta I/O', 'No Abren'),
(14, 'CRP114', 'Sensores o Limit switch dañados', 'Se remplaza sensor y se ajusta', 'No Abren'),
(14, 'CRP115', 'Mecanismo de molde No lubricado y mal ajustado', 'Se baja molde y se manda a taller', 'No Abren');

-- CORE PULL - NO CIERRAN (10 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(15, 'CRP116', 'Sensores o Limit Switch mal conectados', 'Se conectan correctamente y ajustan', 'No Cierran'),
(15, 'CRP117', 'Funsion desactivada', 'Se activa funsion', 'No Cierran'),
(15, 'CRP118', 'Valvula Hidraulica dañada', 'Se remplaza valvula', 'No Cierran'),
(15, 'CRP119', 'Mangueras Hidraulicas mal conectadas', 'Se conectan correctamente', 'No Cierran'),
(15, 'CRP120', 'Fuera de parametros, mal ajustados', 'Se ajustan parametros conforme a WI', 'No Cierran'),
(15, 'CRP121', 'Cable señal dañado o con falso contacto', 'Se repara cable y/o se ajustan terminales flojas', 'No Cierran'),
(15, 'CRP122', 'Ejectores no retraidos y fuera de posicion', 'Se corrigen parametros conforme a WI y/o cambio transducer', 'No Cierran'),
(15, 'CRP123', 'No hay señal de voltaje a valvula', 'Se remplaza fusible, relay o tarjeta I/O', 'No Cierran'),
(15, 'CRP124', 'Sensores o Limit switch dañados', 'Se remplaza sensor y se ajusta', 'No Cierran'),
(15, 'CRP125', 'Mecanismo de molde No lubricado y mal ajustado', 'Se baja molde y se manda a taller', 'No Cierran');


-- ============================================================
-- SECCION 06: VALVE GATES
-- ============================================================

-- VALVE GATES - NO ABRE (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(16, 'VLG126', 'Valvula Hidraulica o Neumatica dañada', '', 'No Abre'),
(16, 'VLG127', 'Funsion desactivada', '', 'No Abre'),
(16, 'VLG128', 'Secuencia mal ajustada o programada', '', 'No Abre'),
(16, 'VLG129', 'Cable señal dañado o con falso contacto', '', 'No Abre'),
(16, 'VLG130', 'No hay señal de voltaje a valvula', '', 'No Abre'),
(16, 'VLG131', 'Guarda de purga defectuosa', '', 'No Abre'),
(16, 'VLG132', 'Perdida o Fuga Presion de Aire o Hidraulico', '', 'No Abre'),
(16, 'VLG133', 'No recibe señal de secuencia', '', 'No Abre');

-- VALVE GATES - NO CIERRA (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(17, 'VLG134', 'Valvula Hidraulica o Neumatica dañada', '', 'No Cierra'),
(17, 'VLG135', 'Funsion desactivada', '', 'No Cierra'),
(17, 'VLG136', 'Secuencia mal ajustada o programada', '', 'No Cierra'),
(17, 'VLG137', 'Cable señal dañado o con falso contacto', '', 'No Cierra'),
(17, 'VLG138', 'No hay señal de voltaje a valvula', '', 'No Cierra'),
(17, 'VLG139', 'Guarda de purga defectuosa', '', 'No Cierra'),
(17, 'VLG140', 'Perdida o Fuga Presion de Aire o Hidraulico', '', 'No Cierra'),
(17, 'VLG141', 'No recibe señal de secuencia', '', 'No Cierra');


-- ============================================================
-- SECCION 07: BOOSTER
-- ============================================================

-- BOOSTER - NO PRESURISA (5 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(18, 'BST142', 'Fuga aire en conectores.', '', 'No Presurisa'),
(18, 'BST143', 'Regulador dañado', '', 'No Presurisa'),
(18, 'BST144', 'Booster dañado', '', 'No Presurisa'),
(18, 'BST145', 'Mangueras mal conectadas', '', 'No Presurisa'),
(18, 'BST146', 'Llave alimentacion aire cerrada.', '', 'No Presurisa');

-- BOOSTER - NO OPERA (7 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(19, 'BST147', 'No esta activada funsion', '', 'No Opera'),
(19, 'BST148', 'Secuencia mal programada', '', 'No Opera'),
(19, 'BST149', 'Electrovalvula dañada', '', 'No Opera'),
(19, 'BST150', 'Bobina de Electrovalvula dañada', '', 'No Opera'),
(19, 'BST151', 'Mangueras mal conectadas', '', 'No Opera'),
(19, 'BST152', 'Llave alimentacion aire cerrada.', '', 'No Opera'),
(19, 'BST153', 'No hay señal a electrovalvula.', '', 'No Opera');


-- ============================================================
-- SECCION 08: CAMARA INSPECCION
-- ============================================================

-- CAMARA INSPECCION - NO INSPECCIONA (5 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(20, 'CAM154', 'Enfoque desajustado', 'Se ajusta enfoque', 'No Inspecciona'),
(20, 'CAM155', 'Setup Incorrecto', 'Se cargo receta correcta y/o Se corrigio secuencia', 'No Inspecciona'),
(20, 'CAM156', 'No recibio señal', 'Se cargo receta correcta, Se corrigio secuencia y/o Se activo salida', 'No Inspecciona'),
(20, 'CAM157', 'No activo proteccion', 'Se corrigio señal de salida', 'No Inspecciona'),
(20, 'CAM158', 'Ajuste de Set-Up', 'Ajusto set-up por cambio modelo', 'No Inspecciona');


-- ============================================================
-- SECCION 09: TOLVA DE CARGA
-- ============================================================

-- TOLVA DE CARGA - NO CARGA (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(21, 'TOL159', 'Fusible abierto', '', 'No carga'),
(21, 'TOL160', 'Sensor Dañado', '', 'No carga'),
(21, 'TOL161', 'Sensor desajustado', '', 'No carga'),
(21, 'TOL162', 'Fuga Vacio en manguera', '', 'No carga'),
(21, 'TOL163', 'Filtro Tapado', '', 'No carga'),
(21, 'TOL164', 'Manguera vacio mal colocada', '', 'No carga'),
(21, 'TOL165', 'Falta Resina', '', 'No carga'),
(21, 'TOL166', 'Control apagado', '', 'No carga');


-- ============================================================
-- SECCION 10: SISTEMA VACIO
-- ============================================================

-- SISTEMA VACIO - FALTA VACIO (7 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(22, 'VAC167', 'Control apagado', '', 'Falta vacio'),
(22, 'VAC168', 'Fusible dañado', '', 'Falta vacio'),
(22, 'VAC169', 'Corto en Cable Multiple Señal', '', 'Falta vacio'),
(22, 'VAC170', 'Bomba apagada', '', 'Falta vacio'),
(22, 'VAC171', 'Filtros tapados', '', 'Falta vacio'),
(22, 'VAC172', 'Valvula dañada', '', 'Falta vacio'),
(22, 'VAC173', 'Movido Parametros Tiempo de carga', '', 'Falta vacio');


-- ============================================================
-- SECCION 11: CONTROL
-- ============================================================

-- CONTROL - PLC (4 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(23, 'CTL174', 'Tarjeta I/O dañada', '', 'PLC'),
(23, 'CTL175', 'Perdida de programa', '', 'PLC'),
(23, 'CTL176', 'CPU Dañado', '', 'PLC'),
(23, 'CTL177', 'Power Supply dañado', '', 'PLC');

-- CONTROL - MONITOR (4 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(24, 'CTL178', 'Touch Screen dañado', '', 'Monitor'),
(24, 'CTL179', 'Display dañado', '', 'Monitor'),
(24, 'CTL180', 'Tarjeta video dañada', '', 'Monitor'),
(24, 'CTL181', 'Daña membrana de funsiones', '', 'Monitor');

-- CONTROL - DRIVER (5 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(25, 'CTL182', 'Power Supply dañado', '', 'Driver'),
(25, 'CTL183', 'Amplificador dañado', '', 'Driver'),
(25, 'CTL184', 'Desconfigurado', '', 'Driver'),
(25, 'CTL185', 'Alarmado por Sobre Carga', '', 'Driver'),
(25, 'CTL186', 'Alarmado por temperatura', '', 'Driver');

-- CONTROL - SERVO MOTOR (2 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(26, 'CTL187', 'Servo Descalibrado', '', 'Servo Motor'),
(26, 'CTL188', 'Dañado Servo Motor', '', 'Servo Motor');


-- ============================================================
-- SECCION 12: MECANICO
-- ============================================================

-- MECANICO - FUERZA (13 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(27, 'MEC189', 'Falta de hidraulico', '', 'Fuerza'),
(27, 'MEC190', 'Filtros hidraulico tapado', '', 'Fuerza'),
(27, 'MEC191', 'Fuga hidraulico', '', 'Fuerza'),
(27, 'MEC192', 'Falta Lubricacion', '', 'Fuerza'),
(27, 'MEC193', 'Balero Lineal dañado', '', 'Fuerza'),
(27, 'MEC194', 'Pin/Bushing dañados mecanismo rodillera', '', 'Fuerza'),
(27, 'MEC195', 'Engrane o Radmientos dañado de platinas', '', 'Fuerza'),
(27, 'MEC196', 'Banda Traccion motores dañada', '', 'Fuerza'),
(27, 'MEC197', 'Fuga agua enfriamiento aceite', '', 'Fuerza'),
(27, 'MEC198', 'Intercambiador aceite tapado', '', 'Fuerza'),
(27, 'MEC199', 'Bomba hidraulica dañada', '', 'Fuerza'),
(27, 'MEC200', 'Transmision hidraulica dañada', '', 'Fuerza'),
(27, 'MEC201', 'Dañado Balero y Flecha Espiral', '', 'Fuerza');


-- ============================================================
-- SECCION 13: ELECTRICO
-- ============================================================

-- ELECTRICO - PROTECCION (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(28, 'ELC202', 'Motor de Bomba dañado', '', 'Proteccion'),
(28, 'ELC203', 'Corto Circuito', '', 'Proteccion'),
(28, 'ELC204', 'Brake dañado', '', 'Proteccion'),
(28, 'ELC205', 'Fusibles dañado', '', 'Proteccion'),
(28, 'ELC206', 'Daño Limit Switch Puertas', '', 'Proteccion'),
(28, 'ELC207', 'Contactor arranque dañado', '', 'Proteccion'),
(28, 'ELC208', 'Dañado Transformador reductor de control', '', 'Proteccion'),
(28, 'ELC209', 'Daño Fuente Poder de control', '', 'Proteccion');


-- ============================================================
-- SECCION 14: THERMOS
-- ============================================================

-- THERMOS - NO CALIENTA (9 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(29, 'THR210', 'Fusibles abierto', '', 'No Calienta'),
(29, 'THR211', 'Contactor resistencias dañado', '', 'No Calienta'),
(29, 'THR212', 'Resistencia Dañada', '', 'No Calienta'),
(29, 'THR213', 'Thermocouple dañado', '', 'No Calienta'),
(29, 'THR214', 'Electrovalvula Close Loop del fujo dañada', '', 'No Calienta'),
(29, 'THR215', 'Bobina de Electrovalvula Close Loop dañada', '', 'No Calienta'),
(29, 'THR216', 'Mal conectadas mangueras de manifull vs molde', '', 'No Calienta'),
(29, 'THR217', 'Llaves flujo agua de manifull cerradas', '', 'No Calienta'),
(29, 'THR218', 'Llaves flujo agua de Alimentacion cerradas', '', 'No Calienta');

-- THERMOS - VARIA TEMPERATURA (SET POINT) (9 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(30, 'THR219', 'Contactor resistencias dañado', '', 'Varia Temperatura (Set Point)'),
(30, 'THR220', 'Resistencia Dañada', '', 'Varia Temperatura (Set Point)'),
(30, 'THR221', 'Thermocouple dañado', '', 'Varia Temperatura (Set Point)'),
(30, 'THR222', 'Fuga de agua', '', 'Varia Temperatura (Set Point)'),
(30, 'THR223', 'Electrovalvula Close Loop del fujo dañada', '', 'Varia Temperatura (Set Point)'),
(30, 'THR224', 'Bobina de Electrovalvula Close Loop dañada', '', 'Varia Temperatura (Set Point)'),
(30, 'THR225', 'Mal conectadas mangueras de manifull vs molde', '', 'Varia Temperatura (Set Point)'),
(30, 'THR226', 'Llaves flujo agua de manifull cerradas', '', 'Varia Temperatura (Set Point)'),
(30, 'THR227', 'Llaves flujo agua de Alimentacion cerradas', '', 'Varia Temperatura (Set Point)');

-- THERMOS - BAJO FLUJO (7 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(31, 'THR228', 'Filtro tapado', '', 'Bajo Flujo'),
(31, 'THR229', 'Motor de Bomba apagado', '', 'Bajo Flujo'),
(31, 'THR230', 'Fuga de agua', '', 'Bajo Flujo'),
(31, 'THR231', 'Switch de Presion desajustado o dañado', '', 'Bajo Flujo'),
(31, 'THR232', 'Baja Presion Agua Servicio Planta', '', 'Bajo Flujo'),
(31, 'THR233', 'Mal conectadas mangueras de manifull vs molde', '', 'Bajo Flujo'),
(31, 'THR234', 'Fuga en Valvula de Alivio de Presion', '', 'Bajo Flujo');


-- ============================================================
-- SECCION 15: SECADO
-- ============================================================

-- SECADO - NO SECA (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(32, 'SCD235', 'Fusibles abierto', '', 'No Seca'),
(32, 'SCD236', 'Dañado Contactor Resistencias', '', 'No Seca'),
(32, 'SCD237', 'Resistencia Dañada', '', 'No Seca'),
(32, 'SCD238', 'Thermocouple dañado', '', 'No Seca'),
(32, 'SCD239', 'Rotas Mangueras Aire Caliente', '', 'No Seca'),
(32, 'SCD240', 'Mal conectadas mangueras de aire caliente', '', 'No Seca'),
(32, 'SCD241', 'Fuga de Aire Caliente', '', 'No Seca'),
(32, 'SCD242', 'Apagado Control de Temperatura', '', 'No Seca');

-- SECADO - VARIA TEMPERATURA SECADO (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(33, 'SCD243', 'Fusible dañado', '', 'Varia Temperatura Secado'),
(33, 'SCD244', 'Falso Contacto o daño en resistencias', '', 'Varia Temperatura Secado'),
(33, 'SCD245', 'Falso Contacto o daño de Thermocouple', '', 'Varia Temperatura Secado'),
(33, 'SCD246', 'Elemento Disecante Saturado o Bajo', '', 'Varia Temperatura Secado'),
(33, 'SCD247', 'Rotas Mangueras Aire Caliente', '', 'Varia Temperatura Secado'),
(33, 'SCD248', 'Mal conectadas mangueras de aire caliente', '', 'Varia Temperatura Secado'),
(33, 'SCD249', 'Fuga de Aire Caliente', '', 'Varia Temperatura Secado'),
(33, 'SCD250', 'Filtros tapados', '', 'Varia Temperatura Secado');

-- SECADO - SIN RESINA (12 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(34, 'SCD251', 'Filtros tapados', '', 'Sin Resina'),
(34, 'SCD252', 'Bin o gaylor sin resina', '', 'Sin Resina'),
(34, 'SCD253', 'Sobresecaron resina', '', 'Sin Resina'),
(34, 'SCD254', 'Motor de Blower Apagado', '', 'Sin Resina'),
(34, 'SCD255', 'Fuga de Vacio', '', 'Sin Resina'),
(34, 'SCD256', 'Switch Nivel de Silo desajustado', '', 'Sin Resina'),
(34, 'SCD257', 'Switch Nivel de Tolva desajustado', '', 'Sin Resina'),
(34, 'SCD258', 'Electrovalvula de Vacio dañada', '', 'Sin Resina'),
(34, 'SCD259', 'Electrovalvula Aire Comprimido dañada', '', 'Sin Resina'),
(34, 'SCD260', 'Bombas de vacio apagada', '', 'Sin Resina'),
(34, 'SCD261', 'Corto en Cable de Señal Control de Carga', '', 'Sin Resina'),
(34, 'SCD262', 'Cable de señal de carga dañado', '', 'Sin Resina');


-- ============================================================
-- SECCION 16: MOLD FLOW
-- ============================================================

-- MOLD FLOW - NO CALIENTA (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(35, 'MLF263', 'Fusible dañado', '', 'No Calienta'),
(35, 'MLF264', 'Set-Up incorrecto', '', 'No Calienta'),
(35, 'MLF265', 'Resistencia dañada de molde', '', 'No Calienta'),
(35, 'MLF266', 'Thermocople dañado de molde', '', 'No Calienta'),
(35, 'MLF267', 'Tarjeta dañada', '', 'No Calienta'),
(35, 'MLF268', 'No enciende', '', 'No Calienta'),
(35, 'MLF269', 'Dañado cable multiple de conexion', '', 'No Calienta'),
(35, 'MLF270', 'Falso contacto en conector multiple', '', 'No Calienta');


-- ============================================================
-- SECCION 17: ROBOT
-- ============================================================

-- ROBOT - NO SACA PIEZAS (5 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(36, 'RBT271', 'No confirma vacio', '', 'No saca piezas'),
(36, 'RBT272', 'No confirma presion', '', 'No saca piezas'),
(36, 'RBT273', 'Secuencia incorrecta', '', 'No saca piezas'),
(36, 'RBT274', 'No tiene vacio', '', 'No saca piezas'),
(36, 'RBT275', 'Vacio debil', '', 'No saca piezas');

-- ROBOT - PIERDE POSICION (3 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(37, 'RBT276', 'Baleros lineales dañados', '', 'Pierde Posicion'),
(37, 'RBT277', 'Daño de banda dentada', '', 'Pierde Posicion'),
(37, 'RBT278', 'Dañado Servo Motor', '', 'Pierde Posicion');


-- ============================================================
-- SECCION 18: EOA
-- ============================================================

-- EOA - NO TOMA PIEZA (8 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(38, 'EOA279', 'Ventosas dañadas', '', 'No Toma Pieza'),
(38, 'EOA280', 'Gripper desalineado', '', 'No Toma Pieza'),
(38, 'EOA281', 'Fixture desalineado', '', 'No Toma Pieza'),
(38, 'EOA282', 'Setup posicion Molde-Expulsores', '', 'No Toma Pieza'),
(38, 'EOA283', 'Set-up manual posiciones Axis X,Y,Z', '', 'No Toma Pieza'),
(38, 'EOA284', 'Fuga vacio en conexiones', '', 'No Toma Pieza'),
(38, 'EOA285', 'Diseño NO funsional e inapropiado', '', 'No Toma Pieza'),
(38, 'EOA286', 'Sensores de confirmacion desajustados', '', 'No Toma Pieza');


-- ============================================================
-- SECCION 19: CONVEYOR
-- ============================================================

-- CONVEYOR - NO TRASNPORTA (5 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(39, 'CVR287', 'Banda desalineada', '', 'No Trasnporta'),
(39, 'CVR288', 'Banda floja', '', 'No Trasnporta'),
(39, 'CVR289', 'Desconectado', '', 'No Trasnporta'),
(39, 'CVR290', 'Fusible dañado', '', 'No Trasnporta'),
(39, 'CVR291', 'Control Velocidad dañado', '', 'No Trasnporta');


-- ============================================================
-- SECCION 20: MATERIALES
-- ============================================================

-- MATERIALES - EQUIPO PARADO (1 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(40, 'MAT292', 'Problemas con Materia Prima', '', 'Equipo parado');


-- ============================================================
-- SECCION 21: MRO
-- ============================================================

-- MRO - EQUIPO PARADO (1 fallas)
INSERT INTO imed_tipos_falla (modo_id, codigo_unico, causa_raiz, accion_correctiva, impacto_operativo) VALUES
(41, 'MRO293', 'Falta Refaccion Registrada en MRO', '', 'Equipo parado');


-- ============================================================
-- RESUMEN TOTAL
-- EXPULSORES: EXP001-EXP027 (27 codigos, modos 1-3)
-- CLAMP: CLM028-CLM053 (26 codigos, modos 4-6)
-- INYECCION: INY054-INY093 (40 codigos, modos 7-11)
-- CARRO INYECCION: CIN094-CIN105 (12 codigos, modos 12-13)
-- CORE PULL: CRP106-CRP125 (20 codigos, modos 14-15)
-- VALVE GATES: VLG126-VLG141 (16 codigos, modos 16-17)
-- BOOSTER: BST142-BST153 (12 codigos, modos 18-19)
-- CAMARA INSPECCION: CAM154-CAM158 (5 codigos, modos 20-20)
-- TOLVA DE CARGA: TOL159-TOL166 (8 codigos, modos 21-21)
-- SISTEMA VACIO: VAC167-VAC173 (7 codigos, modos 22-22)
-- CONTROL: CTL174-CTL188 (15 codigos, modos 23-26)
-- MECANICO: MEC189-MEC201 (13 codigos, modos 27-27)
-- ELECTRICO: ELC202-ELC209 (8 codigos, modos 28-28)
-- THERMOS: THR210-THR234 (25 codigos, modos 29-31)
-- SECADO: SCD235-SCD262 (28 codigos, modos 32-34)
-- MOLD FLOW: MLF263-MLF270 (8 codigos, modos 35-35)
-- ROBOT: RBT271-RBT278 (8 codigos, modos 36-37)
-- EOA: EOA279-EOA286 (8 codigos, modos 38-38)
-- CONVEYOR: CVR287-CVR291 (5 codigos, modos 39-39)
-- MATERIALES: MAT292-MAT292 (1 codigos, modos 40-40)
-- MRO: MRO293-MRO293 (1 codigos, modos 41-41)
-- TOTAL: 293 codigos
-- ============================================================