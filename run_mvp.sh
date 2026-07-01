#!/bin/bash

# ============================================================================
# SCRIPT PARA EJECUTAR EL MVP COMPLETO
# ============================================================================

set -e  # Exit on error

DATABASE="jabil_motor.db"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║          MOTOR SEMÁNTICO JABIL - EJECUCIÓN MVP                     ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Limpiar BD anterior si existe
if [ -f "$DIR/$DATABASE" ]; then
    echo "🔄 Limpiando base de datos anterior..."
    rm -f "$DIR/$DATABASE"
fi

echo ""
echo "📝 Paso 1: Creando schema..."
sqlite3 "$DIR/$DATABASE" < "$DIR/schema.sql"
echo "✓ Schema creado"

echo ""
echo "📝 Paso 2: Poblando datos (8 clientes)..."
sqlite3 "$DIR/$DATABASE" < "$DIR/populate_data.sql"
echo "✓ Datos cargados"

echo ""
echo "📝 Paso 3: Creando motor de normalización..."
sqlite3 "$DIR/$DATABASE" < "$DIR/motor_normalizacion.sql"
echo "✓ Motor listo"

echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                         DEMO EN VIVO                               ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

sqlite3 "$DIR/$DATABASE" < "$DIR/demo.sql"

echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    ✅ MVP COMPLETADO                               ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Base de datos: $DIR/$DATABASE"
echo ""
echo "Próximos pasos:"
echo "1. Explorar la BD: sqlite3 $DATABASE"
echo "2. Agregar más sinónimos para mejorar precision"
echo "3. Integrar con Power Apps / Power BI"
echo "4. Migrar a SQL Server cuando esté listo"
echo ""
