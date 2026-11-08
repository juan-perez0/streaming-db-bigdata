# Análisis de Big Data con Apache Hadoop y MapReduce
### Plataforma de Streaming — Procesamiento Distribuido

---

## 📋 Descripción del Proyecto

Práctica de análisis de grandes volúmenes de datos utilizando el paradigma **MapReduce** sobre un dataset de contenido de streaming (películas y series). El proyecto implementa 5 análisis distribuidos en Java para Hadoop 3.x y una simulación local en Python, aplicando conceptos de Big Data para la toma de decisiones sobre el comportamiento del catálogo de una plataforma de streaming.

**Institución:** [Nombre de la Universidad]  
**Materia:** Big Data — Análisis  
**Autor:** Diego  
**Año:** 2026

---

## 🗂️ Estructura del Proyecto

```
TAREABIG/
├── datos/
│   ├── peliculas_dataset.csv          Dataset original (13 registros)
│   ├── peliculas_dataset.json         Dataset original en JSON
│   └── streaming_ampliado.csv         Dataset ampliado (97 registros)
├── mapreduce/
│   ├── 01_conteo_por_genero/
│   │   └── ConteoGenero.java          Job 01: Conteo por género
│   ├── 02_promedio_puntuacion/
│   │   └── PromedioPuntuacion.java    Job 02: Promedio por país
│   ├── 03_analisis_ingresos/
│   │   └── AnalisisIngresos.java      Job 03: Ingresos por director
│   ├── 04_top_vistas/
│   │   └── TopVistas.java             Job 04: Top 10 más vistos
│   └── 05_tendencias_anio/
│       └── TendenciasAnio.java        Job 05: Tendencias por año
├── hadoop/
│   ├── configuracion_hadoop.md        Guía de instalación y config
│   ├── comandos_hdfs.sh               Comandos de gestión HDFS
│   └── ejecucion_jobs.sh              Compilación y ejecución Jobs
├── python/
│   ├── mapreduce_simulado.py          Simulación local (sin Hadoop)
│   ├── analisis_resultados.py         Visualizaciones con matplotlib
│   └── requirements.txt
└── resultados/
    ├── resultado_conteo_genero.txt
    ├── resultado_promedio_puntuacion.txt
    ├── resultado_ingresos.txt
    ├── resultado_top_vistas.txt
    └── resultado_tendencias.txt
```

---

## 🧩 Jobs MapReduce Implementados

| # | Job | Análisis | Input | Output |
|---|-----|----------|-------|--------|
| 01 | `ConteoGenero` | Conteo de títulos por género | CSV | (género, conteo) |
| 02 | `PromedioPuntuacion` | Puntuación promedio por país | CSV | (país, stats) |
| 03 | `AnalisisIngresos` | Ingresos y ROI por director | CSV | (director, financiero) |
| 04 | `TopVistas` | Top 10 contenido más visto | CSV | (posición, vistas) |
| 05 | `TendenciasAnio` | Producción y métricas por año | CSV | (año, stats) |

---

## ⚡ Ejecución Rápida (Simulación Python — Sin Hadoop)

```bash
# 1. Instalar dependencias
pip install -r python/requirements.txt

# 2. Ejecutar simulación MapReduce
python python/mapreduce_simulado.py

# 3. Generar gráficos de análisis
python python/analisis_resultados.py
```

Los resultados se guardan automáticamente en la carpeta `resultados/`.

---

## 🐘 Ejecución con Hadoop Real

### Requisitos
- Apache Hadoop 3.3.6
- Java JDK 11
- Ubuntu/WSL con SSH configurado

### Pasos

```bash
# 1. Configurar Hadoop (ver hadoop/configuracion_hadoop.md)
start-dfs.sh && start-yarn.sh

# 2. Cargar datos en HDFS
bash hadoop/comandos_hdfs.sh

# 3. Compilar y ejecutar todos los Jobs
bash hadoop/ejecucion_jobs.sh

# 4. Ver resultados
hdfs dfs -cat /user/estudiante/streaming/resultados/job01_generos/part-r-00000
```

---

## 📊 Hallazgos Principales

### Análisis 1 — Géneros más populares
> **Drama** es el género más representado con **59 títulos** (19.6%), seguido de **Acción** (45) y **Thriller** (38). La combinación Drama+Thriller cubre el 32.2% del catálogo.

### Análisis 2 — Calidad por país
> **Reino Unido** lidera en calidad con promedio **8.73** en 10 títulos. **India** destaca con 8.37 en 6 producciones. **Estados Unidos** domina en volumen (51 títulos, prom. 8.37).

### Análisis 3 — Rentabilidad por director
> **Christopher Nolan** acumula **$3.61B USD** en recaudación con 5 películas. **Makoto Shinkai** logra el mejor ROI: **51.13x** (*Your Name*: $7M → $357M).

### Análisis 4 — Contenido más visto
> Las **10 posiciones del top son series**. *Squid Game* lidera con **111 millones** de visualizaciones. Las películas más vistas no alcanzan el Top 10.

### Análisis 5 — Tendencias históricas
> **2019** fue el año más productivo (10 títulos). Los clásicos de **1994** (Shawshank, Forrest Gump, Pulp Fiction) mantienen el promedio de puntuación más alto (8.97).

---

## 🗃️ Dataset

El dataset `streaming_ampliado.csv` contiene **97 registros** de películas y series de distintos países con los siguientes campos:

```
titulo, tipo, anio, director, genero_1, genero_2, genero_3,
idioma, puntuacion, vistas, duracion_min, temporadas,
episodios, clasificacion, pais, presupuesto_usd, recaudacion_usd
```

**Países representados:** Estados Unidos, Reino Unido, Corea del Sur, España, Japón, Alemania, Francia, India, Colombia, México, Brasil, Italia, Australia, Israel, Austria

---

## 🔧 Paradigma MapReduce

```
Input CSV
    │
    ▼
 [MAPPER]  ──────► Emite pares (clave, valor)
    │                Ej: ("Drama", 1), ("Drama", 1)
    │
 [SHUFFLE]  ─────► Agrupa por clave
    │                Ej: "Drama" → [1, 1, 1, ...]
    │
 [REDUCER]  ─────► Procesa cada grupo
    │                Ej: "Drama" → 59
    ▼
 Output HDFS
```

---

## 📚 Referencias

- Apache Hadoop Documentation: https://hadoop.apache.org/docs/
- MapReduce Tutorial: https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html
- Dean, J. & Ghemawat, S. (2004). *MapReduce: Simplified Data Processing on Large Clusters*. OSDI'04.
