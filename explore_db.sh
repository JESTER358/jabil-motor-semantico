#!/bin/bash

# ============================================================================
# SCRIPT INTERACTIVO PARA EXPLORAR LA BASE DE DATOS
# ============================================================================

DATABASE="jabil_motor.db"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║       EXPLORADOR DE BASE DE DATOS - MOTOR SEMÁNTICO JABIL          ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Base de datos: $DIR/$DATABASE"
echo ""
echo "Comandos disponibles:"
echo "1. Ver todos los clientes"
echo "2. Ver códigos de falla por cliente"
echo "3. Ver sinónimos de un código"
echo "4. Buscar código por descripción sucia"
echo "5. Ver historial de capturas"
echo "6. Estadísticas generales"
echo "7. Abrir SQL shell interactivo"
echo "0. Salir"
echo ""

while true; do
    read -p "Selecciona opción (0-7): " choice
    
    case $choice in
        1)
            echo ""
            echo "📍 CLIENTES REGISTRADOS:"
            sqlite3 "$DIR/$DATABASE" << 'EOF'
.mode column
.headers on
SELECT id_cliente, nombre, descripcion FROM tbl_cliente ORDER BY id_cliente;
EOF
            ;;
        2)
            read -p "Ingresa cliente (DEXCOM, 3M, STRIKER, etc): " cliente
            echo ""
            echo "📊 CÓDIGOS PARA: $cliente"
            sqlite3 "$DIR/$DATABASE" << EOF
.mode column
.headers on
SELECT codigo, descripcion_oficial, modulo, estacion FROM tbl_codigo_falla 
WHERE id_cliente = (SELECT id_cliente FROM tbl_cliente WHERE nombre = '$cliente')
ORDER BY codigo;
EOF
            ;;
        3)
            read -p "Ingresa código (ej: M1 St02): " codigo
            echo ""
            echo "🔤 SINÓNIMOS PARA: $codigo"
            sqlite3 "$DIR/$DATABASE" << EOF
.mode column
.headers on
SELECT equivalencia, tipo_variacion FROM tbl_equivalencias 
WHERE id_codigo = (SELECT id_codigo FROM tbl_codigo_falla WHERE codigo = '$codigo')
ORDER BY tipo_variacion, equivalencia;
EOF
            ;;
        4)
            read -p "Ingresa descripción sucia (ej: atoramiento canula): " descripcion
            echo ""
            echo "🔍 BUSCANDO: '$descripcion'"
            sqlite3 "$DIR/$DATABASE" << EOF
.mode column
.headers on
SELECT 
    cf.codigo as CÓDIGO,
    cf.descripcion_oficial as DESCRIPCIÓN,
    CASE 
        WHEN eq.equivalencia IS NOT NULL THEN 'Equivalencia exacta'
        ELSE 'Búsqueda parcial'
    END as TIPO_MATCH,
    tc.nombre as CLIENTE
FROM tbl_codigo_falla cf
JOIN tbl_cliente tc ON cf.id_cliente = tc.id_cliente
LEFT JOIN tbl_equivalencias eq ON cf.id_codigo = eq.id_codigo
WHERE LOWER(eq.equivalencia) LIKE LOWER('%$descripcion%')
   OR LOWER(cf.descripcion_oficial) LIKE LOWER('%$descripcion%')
LIMIT 10;
EOF
            ;;
        5)
            echo ""
            echo "📝 HISTORIAL DE CAPTURAS RECIENTES:"
            sqlite3 "$DIR/$DATABASE" << 'EOF'
.mode column
.headers on
SELECT 
    id_captura,
    (SELECT nombre FROM tbl_cliente WHERE id_cliente = tc.id_cliente) as cliente,
    descripcion_entrada,
    codigo_detectado,
    ROUND(confianza_match * 100, 0) || '%' as confianza,
    timestamp
FROM tbl_captura_datos tc
ORDER BY timestamp DESC
LIMIT 20;
EOF
            ;;
        6)
            echo ""
            echo "📈 ESTADÍSTICAS GENERALES:"
            sqlite3 "$DIR/$DATABASE" << 'EOF'
.mode column
.headers on
SELECT 
    COUNT(DISTINCT id_cliente) as 'Clientes',
    COUNT(DISTINCT id_linea_produccion) as 'Líneas',
    COUNT(DISTINCT id_maquina) as 'Máquinas',
    COUNT(DISTINCT id_codigo) as 'Códigos de Falla',
    COUNT(*) as 'Sinónimos'
FROM (
    SELECT DISTINCT id_cliente FROM tbl_cliente
    UNION
    SELECT DISTINCT id_linea_produccion FROM tbl_linea_produccion
    UNION
    SELECT DISTINCT id_maquina FROM tbl_maquina
    UNION
    SELECT DISTINCT id_codigo FROM tbl_codigo_falla
    UNION
    SELECT DISTINCT id_equivalencia FROM tbl_equivalencias
);

.print ""
.print "📊 POR CLIENTE:"
SELECT 
    nombre as CLIENTE,
    COUNT(DISTINCT tcf.id_codigo) as CÓDIGOS,
    COUNT(DISTINCT te.id_equivalencia) as SINÓNIMOS
FROM tbl_cliente tc
LEFT JOIN tbl_codigo_falla tcf ON tc.id_cliente = tcf.id_cliente
LEFT JOIN tbl_equivalencias te ON tcf.id_codigo = te.id_codigo
GROUP BY tc.id_cliente, nombre
ORDER BY CÓDIGOS DESC;
EOF
            ;;
        7)
            echo ""
            echo "🔧 Abriendo SQL shell (escribe .help para ver comandos)"
            sqlite3 "$DIR/$DATABASE"
            echo ""
            echo "Conexión cerrada."
            ;;
        0)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "❌ Opción inválida. Intenta de nuevo."
            ;;
    esac
    
    echo ""
    read -p "Presiona ENTER para continuar..."
    clear
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║       EXPLORADOR DE BASE DE DATOS - MOTOR SEMÁNTICO JABIL          ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
done
