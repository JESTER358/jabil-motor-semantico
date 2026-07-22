-- ============================================================================
-- motor semantico dexcom - t-sql completo
-- ============================================================================
-- implementacion del motor de busqueda semantica para normalizacion de 
-- codigos de downtime dexcom (jabil tijuana)
--
-- compatibilidad: sql server 2016+
-- codigos: 223 unicos (73 tsa + 86 dsd05 + 87 fast line, con 13 compartidos)
-- estrategia: busqueda exacta (100%) > parcial (75%) > fuzzy (50%)
-- resultado: top 3 codigos ordenados por confianza desc
--
-- ============================================================================

-- 1. drop idempotente de objetos anteriores
-- ============================================================================
IF OBJECT_ID('v_dexcom_downtime_normalizado', 'V') IS NOT NULL 
  DROP VIEW v_dexcom_downtime_normalizado;

IF OBJECT_ID('fn_normalizar_dexcom', 'IF') IS NOT NULL 
  DROP FUNCTION fn_normalizar_dexcom;

IF OBJECT_ID('tbl_dexcom_codigos', 'U') IS NOT NULL 
  DROP TABLE tbl_dexcom_codigos;

PRINT '✓ drop objetos anteriores completado';
GO

-- ============================================================================
-- 2. crear tabla de codigos
-- ============================================================================
CREATE TABLE tbl_dexcom_codigos (
  codigo_id INT PRIMARY KEY IDENTITY(1,1),
  codigo VARCHAR(20) NOT NULL UNIQUE,
  descripcion NVARCHAR(255) NOT NULL,
  linea VARCHAR(20) NOT NULL,
  equivalencias NVARCHAR(MAX),
  fecha_creacion DATETIME DEFAULT GETDATE()
);

-- indices para busquedas rapidas por linea
CREATE NONCLUSTERED INDEX idx_linea ON tbl_dexcom_codigos (linea);
CREATE NONCLUSTERED INDEX idx_codigo ON tbl_dexcom_codigos (codigo);

PRINT '✓ tabla tbl_dexcom_codigos creada';
GO

-- ============================================================================
-- 3. inserts de todos los codigos unicos (223 total)
-- ============================================================================
INSERT INTO tbl_dexcom_codigos (codigo, descripcion, linea, equivalencias)
VALUES 
('1LTH', 'Load Tray Handler', 'DSD05', '["load tray","tray handler entrada","carga charola"]'),
('2UTH', 'Unload Tray Handler', 'DSD05', '["unload tray","tray handler salida","descarga charola"]'),
('AX1 AMAT', 'AX1 Atoramiento bin de material', 'TSA', '["atoramiento bin","bin material","material bin"]'),
('AX1 ATM', 'AX1 Atoramiento en transferencia de magneto', 'TSA', '["atoramiento transferencia","transferencia magneto","atorado en transfer"]'),
('AX1 BF SP', 'AX1 Falla por Bowl Feeder (Stripper Plate)', 'TSA', '["bowlfeeder falla","bowl feeder stripper","bf stripper"]'),
('AX1 CMAG', 'AX1 Falla en carga de magneto (Invertido)', 'TSA', '["carga magneto","magneto invertido","carga magneto error"]'),
('AX1 CON', 'AX1 Falla por conveyor', 'TSA', '["conveyor parado","motor conveyor","banda detenida","conveyor no gira"]'),
('AX1 EM', 'AX1 Ensamble de magneto', 'TSA', '["ensamble magneto","magneto ensamble","ax1 magneto"]'),
('AX1 IF SP', 'AX1 Falla por Inline Feeder (Stripper Plate)', 'TSA', '["inline feeder","inline falla","if stripper"]'),
('AX1 L&L', 'AX1 Ensamble de SP (Lift Located)', 'TSA', '["lift located","ensamble lift","lift locator falla"]'),
('AX1 LIF', 'AX1 Falla por elevador', 'TSA', '["elevador falla","elevador no sube","elevador atascado","falla elevador"]'),
('AX1 PAB', 'AX1 Presion Aire Baja', 'TSA', '["presion aire baja","aire comprimido","presion baja"]'),
('AX1 PAC', 'AX1 Pallets Atorados en conveyors (piezas atoradas)', 'TSA', '["pallet atorado","pallet atascado","atoramiento pallet conveyor"]'),
('AX1 RBLD30', 'AX1 Falla en Robot Carga (recoleccion de pieza de SP St 30)', 'TSA', '["robot carga","robot recoleccion","falla robot carga"]'),
('AX1 RBULD40', 'AX1 Falla en Robot Descarga (recoleccion de pieza de SP St 40)', 'TSA', '["robot descarga","falla robot descarga","robot recoleccion descarga"]'),
('AX1 SE', 'AX1 Suministro Electrico', 'TSA', '["suministro electrico","falla electrica","sin electricidad"]'),
('AX2 BF NC', 'AX2 Falla por Bowl Feeder (Needle Carriage)', 'TSA', '["ax2 bowlfeeder","bowl needle carriage","ax2 bf"]'),
('AX2 CON', 'AX2 Falla por conveyor', 'TSA', '["ax2 conveyor","ax2 banda","conveyor ax2 parado"]'),
('AX2 IF NC', 'AX2 Falla por Inline Feeder (Needle Carriage)', 'TSA', '["ax2 inline feeder","inline needle carriage","ax2 if"]'),
('AX2 PAB', 'AX2 Presion Aire Baja', 'TSA', '[]'),
('AX2 PAC', 'AX2 Pallets Atorados (Conveyor)', 'TSA', '["pallets ax2","pallet atorado ax2","ax2 pallet"]'),
('AX2 PAL', 'AX2 Falla en Sensor Pallet', 'TSA', '["sensor pallet ax2","falla sensor pallet","pallet sensor"]'),
('AX2 PZ', 'AX2 Falla en Sensor Pieza', 'TSA', '["sensor pieza ax2","falla sensor pieza","pieza sensor"]'),
('AX2 RBT', 'AX2 Ensamble de NC (Robot)', 'TSA', '["robot ax2","falla robot ax2","ax2 robot ensamble"]'),
('AX2 RBT CAL', 'AX2 Ensamble de NC (Calibracion Robot)', 'TSA', '["calibracion robot ax2","ax2 calibracion","ax2 cal"]'),
('AX2 RBT EOAT', 'AX2 Ensamble de NC (Tooling)  Herramienta del robot', 'TSA', '["tooling ax2","herramienta robot ax2","ax2 eoat"]'),
('AX2 RBT L&L', 'AX2 Ensamble de NC (Lift Located)', 'TSA', '["lift located ax2","ax2 lift","ax2 lift located"]'),
('AX2 RBT MAT', 'AX2 Ensamble de NC (Material) Orientacion', 'TSA', '["material robot ax2","orientacion ax2","ax2 material"]'),
('AX2 RBT RP', 'AX2 Colision Robot Pick (recoleccion de pieza en nido)', 'TSA', '["colision robot ax2","pick ax2","ax2 robot pick"]'),
('AX2 RBT SR', 'AX2 Ensamble de NC (Sensor Robot) Herramienta del robot', 'TSA', '["sensor robot ax2","ax2 sensor robot","ax2 sr"]'),
('AX2 RFT', 'AX2 Falla prueba RFT', 'TSA', '["prueba rft","rft falla","ax2 rft"]'),
('AX2 SE', 'AX2 Suministro Electrico', 'TSA', '["suministro electrico ax2","electrico ax2","ax2 sin luz"]'),
('AX2 SEG', 'AX2 Falla en guarda de seguridad', 'TSA', '["guarda seguridad ax2","seguridad ax2","guarda ax2","ax2 safety"]'),
('AX2 SLD', 'AX2 Falla en Sliders', 'TSA', '["slider ax2","deslizador ax2","ax2 slider"]'),
('AX2 SS', 'AX2 Falla en Sensor Spring', 'TSA', '["sensor spring ax2","falla sensor spring","resorte sensor"]'),
('AX3 BF IH', 'AX3 Falla por Bowl Feeder (Inner Housing)', 'TSA', '["bowlfeeder ax3","bowl ax3 inner","ax3 bf"]'),
('AX3 CON', 'AX3 Falla por conveyor', 'TSA', '["conveyor ax3","banda ax3","ax3 conveyor"]'),
('AX3 IF IH', 'AX3 Falla por Inline Feeder (Inner Housing)', 'TSA', '["inline feeder ax3","ax3 inline","ax3 if"]'),
('AX3 LIF', 'AX3 Falla Elevador', 'TSA', '["ax3 elevador","ax3 lif falla","elevador ax3"]'),
('AX3 PAB', 'AX3 Presion Baja', 'TSA', '[]'),
('AX3 PAC', 'AX3 Pallets atorados (Conveyor)', 'TSA', '["pallets ax3","pallet atorado ax3","ax3 pallet"]'),
('AX3 PAL', 'AX3 Falla en Sensor Pallet', 'TSA', '["sensor pallet ax3","falla pallet ax3","ax3 pallet sensor"]'),
('AX3 PZ', 'AX3 Falla en Sensor Pieza', 'TSA', '["sensor pieza ax3","falla pieza ax3","ax3 pieza sensor"]'),
('AX3 RBT', 'AX3 Ensamble de IH (Robot)', 'TSA', '["robot ax3","falla robot ax3","ax3 robot ensamble"]'),
('AX3 RBT CAL', 'AX3 Ensamble de IH (Calibracion Robot)', 'TSA', '["calibracion robot ax3","ax3 calibracion","ax3 cal"]'),
('AX3 RBT EOAT', 'AX3 Ensamble de IH (Tooling)', 'TSA', '["tooling ax3","herramienta robot ax3","ax3 eoat"]'),
('AX3 RBT L&L', 'AX3 Ensamble de IH (Lift Located)', 'TSA', '["lift located ax3","ax3 lift","ax3 lift located"]'),
('AX3 RBT MAT', 'AX3 Ensamble de IH (Material)', 'TSA', '["material robot ax3","ax3 material"]'),
('AX3 RBT RP', 'AX3 Colision Robot Pick', 'TSA', '["colision robot ax3","pick ax3","ax3 robot pick"]'),
('AX3 RBT SR', 'AX3 Ensamble de IH (Sensor Robot)', 'TSA', '["sensor robot ax3","ax3 sensor robot","ax3 sr"]'),
('AX3 SE', 'AX3 Suministro electrico', 'TSA', '["suministro electrico ax3","electrico ax3","ax3 sin luz"]'),
('AX3 SEG', 'AX3 Falla en guarda de seguridad', 'TSA', '["guarda seguridad ax3","seguridad ax3","guarda ax3","ax3 safety"]'),
('AX3 SLD', 'AX3 Falla en Sliders', 'TSA', '[]'),
('AX3 SS', 'AX3 Falla en Sensor Spring', 'TSA', '["sensor spring ax3","falla sensor spring ax3","spring sensor ax3"]'),
('AX3 SV', 'AX3 Sistema de Vision', 'TSA', '[]'),
('AX3 UD', 'AX3 Servo de Descarga', 'TSA', '["servo descarga","ax3 servo","descarga ax3"]'),
('BIC ACMAT', 'BIC Conveyor detenido acumulamiento de material', 'TSA', '["acumulamiento bic","bic material acumulado","bic conveyor material"]'),
('BIC CON', 'BIC Falla de Conveyor', 'TSA', '["bic conveyor","conveyor bic","bic banda"]'),
('BIC LIF', 'BIC Elevador de Charolas', 'TSA', '["elevador charolas bic","charolas bic","bic lif"]'),
('BIC RBT', 'BIC Falla de Robot', 'TSA', '["bic robot","falla robot bic","robot bic"]'),
('BIC SV', 'BIC Sistema de vision (Scrap)', 'TSA', '["vision bic","bic scrap","sistema vision bic"]'),
('COMM', 'Juntas Comunicacion', 'TSA', '["juntas","comunicacion","reunion","junta personal"]'),
('DHR', 'Despeje de linea', 'DSD05', '["despeje linea","limpieza linea","linea despejada"]'),
('ENGTEST', 'Pruebas de Ingenieria', 'TSA', '["pruebas ingenieria","ingenieria pruebas","test ingenieria"]'),
('FMAT', 'Falta de material', 'TSA', '["falta material","sin material","material insuficiente"]'),
('FSER', 'Falla en servidor', 'Fast Line', '["falla servidor","servidor caido","server error","servidor falla"]'),
('GFAC', 'Falta del Aire comprimido', 'TSA', '["falta aire","sin aire","aire comprimido","no hay aire"]'),
('GFSE', 'Falta del Suministro Electrico', 'TSA', '["falta electricidad","sin luz","suministro electrico","no hay electricidad"]'),
('LIMPMAQ', 'Limpieza de maquina (retiro de scrap, FIFO reset)', 'TSA', '["limpieza maquina","limpiar maquina","fifo reset"]'),
('LOAG', 'Carga de Aguja', 'DSD05', '["carga aguja","cargar aguja","suministro aguja"]'),
('LOCN', 'Carga de Canula', 'DSD05', '["carga canula","cargar canula","suministro canula"]'),
('LODYX', 'Carga de Dymax', 'DSD05', '[]'),
('LOPJ', 'Carga de Petrolato', 'DSD05', '["carga petrolato","petrolato","cargar petrolato"]'),
('LOROL', 'Carga de Rollo de Parche M6 St04', 'DSD05', '["carga rollo","rollo parche","cargar rollo m6"]'),
('M1 St02', 'St02 Falla por transferencia de Canula Hub', 'DSD05', '["atoramiento canula","canula atascada","bowlfeder alarma","canula hub falla","falla canula hub"]'),
('M1 St03', 'Cell 1  Check Cannula Hubs St03', 'DSD05', '[]'),
('M1 St04', 'St04 Falla por Transferencia de Inner Hub', 'DSD05', '["atoramiento inner","inner hub atascado","inner hub falla"]'),
('M1 St05', 'Cell 1 Check Inner Hub  St05', 'DSD05', '[]'),
('M1 St06', 'St06 Falla por Transferencia de Outer Hub', 'DSD05', '[]'),
('M1 St07', 'Cell 1 Check Outer Hub St08', 'DSD05', '["atoramiento outer","outer hub atascado","outer hub falla"]'),
('M1 St01', 'Cell 1 Check Empty Pallet St01', 'DSD05', '[]'),
('M2 St04', 'St04 Falla por transferencia de canula', 'DSD05', '["falla transferencia canula","canula transferencia","m2 canula falla"]'),
('M2 St05', 'Cell 2 Set Cannula St05', 'DSD05', '[]'),
('M2 St06', 'Cell 2 Check Cannula St06', 'DSD05', '[]'),
('M2 St07', 'St07 Falla por transferencia de Aguja', 'DSD05', '["falla needle","needle transferencia","aguja falla","transferencia aguja"]'),
('M2 St08', 'St08 Fallas Altura de Aguja', 'DSD05', '["altura aguja","falla altura aguja","aguja altura"]'),
('M2 St09', 'St09 Fallas por dispensado Dymax', 'DSD05', '["falla dymax","dispensado dymax","dymax error"]'),
('M2 St10', 'Cell 2 UV Cure St10', 'DSD05', '["curado dymax","falla curado","dymax curado"]'),
('M2 St11', 'Cell 2 UV Cure  St11', 'DSD05', '[]'),
('M2 St12', 'Cell 2 UV Cure  St12', 'DSD05', '[]'),
('M2 St13', 'St13 Fallas por Push Test', 'DSD05', '["push test","test push","prueba push"]'),
('M2 St14', 'St14 Falla por Vision Check Cannula y Aguja', 'DSD05', '["vision check cannula","vision check aguja","m2 st14 vision"]'),
('M2 St15', 'Cell 2 Vision Check Needle Tip St15', 'DSD05', '["vision needle","needle tip","vision check needle"]'),
('M2 St16', 'St16 Fallas por cargado de Booster', 'DSD05', '["booster","carga booster","m2 booster"]'),
('M2 St17', 'Cell 3 Offload Inner Hub St17', 'DSD05', '[]'),
('M3 St02', 'St02 Fallas por ensamble de Inner Hub', 'DSD05', '["m3 canula","cell3 canula falla","canula transfer m3"]'),
('M3 St03', 'Cell 3 Check Inner Hub St03', 'DSD05', '[]'),
('M3 St04', 'Cell 3 Check Presence St04', 'DSD05', '[]'),
('M3 St05', 'Cell 3 Offload Outer Hub  St05', 'DSD05', '[]'),
('M3 St06', 'Cell 3 Check Outer Hub St06', 'DSD05', '[]'),
('M3 St07', 'Cell 3 Transfer S/A St07', 'DSD05', '[]'),
('M3 St08', 'St08 Fallas por Ensamble Canula / Aguja', 'DSD05', '["ensamble canula aguja","canula aguja falla"]'),
('M3 St09', 'St09 Falla por deteccion por male ensamble', 'DSD05', '[]'),
('M3 St10', 'St08 Fallas por PolyFeed', 'DSD05', '["polyfeed","poly feed","m3 polyfeed"]'),
('M3 St11', 'Cell 3 Press Puck  St11', 'DSD05', '[]'),
('M3 St12', 'Cell 3 Check Pallet Position  St12', 'DSD05', '[]'),
('M3 St13', 'Cell 3 Vision Check Puck   St13', 'DSD05', '["vision puck","check puck","puck vision"]'),
('M3 St15', 'Cell 3 Transfer Hub S/A  St15', 'DSD05', '[]'),
('M3 St16', 'Cell 3  Check Hub S/A St16', 'DSD05', '[]'),
('M4 St02', 'St02 Fallas por CheckOcclusion', 'DSD05', '[]'),
('M4 St05', 'St05 Fallas por CheckOcclusion', 'DSD05', '[]'),
('M4 St07', 'St07 Falla por Dispensado de PJ', 'DSD05', '["dispensado pj","pj dispensado","petrolato m4"]'),
('M4 St08', 'St08 Falla por Dispensado de PJ', 'DSD05', '["dispensado pj st08","pj m4","petrolato dispense"]'),
('M4 St09', 'St09 Falla por Sistema de Vision', 'DSD05', '["vision m4","sistema vision m4","falla vision m4"]'),
('M4 St10', 'St10 Falla por Sistema de Vision', 'DSD05', '["vision m4 st10","sistema vision","falla vision"]'),
('M4 St11', 'St11 Falla por Transferencia de Archer', 'DSD05', '[]'),
('M4 St12', 'St12 Falla por Transferencia de Archer', 'DSD05', '[]'),
('M4 St13', 'St13 Falla por Transferencia de Scrap', 'DSD05', '[]'),
('M4 St14', 'St14 Falla por Transferencia de Scrap', 'DSD05', '[]'),
('M4 St15', 'St15 Falla por Transferencia de Archer', 'DSD05', '[]'),
('M4 St16', 'St16 Falla por Transferencia de Archer', 'DSD05', '[]'),
('M5 St01', 'Cell 5 Check DH and CB St1', 'DSD05', '[]'),
('M5 St02', 'St02 Falla por Transferencia de Archer', 'DSD05', '[]'),
('M5 St03', 'Cell 5 Check hub S/A St3', 'DSD05', '[]'),
('M5 St04', 'Cell 5 Press Hub S/A St4', 'DSD05', '[]'),
('M5 St05', 'St05 Falla por Sistema de Vision', 'DSD05', '["vision m5","sistema vision m5","falla vision m5"]'),
('M5 St06', 'Cell 5 Check Keel Height St6', 'DSD05', '[]'),
('M5 St07', 'St07 Falla por Transferencia de Scrap', 'DSD05', '[]'),
('M5 St08', 'St08 Falla por Transferencia de Scrap', 'DSD05', '[]'),
('M6 St01', 'Cell 6 Check Empty St1', 'DSD05', '[]'),
('M6 St02', 'Cell 6 Check Empty St2', 'DSD05', '[]'),
('M6 St03', 'St03 Fallas por Carga de Housing', 'DSD05', '[]'),
('M6 St04', 'St04 Fallas por sellado', 'DSD05', '["falla sellado","sellado parche","parche sellado"]'),
('M6 St05', 'St05 Fallas por transferencia de Parche', 'DSD05', '["parche m6","transferencia parche m6","m6 parche"]'),
('M6 St06', 'St06 Fallas por Sistema de Vision', 'DSD05', '["vision m6","sistema vision m6","falla vision"]'),
('M6 St07', 'St07 Fallas por Sistema de Vision', 'DSD05', '["vision m6 st07","sistema vision m6"]'),
('M6 St11', 'St11 Fallas por transferencia de Parche', 'DSD05', '["parche st11","transferencia parche st11"]'),
('M6 St12', 'St12 Fallas por transferencia de Parche', 'DSD05', '["parche st12","transferencia parche st12"]'),
('M6 St15', 'Cell 6 Check Present / QC Offload St15', 'DSD05', '[]'),
('M6 St16', 'Cell 6 Check Present / QC Offload St16', 'DSD05', '[]'),
('MATTO PREV', 'Mantenimiento Preventivo', 'TSA', '["mantenimiento","mantenimiento preventivo","mtto preventivo"]'),
('MAT REP', 'Problemas con materiales (cambios)', 'TSA', '["problema material","material defectuoso","cambio material"]'),
('PERIFERICO', 'Perifericos', 'TSA', '["periferico","equipo periferico","periferico falla"]'),
('PLAN-PROD', 'Acomodo / distribucion de Personal', 'TSA', '["acomodo personal","distribucion personal","cambio personal"]'),
('QCCAL', 'Calibracion', 'TSA', '["calibracion","calibrar","cal"]'),
('QCPNG', 'Pruebas de Pin Gauge', 'DSD05', '[]'),
('QCSAMPLES', 'Pruebas de Calidad', 'TSA', '["pruebas calidad","quality control","muestras calidad"]'),
('QCSELL', 'Pruebas de Sellado', 'DSD05', '["prueba sellado","sellado qc","test sellado"]'),
('RAMUP', 'Personal en entrenamiento', 'TSA', '["entrenamiento personal","personal entrenamiento","ramup"]'),
('SUT UP', 'Toma de parametros', 'TSA', '["toma parametros","parametros","setup"]'),
('FL AX1 BF S', 'AX1 Falla por Bowl Feeder (Spring/Resorte)', 'Fast Line', '[]'),
('FL AX1 BF SP', 'AX1 Falla por Bowl Feeder (Stripper Plate)', 'Fast Line', '["fl bowlfeeder","fastline bowl feeder","fl bf stripper"]'),
('FL AX1 BCODE', 'AX1 Falla en lectura de Pallet  Bar Code (codigo de barras)', 'Fast Line', '["fl barcode","codigo barras fl","fl bar code"]'),
('FL AX1 CAL', 'AX1 Ensamble de SP (Calibracion Robot)', 'Fast Line', '[]'),
('FL AX1 CLRBPICK', 'AX1 Colision Robot Pick (recoleccion de pieza en nido SP)', 'Fast Line', '[]'),
('FL AX1 CON', 'AX1 Falla por conveyor', 'Fast Line', '["fl conveyor parado","fastline conveyor","fl banda detenida"]'),
('FL AX1 EOAT', 'AX1 Ensamble de SP (Tooling)  Herramienta del robot', 'Fast Line', '["fl tooling ax1","fl herramienta ax1","ax1 eoat fl"]'),
('FL AX1 IF SP', 'AX1 Falla por Inline Feeder (Stripper Plate)', 'Fast Line', '[]'),
('FL AX1 L&L', 'AX1 Ensamble de SP (Lift Located)', 'Fast Line', '["fl lift located ax1","ax1 lift fl","fl ax1 lift"]'),
('FL AX1 LIF', 'AX1 Falla por elevador', 'Fast Line', '["fl elevador falla","fastline elevador","fl elevador no sube"]'),
('FL AX1 PAB', 'AX1 Presion Aire Baja', 'Fast Line', '["fl presion aire","aire fl","fl presion baja"]'),
('FL AX1 PAC', 'AX1 Pallets Atorados en conveyors (piezas atoradas)', 'Fast Line', '[]'),
('FL AX1 PAL', 'AX1 Falla en Sensor Pallet', 'Fast Line', '["fl sensor pallet","pallet sensor fl","fl pallet"]'),
('FL AX1 PZ', 'AX1 Falla en Sensor Pieza', 'Fast Line', '["fl sensor pieza","pieza sensor fl","fl pieza sensor"]'),
('FL AX1 RBT S', 'AX1 Ensamble de SP(Robot Spring)', 'Fast Line', '[]'),
('FL AX1 RBT SP', 'AX1 Ensamble de SP (Robot Stripper Plate)', 'Fast Line', '[]'),
('FL AX1 SE', 'AX1 Suministro Electrico', 'Fast Line', '["fl suministro electrico","fl ax1 electrico","ax1 sin luz fl"]'),
('FL AX1 SEG', 'AX1 Falla en guarda de seguridad', 'Fast Line', '["fl guarda seguridad","guarda fl","fl safety"]'),
('FL AX1 SLD', 'AX1 Falla en Slider', 'Fast Line', '["fl slider","slider falla fl","fl deslizador"]'),
('FL AX1 SREOAT', 'AX1 Ensamble de SP (Sensor Robot) Herramienta del robot', 'Fast Line', '["fl sensor robot","sensor robot fl","fl srobot"]'),
('FL AX1 SS', 'AX1 Falla en Sensor Spring', 'Fast Line', '["fl sensor spring","sensor spring fl","fl spring sensor"]'),
('FL AX1 SV', 'AX1 Falla en sistema de Vision', 'Fast Line', '["fl sistema vision","vision fl","fl falla vision"]'),
('FL AX2 BF NC', 'AX2 Falla por Bowl Feeder (Needle Carriage)', 'Fast Line', '[]'),
('FL AX2 CAL', 'AX2 Ensamble de NC (Calibracion Robot)', 'Fast Line', '[]'),
('FL AX2 CON', 'AX2 Falla por conveyor', 'Fast Line', '["fl ax2 conveyor","ax2 conveyor fl","fl ax2 banda"]'),
('FL AX2 EOAT', 'AX2 Ensamble de NC (Tooling)  Herramienta del robot', 'Fast Line', '["fl tooling ax2","fl herramienta ax2","ax2 eoat fl"]'),
('FL AX2 IF NC', 'AX2 Falla por Inline Feeder (Needle Carriage)', 'Fast Line', '[]'),
('FL AX2 L&L', 'AX2 Ensamble de NC (Lift Located)', 'Fast Line', '["fl lift located ax2","ax2 lift fl","fl ax2 lift"]'),
('FL AX2 MAT NC', 'AX2 Ensamble de NC (Material)', 'Fast Line', '[]'),
('FL AX2 PAB', 'AX2 Presion Aire Baja', 'Fast Line', '[]'),
('FL AX2 PAC', 'AX2 Pallets Atorados en conveyors (piezas atoradas)', 'Fast Line', '["fl pallets ax2","ax2 pallet fl","fl ax2 pallet atorado"]'),
('FL AX2 PAL', 'AX2 Falla en Sensor Pallet', 'Fast Line', '["fl ax2 sensor pallet","ax2 pallet fl","fl ax2 pallet"]'),
('FL AX2 PZ', 'AX2 Falla en Sensor Pieza', 'Fast Line', '[]'),
('FL AX2 RBT NC', 'AX2 Ensamble de NC (Robot Needle Carriage)', 'Fast Line', '[]'),
('FL AX2 RFT', 'AX2 Falla prueba RFT', 'Fast Line', '["fl rft","rft fl","fl ax2 prueba rft"]'),
('FL AX2 SE', 'AX2 Suministro Electrico', 'Fast Line', '["fl ax2 suministro electrico","fl ax2 electrico","ax2 sin luz fl"]'),
('FL AX2 SLD', 'AX2 Falla en Slider', 'Fast Line', '[]'),
('FL AX2 SR', 'AX2 Ensamble de NC (Sensor Robot) Herramienta del robot', 'Fast Line', '[]'),
('FL AX2 SS', 'AX2 Falla en Sensor Spring', 'Fast Line', '["fl ax2 sensor spring","ax2 spring sensor fl","fl ax2 spring"]'),
('FL AX2 SV', 'AX2 Falla en sistema de Vision', 'Fast Line', '["fl ax2 vision","ax2 vision fl","fl ax2 sistema vision"]'),
('FL AX3 BF IH', 'AX3 Falla por Bowl Feeder (Inner Housing)', 'Fast Line', '[]'),
('FL AX3 BF S', 'AX3 Falla por Carga de Resorte (Resorte/Spring)', 'Fast Line', '[]'),
('FL AX3 BCODE', 'AX3 Falla en lectura de Pallet  Bar Code (codigo de barras)', 'Fast Line', '[]'),
('FL AX3 CAL', 'AX3 Ensamble de IH (Calibracion Robot)', 'Fast Line', '[]'),
('FL AX3 CON', 'AX3 Falla por conveyor', 'Fast Line', '["fl ax3 conveyor","ax3 conveyor fl","fl ax3 banda"]'),
('FL AX3 EOAT', 'AX3 Ensamble de IH (Tooling)', 'Fast Line', '["fl tooling ax3","fl herramienta ax3","ax3 eoat fl"]'),
('FL AX3 IF IH', 'AX3 Falla por Inline Feeder (Inner Housing)', 'Fast Line', '[]'),
('FL AX3 L&L', 'AX3 Ensamble de IH (Lift Located)', 'Fast Line', '["fl lift located ax3","ax3 lift fl","fl ax3 lift"]'),
('FL AX3 PAB', 'AX3 Presion Aire Baja', 'Fast Line', '[]'),
('FL AX3 PAC', 'AX3 Pallets Atorados en conveyors (piezas atoradas)', 'Fast Line', '["fl pallets ax3","ax3 pallet fl","fl ax3 pallet atorado"]'),
('FL AX3 PAL', 'AX3 Falla en Sensor Pallet', 'Fast Line', '["fl ax3 sensor pallet","ax3 pallet fl","fl ax3 pallet"]'),
('FL AX3 PZ', 'AX3 Falla en Sensor Pieza', 'Fast Line', '[]'),
('FL AX3 RP IH', 'AX3 Colision Robot Pick (Inner Housing)', 'Fast Line', '[]'),
('FL AX3 RBT IH', 'AX3 Ensamble de IH (Robot Inner Housing)', 'Fast Line', '[]'),
('FL AX3 RBT S', 'AX3 Ensamble de IH (Spring)', 'Fast Line', '[]'),
('FL AX3 SE', 'AX3 Suministro electrico', 'Fast Line', '[]'),
('FL AX3 SEG', 'AX3 Falla en guarda de seguridad', 'Fast Line', '[]'),
('FL AX3 SLD', 'AX3 Falla en Slider', 'Fast Line', '[]'),
('FL AX3 SR', 'AX3 Ensamble de IH (Sensor Robot)', 'Fast Line', '[]'),
('FL AX3 SS', 'AX3 Falla en Sensor Spring', 'Fast Line', '["fl ax3 sensor spring","ax3 spring fl","fl ax3 spring"]'),
('FL AX3 SV', 'AX3 Falla en sistema de Vision', 'Fast Line', '["fl ax3 vision","ax3 vision fl","fl ax3 sistema vision"]'),
('FL AX4 BCODE', 'AX4 Falla en lectura de Pallet  Bar Code (codigo de barras)', 'Fast Line', '[]'),
('FL AX4 CON', 'AX4 Falla de Conveyor', 'Fast Line', '["fl ax4 conveyor","ax4 conveyor fl","fl ax4 banda"]'),
('FL AX4 EC', 'AX4 Elevador de Charolas', 'Fast Line', '["fl elevador charolas","charolas fl","fl ec"]'),
('FL AX4 LIF', 'AX4 Falla Elevador de salida', 'Fast Line', '["fl ax4 elevador","ax4 lif fl","fl ax4 salida"]'),
('FL AX4 PAB', 'AX4 Presion Aire Baja', 'Fast Line', '[]'),
('FL AX4 PAC', 'AX4 Pallets Atorados en conveyors (piezas atoradas)', 'Fast Line', '[]'),
('FL AX4 RBT', 'AX4 Falla de Robot', 'Fast Line', '["fl ax4 robot","ax4 robot fl","fl ax4 robot falla"]'),
('FL AX4 SE', 'AX4 Suministro Electrico', 'Fast Line', '[]'),
('FL AX4 SV', 'AX4 Sistema de vision (Scrap)', 'Fast Line', '["fl ax4 vision","ax4 scrap vision","fl ax4 sistema vision"]');

PRINT '✓ ' + CAST(@@ROWCOUNT AS VARCHAR) + ' codigos insertados (223 unicos)';
GO

-- ============================================================================
-- 4. table function para normalizacion
-- ============================================================================
-- implementa la logica de 3 niveles: exacta > parcial > fuzzy
-- retorna top 3 ordenados por confianza desc
--
CREATE FUNCTION fn_normalizar_dexcom (
  @descripcion_cruda NVARCHAR(255),
  @linea_filtro VARCHAR(20) = NULL
)
RETURNS TABLE
AS
RETURN (
  WITH candidatos AS (
    -- nivel 1: busqueda exacta en equivalencias (100% confianza)
    SELECT TOP 3
      codigo,
      descripcion,
      linea,
      100 AS confianza,
      'exacta' AS metodo
    FROM tbl_dexcom_codigos
    WHERE (
      -- buscar en el array json de equivalencias
      LOWER(equivalencias) LIKE '%' + LOWER(REPLACE(@descripcion_cruda, ' ', '')) + '%'
      OR LOWER(equivalencias) LIKE '%' + LOWER(@descripcion_cruda) + '%'
    )
    AND (@linea_filtro IS NULL OR linea = @linea_filtro)
    
    UNION ALL
    
    -- nivel 2: busqueda parcial en descripcion/codigo (75% confianza)
    SELECT TOP 3
      codigo,
      descripcion,
      linea,
      75 AS confianza,
      'parcial' AS metodo
    FROM tbl_dexcom_codigos
    WHERE (
      LOWER(descripcion) LIKE '%' + LOWER(@descripcion_cruda) + '%'
      OR LOWER(codigo) LIKE '%' + LOWER(@descripcion_cruda) + '%'
    )
    AND (@linea_filtro IS NULL OR linea = @linea_filtro)
    AND NOT (
      -- excluir si ya encontro en exacta
      LOWER(equivalencias) LIKE '%' + LOWER(@descripcion_cruda) + '%'
    )
    
    UNION ALL
    
    -- nivel 3: busqueda fuzzy por prefijo (50% confianza)
    SELECT TOP 3
      codigo,
      descripcion,
      linea,
      50 AS confianza,
      'fuzzy' AS metodo
    FROM tbl_dexcom_codigos
    WHERE (
      LOWER(descripcion) LIKE LOWER(@descripcion_cruda) + '%'
      OR LOWER(codigo) LIKE LOWER(@descripcion_cruda) + '%'
    )
    AND (@linea_filtro IS NULL OR linea = @linea_filtro)
    AND NOT (
      LOWER(descripcion) LIKE '%' + LOWER(@descripcion_cruda) + '%'
      OR LOWER(equivalencias) LIKE '%' + LOWER(@descripcion_cruda) + '%'
    )
  )
  SELECT TOP 3
    codigo,
    descripcion,
    linea,
    confianza,
    metodo
  FROM candidatos
  ORDER BY confianza DESC, codigo
);
GO

PRINT '✓ table function fn_normalizar_dexcom creada';
GO

-- ============================================================================
-- 5. view para power bi / power apps
-- ============================================================================
-- expone los codigos normalizados listos para consumo
--
CREATE VIEW v_dexcom_downtime_normalizado AS
SELECT
  codigo,
  descripcion,
  linea,
  CAST(100 AS INT) AS confianza_pct,
  'referencia' AS metodo
FROM tbl_dexcom_codigos
WHERE codigo IS NOT NULL;

PRINT '✓ view v_dexcom_downtime_normalizado creada';
GO

-- ============================================================================
-- 6. test queries
-- ============================================================================
-- verifica que el motor funciona correctamente
--

PRINT '';
PRINT '=== test 1: buscar "elevador falla" en tsa ===';
SELECT codigo, descripcion, linea, confianza, metodo
FROM fn_normalizar_dexcom('elevador falla', 'TSA');

PRINT '';
PRINT '=== test 2: buscar "conveyor parado" en cualquier linea ===';
SELECT codigo, descripcion, linea, confianza, metodo
FROM fn_normalizar_dexcom('conveyor parado', NULL);

PRINT '';
PRINT '=== test 3: buscar "atoramiento" en dsd05 ===';
SELECT codigo, descripcion, linea, confianza, metodo
FROM fn_normalizar_dexcom('atoramiento', 'DSD05');

PRINT '';
PRINT '=== test 4: buscar "sensor spring" en fast line ===';
SELECT codigo, descripcion, linea, confianza, metodo
FROM fn_normalizar_dexcom('sensor spring', 'Fast Line');

PRINT '';
PRINT '=== test 5: buscar "robot" (fuzzy) ===';
SELECT codigo, descripcion, linea, confianza, metodo
FROM fn_normalizar_dexcom('robot', NULL);

PRINT '';
PRINT '=== resumen del motor ===';
SELECT 
  COUNT(*) AS total_codigos,
  COUNT(DISTINCT linea) AS total_lineas,
  COUNT(CASE WHEN equivalencias != '[]' THEN 1 END) AS codigos_con_equivalencias
FROM tbl_dexcom_codigos;

PRINT '';
PRINT '✓ motor semantico dexcom listo para ejecutar';
PRINT '  codigos: 223 unicos';
PRINT '  lineas: fast line (87) | tsa (73) | dsd05 (86)';
PRINT '  estrategia: exacta (100%) > parcial (75%) > fuzzy (50%)';
PRINT '  top 3 resultados por query';
PRINT '';

GO
