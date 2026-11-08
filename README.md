# Analisis de Big Data con Apache Hadoop y MapReduce
### Plataforma de Streaming - Procesamiento Distribuido

---

## Descripcion del Proyecto

Practica de analisis de grandes volumenes de datos utilizando el paradigma **MapReduce** sobre un dataset de contenido de streaming (peliculas y series). El proyecto implementa 5 analisis distribuidos en Java para Hadoop 3.x y una simulacion local en Python, aplicando conceptos de Big Data para la toma de decisiones sobre el comportamiento del catalogo de una plataforma de streaming.

**Institucion:** [Nombre de la Universidad]
**Materia:** Big Data — Analisis
**Autor:** Diego
**Ano:** 2026

---

## Estructura del Proyecto

```
TAREABIG/
├── datos/
│   ├── peliculas_dataset.csv          Dataset original (13 registros)
│   ├── peliculas_dataset.json         Dataset original en JSON
│   └── streaming_ampliado.csv         Dataset ampliado (93 registros)
├── mapreduce/
│   ├── 01_conteo_por_genero/
│   │   └── ConteoGenero.java          Job 01: Conteo por genero
│   ├── 02_promedio_puntuacion/
│   │   └── PromedioPuntuacion.java    Job 02: Promedio por pais
│   ├── 03_analisis_ingresos/
│   │   └── AnalisisIngresos.java      Job 03: Ingresos por director
│   ├── 04_top_vistas/
│   │   └── TopVistas.java             Job 04: Top 10 mas vistos
│   └── 05_tendencias_anio/
│       └── TendenciasAnio.java        Job 05: Tendencias por anio
├── hadoop/
│   ├── configuracion_hadoop.md        Guia de instalacion y config
│   ├── comandos_hdfs.sh               Comandos de gestion HDFS
│   └── ejecucion_jobs.sh              Compilacion y ejecucion Jobs
├── python/
│   ├── mapreduce_simulado.py          Simulacion local (sin Hadoop)
│   ├── analisis_resultados.py         Visualizaciones con matplotlib
│   └── requirements.txt
└── resultados/
    ├── resultado_conteo_genero.txt
    ├── resultado_promedio_puntuacion.txt
    ├── resultado_ingresos.txt
    ├── resultado_top_vistas.txt
    ├── resultado_tendencias.txt
    └── dashboard_mapreduce.html       Dashboard interactivo (abrir en navegador)
```

---

## Jobs MapReduce Implementados

| # | Clase Java | Analisis | Clave Map | Valor Map | Salida |
|---|-----------|----------|-----------|-----------|--------|
| 01 | `ConteoGenero` | Conteo por genero | genero | 1 | (genero, conteo) |
| 02 | `PromedioPuntuacion` | Promedio por pais | pais | puntuacion | (pais, promedio+stats) |
| 03 | `AnalisisIngresos` | Ingresos por director | director | presup\|recaud | (director, financiero) |
| 04 | `TopVistas` | Top 10 mas vistos | titulo[tipo] | vistas | (posicion, vistas) |
| 05 | `TendenciasAnio` | Produccion por anio | anio | tipo\|punt\|vistas | (anio, stats) |

---

## Ejecucion Rapida — Simulacion Python (Sin Hadoop requerido)

```bash
# 1. Instalar dependencias
pip install -r python/requirements.txt

# 2. Ejecutar simulacion MapReduce local
python python/mapreduce_simulado.py

# 3. Generar graficos de analisis
python python/analisis_resultados.py
```

Los resultados se guardan en la carpeta `resultados/`.
El dashboard interactivo `resultados/dashboard_mapreduce.html` se abre directamente en el navegador.

---

## Ejecucion con Hadoop Real

### Requisitos previos
- Apache Hadoop 3.3.6
- Java JDK 11
- Ubuntu 22.04 / WSL2 con SSH sin contrasena configurado

### Pasos de ejecucion

```bash
# 1. Iniciar servicios Hadoop
start-dfs.sh && start-yarn.sh

# 2. Verificar servicios activos
jps
# NameNode, DataNode, ResourceManager, NodeManager

# 3. Cargar datos en HDFS
bash hadoop/comandos_hdfs.sh

# 4. Compilar y ejecutar los 5 Jobs
bash hadoop/ejecucion_jobs.sh

# 5. Ver resultado del Job 01
hdfs dfs -cat /user/estudiante/streaming/resultados/job01_generos/part-r-00000
```

Ver `hadoop/configuracion_hadoop.md` para la configuracion completa de core-site.xml, hdfs-site.xml, mapred-site.xml y yarn-site.xml.

---

## Hallazgos Principales del Analisis

### Analisis 1 — Generos mas populares
> **Drama** es el genero mas representado con **59 titulos**, seguido de **Accion** (45) y **Thriller** (38). La combinacion Drama+Thriller cubre el 32.2% del catalogo.

### Analisis 2 — Calidad por pais
> **Reino Unido** lidera calidad con promedio **8.73** en 10 titulos (Chernobyl 9.4, Sherlock 9.1). **Estados Unidos** domina en volumen (45 titulos, prom. 8.37).

### Analisis 3 — Rentabilidad por director
> **Christopher Nolan** acumula **3.61 billones USD** con 5 peliculas. **Makoto Shinkai** logra el mejor ROI: **51x** (Your Name: 7M presupuesto — 357M recaudacion).

### Analisis 4 — Contenido mas visto
> Las **10 posiciones del Top son series**. Squid Game lidera con **111 millones** de visualizaciones. Ninguna pelicula alcanza el Top 10.

### Analisis 5 — Tendencias historicas
> **2019** fue el ano mas productivo (10 titulos). Las series dominan desde 2015. Los clasicos de **1994** mantienen la puntuacion promedio mas alta (8.97).

---

## Dataset

El dataset `streaming_ampliado.csv` contiene **93 registros** (45 peliculas + 48 series):

```
titulo, tipo, anio, director, genero_1, genero_2, genero_3,
idioma, puntuacion, vistas, duracion_min, temporadas,
episodios, clasificacion, pais, presupuesto_usd, recaudacion_usd
```

**Paises:** Estados Unidos, Reino Unido, Corea del Sur, Espana, Japon,
Alemania, Francia, India, Colombia, Mexico, Brasil, Italia, Australia, Israel (14 paises)

---

## Paradigma MapReduce — Flujo de Procesamiento

```
Input CSV (HDFS)
      |
      v
  [MAPPER]  ----> Emite pares (clave, valor)
      |             Ej: ("Drama", 1), ("Accion", 1)
      |
  [SHUFFLE] ----> Agrupa y ordena por clave
      |             Ej: "Drama" -> [1, 1, 1, ...]
      |
  [REDUCER] ----> Procesa cada grupo
      |             Ej: "Drama" -> 59
      v
 Output HDFS (part-r-00000)
```

---

## Referencias

- Apache Hadoop Documentation: https://hadoop.apache.org/docs/
- MapReduce Tutorial: https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html
- Dean, J. & Ghemawat, S. (2004). MapReduce: Simplified Data Processing on Large Clusters. OSDI'04.
- White, T. (2015). Hadoop: The Definitive Guide (4th ed.). O'Reilly Media.
