#!/bin/bash
# ============================================================
# COMPILACIÓN Y EJECUCIÓN DE JOBS MapReduce
# Proyecto: Análisis Big Data - Plataforma de Streaming
# ============================================================
# Este script compila los programas Java y ejecuta cada Job
# MapReduce sobre el dataset en HDFS.
#
# Requisitos:
#   - Hadoop 3.x instalado y configurado
#   - Java JDK 8 o 11
#   - Variables de entorno configuradas:
#       export HADOOP_HOME=/opt/hadoop
#       export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
#       export PATH=$PATH:$HADOOP_HOME/bin:$JAVA_HOME/bin
# ============================================================

set -e  # Detener si hay error

HADOOP_HOME=${HADOOP_HOME:-/opt/hadoop}
CLASSPATH="$HADOOP_HOME/share/hadoop/common/hadoop-common-*.jar:\
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-*.jar:\
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-common-*.jar:\
$HADOOP_HOME/share/hadoop/common/lib/*"

HDFS_INPUT="/user/estudiante/streaming/datos/streaming_ampliado.csv"
HDFS_BASE="/user/estudiante/streaming/resultados"

echo "======================================================"
echo "  COMPILACIÓN Y EJECUCIÓN — JOBS MapReduce"
echo "  Proyecto: Análisis Big Data Streaming"
echo "======================================================"

# ─────────────────────────────────────────────────────────────
# FUNCIÓN: Compilar y empaquetar un Job
# ─────────────────────────────────────────────────────────────
compilar_job() {
    local DIRECTORIO=$1
    local CLASE=$2
    local PAQUETE=$3

    echo ""
    echo "── Compilando: $CLASE ──"
    mkdir -p /tmp/mr_build/$PAQUETE

    # Compilar
    javac -classpath "$CLASSPATH" \
          -d /tmp/mr_build \
          mapreduce/$DIRECTORIO/$CLASE.java

    # Crear JAR
    jar -cf jars/${CLASE}.jar \
        -C /tmp/mr_build $PAQUETE

    echo "  ✓ Compilado: jars/${CLASE}.jar"
}

# ─────────────────────────────────────────────────────────────
# FUNCIÓN: Ejecutar un Job MapReduce
# ─────────────────────────────────────────────────────────────
ejecutar_job() {
    local JAR=$1
    local CLASE_PRINCIPAL=$2
    local SALIDA_HDFS=$3
    local DESCRIPCION=$4

    echo ""
    echo "── Ejecutando: $DESCRIPCION ──"

    # Eliminar salida previa si existe
    hdfs dfs -rm -r -skipTrash $SALIDA_HDFS 2>/dev/null || true

    # Ejecutar Job
    hadoop jar jars/$JAR \
           $CLASE_PRINCIPAL \
           $HDFS_INPUT \
           $SALIDA_HDFS

    echo "  ✓ Job completado. Resultados en: $SALIDA_HDFS"

    # Mostrar resultado
    echo "  ── Muestra del resultado:"
    hdfs dfs -cat $SALIDA_HDFS/part-r-00000 | head -10
}

# ─────────────────────────────────────────────────────────────
# PREPARACIÓN
# ─────────────────────────────────────────────────────────────
mkdir -p jars /tmp/mr_build

echo ""
echo "Classpath de Hadoop:"
echo "$CLASSPATH" | tr ':' '\n' | head -5

# ─────────────────────────────────────────────────────────────
# JOB 01: Conteo por Género
# ─────────────────────────────────────────────────────────────
compilar_job "01_conteo_por_genero" "ConteoGenero" "conteo_genero"
ejecutar_job "ConteoGenero.jar" \
             "conteo_genero.ConteoGenero" \
             "$HDFS_BASE/job01_generos" \
             "Job 01 — Conteo de Contenido por Género"

# ─────────────────────────────────────────────────────────────
# JOB 02: Promedio de Puntuación por País
# ─────────────────────────────────────────────────────────────
compilar_job "02_promedio_puntuacion" "PromedioPuntuacion" "promedio_puntuacion"
ejecutar_job "PromedioPuntuacion.jar" \
             "promedio_puntuacion.PromedioPuntuacion" \
             "$HDFS_BASE/job02_puntuacion" \
             "Job 02 — Promedio de Puntuación por País"

# ─────────────────────────────────────────────────────────────
# JOB 03: Análisis de Ingresos por Director
# ─────────────────────────────────────────────────────────────
compilar_job "03_analisis_ingresos" "AnalisisIngresos" "analisis_ingresos"
ejecutar_job "AnalisisIngresos.jar" \
             "analisis_ingresos.AnalisisIngresos" \
             "$HDFS_BASE/job03_ingresos" \
             "Job 03 — Análisis de Ingresos por Director"

# ─────────────────────────────────────────────────────────────
# JOB 04: Top 10 Contenido Más Visto
# ─────────────────────────────────────────────────────────────
compilar_job "04_top_vistas" "TopVistas" "top_vistas"
ejecutar_job "TopVistas.jar" \
             "top_vistas.TopVistas" \
             "$HDFS_BASE/job04_top_vistas" \
             "Job 04 — Top 10 Contenido Más Visto"

# ─────────────────────────────────────────────────────────────
# JOB 05: Tendencias por Año
# ─────────────────────────────────────────────────────────────
compilar_job "05_tendencias_anio" "TendenciasAnio" "tendencias_anio"
ejecutar_job "TendenciasAnio.jar" \
             "tendencias_anio.TendenciasAnio" \
             "$HDFS_BASE/job05_tendencias" \
             "Job 05 — Tendencias de Producción por Año"

# ─────────────────────────────────────────────────────────────
# RESUMEN FINAL
# ─────────────────────────────────────────────────────────────
echo ""
echo "======================================================"
echo "  TODOS LOS JOBS COMPLETADOS EXITOSAMENTE"
echo "======================================================"
echo ""
echo "Resultados disponibles en HDFS:"
hdfs dfs -ls $HDFS_BASE/

echo ""
echo "Para descargar resultados ejecutar:"
echo "  bash hadoop/comandos_hdfs.sh"
echo "======================================================"
