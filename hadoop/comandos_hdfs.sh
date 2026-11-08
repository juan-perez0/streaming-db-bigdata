#!/bin/bash
# ============================================================
# COMANDOS HDFS — PRÁCTICA BIG DATA
# Proyecto: Análisis de Plataforma de Streaming con MapReduce
# ============================================================
# Ejecutar desde el nodo maestro de Hadoop o desde WSL
# con Hadoop configurado y los servicios iniciados.
#
# Prerequisito: export HADOOP_HOME=/opt/hadoop
#               export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
# ============================================================

echo "======================================================"
echo "  GESTIÓN HDFS — PROYECTO STREAMING BIG DATA"
echo "======================================================"

# ─────────────────────────────────────────────────────────────
# 1. VERIFICAR QUE HADOOP ESTÁ CORRIENDO
# ─────────────────────────────────────────────────────────────
echo ""
echo "1. Verificando servicios Hadoop..."
jps
# Debe mostrar: NameNode, DataNode, ResourceManager, NodeManager

# ─────────────────────────────────────────────────────────────
# 2. CREAR ESTRUCTURA DE DIRECTORIOS EN HDFS
# ─────────────────────────────────────────────────────────────
echo ""
echo "2. Creando estructura de directorios en HDFS..."

hdfs dfs -mkdir -p /user/estudiante/streaming/datos
hdfs dfs -mkdir -p /user/estudiante/streaming/resultados/job01_generos
hdfs dfs -mkdir -p /user/estudiante/streaming/resultados/job02_puntuacion
hdfs dfs -mkdir -p /user/estudiante/streaming/resultados/job03_ingresos
hdfs dfs -mkdir -p /user/estudiante/streaming/resultados/job04_top_vistas
hdfs dfs -mkdir -p /user/estudiante/streaming/resultados/job05_tendencias

echo "  Directorios creados en HDFS."

# ─────────────────────────────────────────────────────────────
# 3. CARGAR DATASETS EN HDFS
# ─────────────────────────────────────────────────────────────
echo ""
echo "3. Cargando datasets en HDFS..."

# Cargar dataset ampliado (principal)
hdfs dfs -put datos/streaming_ampliado.csv \
         /user/estudiante/streaming/datos/

# Cargar dataset original (referencia)
hdfs dfs -put datos/peliculas_dataset.csv \
         /user/estudiante/streaming/datos/

echo "  Datasets cargados en HDFS."

# ─────────────────────────────────────────────────────────────
# 4. VERIFICAR ARCHIVOS EN HDFS
# ─────────────────────────────────────────────────────────────
echo ""
echo "4. Verificando archivos en HDFS..."

hdfs dfs -ls -h /user/estudiante/streaming/datos/
# Debe mostrar los dos archivos CSV con sus tamaños

echo ""
echo "   Contenido del directorio raíz del proyecto:"
hdfs dfs -ls /user/estudiante/streaming/

# ─────────────────────────────────────────────────────────────
# 5. VER CONTENIDO DE UN ARCHIVO (primeras 5 líneas)
# ─────────────────────────────────────────────────────────────
echo ""
echo "5. Vista previa del dataset en HDFS:"
hdfs dfs -cat /user/estudiante/streaming/datos/streaming_ampliado.csv | head -5

# ─────────────────────────────────────────────────────────────
# 6. ESTADÍSTICAS DEL ARCHIVO EN HDFS
# ─────────────────────────────────────────────────────────────
echo ""
echo "6. Información del archivo en HDFS:"
hdfs dfs -stat "%n %o %r %b bytes" \
         /user/estudiante/streaming/datos/streaming_ampliado.csv
# %n=nombre %o=bloque %r=factor_replica %b=tamaño

# ─────────────────────────────────────────────────────────────
# 7. DESCARGAR RESULTADOS DE HDFS
# ─────────────────────────────────────────────────────────────
echo ""
echo "7. Descargando resultados desde HDFS..."

hdfs dfs -getmerge \
         /user/estudiante/streaming/resultados/job01_generos/ \
         resultados/resultado_conteo_genero_hadoop.txt

hdfs dfs -getmerge \
         /user/estudiante/streaming/resultados/job02_puntuacion/ \
         resultados/resultado_promedio_puntuacion_hadoop.txt

hdfs dfs -getmerge \
         /user/estudiante/streaming/resultados/job03_ingresos/ \
         resultados/resultado_ingresos_hadoop.txt

hdfs dfs -getmerge \
         /user/estudiante/streaming/resultados/job04_top_vistas/ \
         resultados/resultado_top_vistas_hadoop.txt

hdfs dfs -getmerge \
         /user/estudiante/streaming/resultados/job05_tendencias/ \
         resultados/resultado_tendencias_hadoop.txt

echo "  Resultados descargados en la carpeta resultados/."

# ─────────────────────────────────────────────────────────────
# 8. COMANDOS DE MONITOREO Y ADMINISTRACIÓN
# ─────────────────────────────────────────────────────────────
echo ""
echo "8. Comandos útiles de administración HDFS:"
echo ""

# Ver uso del espacio en HDFS
echo "  → Uso de espacio:"
hdfs dfs -du -h /user/estudiante/streaming/

# Reporte del sistema de archivos
echo ""
echo "  → Reporte del NameNode:"
hdfs dfsadmin -report | head -20

# ─────────────────────────────────────────────────────────────
# 9. LIMPIAR RESULTADOS PREVIOS (para re-ejecución)
# ─────────────────────────────────────────────────────────────
echo ""
echo "9. Para limpiar resultados y re-ejecutar:"
echo "   hdfs dfs -rm -r /user/estudiante/streaming/resultados/job01_generos"
echo "   hdfs dfs -rm -r /user/estudiante/streaming/resultados/job02_puntuacion"
echo "   (repetir para cada job)"

echo ""
echo "======================================================"
echo "  GESTIÓN HDFS COMPLETADA"
echo "======================================================"
