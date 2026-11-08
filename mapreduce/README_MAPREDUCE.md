# Proyecto MapReduce - Análisis de Datos de Plataformas de Streaming

Este proyecto contiene **5 programas MapReduce** desarrollados en Java para Apache Hadoop 3.x. Cada programa analiza un aspecto diferente de un dataset CSV con información de contenidos de plataformas de streaming.

## Estructura del Dataset (CSV)

El archivo de entrada es un CSV con las siguientes columnas:

| # | Columna | Descripción |
|---|---------|-------------|
| 0 | `titulo` | Nombre del contenido |
| 1 | `tipo` | Tipo de contenido (película, serie, etc.) |
| 2 | `anio` | Año de lanzamiento |
| 3 | `director` | Director del contenido |
| 4 | `genero_1` | Género principal |
| 5 | `genero_2` | Género secundario |
| 6 | `genero_3` | Género terciario |
| 7 | `idioma` | Idioma del contenido |
| 8 | `puntuacion` | Puntuación (rating) |
| 9 | `vistas` | Número de vistas |
| 10 | `duracion_min` | Duración en minutos |
| 11 | `temporadas` | Número de temporadas |
| 12 | `episodios` | Número de episodios |
| 13 | `clasificacion` | Clasificación por edades |
| 14 | `pais` | País de origen |
| 15 | `presupuesto_usd` | Presupuesto en USD |
| 16 | `recaudacion_usd` | Recaudación en USD |

---

## 🔧 Requisitos Previos

- **Apache Hadoop 3.x** instalado y configurado
- **Java JDK 8+**
- Las variables de entorno `HADOOP_HOME` y `JAVA_HOME` correctamente configuradas

---

## Compilación General

Para compilar cualquiera de los programas:

```bash
# Navegar al directorio del programa
cd mapreduce/01_conteo_por_genero/

# Compilar con las librerías de Hadoop en el classpath
javac -classpath $(hadoop classpath) -d . ConteoGenero.java

# Crear el archivo JAR
jar cf ConteoGenero.jar ConteoGenero*.class
```

---

## 1. Conteo por Género (`01_conteo_por_genero/ConteoGenero.java`)

### Propósito
Cuenta la cantidad total de contenidos asociados a cada género. Considera los tres campos de género (`genero_1`, `genero_2`, `genero_3`), omitiendo los que estén vacíos.

### ¿Cómo funciona?
- **Mapper**: Lee cada fila del CSV y emite un par `(género, 1)` por cada género no vacío encontrado en las columnas `genero_1`, `genero_2` y `genero_3`.
- **Combiner**: Se usa el mismo Reducer como Combiner para optimizar la transferencia de datos entre Mapper y Reducer (pre-agregación local).
- **Reducer**: Suma todos los valores `1` asociados a cada género para obtener el conteo total.

### Entrada / Salida
- **Entrada**: Archivo CSV del dataset
- **Salida**: `género \t conteo`

### Ejecución
```bash
hadoop jar ConteoGenero.jar ConteoGenero /entrada/dataset.csv /salida/conteo_genero
```

### Ejemplo de salida
```
Acción    245
Comedia   312
Drama     478
Terror    156
```

---

## 2. Promedio de Puntuación por País (`02_promedio_puntuacion/PromedioPuntuacion.java`)

### Propósito
Calcula la puntuación promedio de los contenidos agrupados por país de origen.

### ¿Cómo funciona?
- **Mapper**: Lee cada fila y emite `(país, "puntuación,1")`. El valor es un texto compuesto que contiene la puntuación y un contador (1) separados por coma.
- **Reducer**: Parsea cada valor recibido, acumula la suma total de puntuaciones y el conteo de registros. Calcula el promedio dividiendo la suma entre el conteo.

### Entrada / Salida
- **Entrada**: Archivo CSV del dataset
- **Salida**: `país \t promedio_puntuación`

### Ejecución
```bash
hadoop jar PromedioPuntuacion.jar PromedioPuntuacion /entrada/dataset.csv /salida/promedio_puntuacion
```

### Ejemplo de salida
```
Estados Unidos    7.25
México            6.80
España            7.10
```

---

## 3. Análisis de Ingresos por Director (`03_analisis_ingresos/AnalisisIngresos.java`)

### Propósito
Analiza los ingresos (recaudación) de cada director, calculando la recaudación total, el número de películas y la recaudación promedio.

### ¿Cómo funciona?
- **Mapper**: Lee cada fila y emite `(director, recaudación_usd)`. Se omiten las filas donde la recaudación está vacía o no es un valor numérico válido.
- **Reducer**: Acumula la recaudación total y cuenta el número de películas por director. Calcula el promedio y genera una salida con las tres métricas separadas por `|`.

### Entrada / Salida
- **Entrada**: Archivo CSV del dataset
- **Salida**: `director \t total_recaudacion | num_peliculas | promedio_recaudacion`

### Ejecución
```bash
hadoop jar AnalisisIngresos.jar AnalisisIngresos /entrada/dataset.csv /salida/analisis_ingresos
```

### Ejemplo de salida
```
Christopher Nolan    2500000000.00 | 8 | 312500000.00
Steven Spielberg     4100000000.00 | 12 | 341666666.67
```

---

## 4. Top 10 Contenidos Más Vistos (`04_top_vistas/TopVistas.java`)

### Propósito
Determina los 10 contenidos con mayor número de vistas en todo el dataset.

### ¿Cómo funciona?
- **Mapper**: Lee cada fila y mantiene un **TreeMap local** con los 10 títulos más vistos que ha encontrado. En el método `cleanup()` (que se ejecuta al finalizar el mapper), emite estos 10 candidatos con clave `NullWritable`.
- **Reducer**: Recibe todos los candidatos de los diferentes mappers y mantiene un **TreeMap global** con los 10 definitivos. En su propio `cleanup()` emite el resultado final en orden descendente.
- Se utiliza **un solo reducer** (`setNumReduceTasks(1)`) para garantizar un orden global correcto.

### Entrada / Salida
- **Entrada**: Archivo CSV del dataset
- **Salida**: `titulo \t vistas vistas` (ordenado de mayor a menor)

### Ejecución
```bash
hadoop jar TopVistas.jar TopVistas /entrada/dataset.csv /salida/top_vistas
```

### Ejemplo de salida
```
Stranger Things     150000000 vistas
La Casa de Papel    120000000 vistas
The Witcher         95000000 vistas
```

---

## 5. Tendencias por Año (`05_tendencias_anio/TendenciasAnio.java`)

### Propósito
Analiza las tendencias de la industria del streaming a lo largo de los años, mostrando cuántos contenidos se lanzaron cada año y cuál fue su puntuación promedio.

### ¿Cómo funciona?
- **Mapper**: Lee cada fila y emite `(año, "puntuación,1")`. Valida que tanto el año como la puntuación sean valores numéricos válidos antes de emitir.
- **Reducer**: Parsea los valores recibidos, acumula la suma de puntuaciones y el conteo de lanzamientos. Genera una salida con el número de lanzamientos y la puntuación promedio separados por `|`.

### Entrada / Salida
- **Entrada**: Archivo CSV del dataset
- **Salida**: `año \t num_lanzamientos | promedio_puntuación`

### Ejecución
```bash
hadoop jar TendenciasAnio.jar TendenciasAnio /entrada/dataset.csv /salida/tendencias_anio
```

### Ejemplo de salida
```
2018    45 | 6.75
2019    62 | 7.10
2020    78 | 6.90
2021    95 | 7.25
2022    110 | 7.05
```

---

## Resumen de los Programas

| # | Programa | Clave Map | Valor Map | Métrica Principal |
|---|----------|-----------|-----------|-------------------|
| 1 | ConteoGenero | género | 1 | Conteo por género |
| 2 | PromedioPuntuacion | país | puntuación,1 | Promedio de puntuación por país |
| 3 | AnalisisIngresos | director | recaudación | Ingresos totales/promedio por director |
| 4 | TopVistas | NullWritable | vistas+título | Top 10 más vistos |
| 5 | TendenciasAnio | año | puntuación,1 | Lanzamientos y promedio por año |

---

## Notas Importantes

1. **Cabecera del CSV**: Todos los programas detectan y omiten automáticamente la línea de cabecera del archivo CSV.
2. **Datos vacíos**: Los campos vacíos o con valores no numéricos se ignoran de manera segura sin interrumpir la ejecución.
3. **Formato de separación**: Se asume que el CSV usa comas (`,`) como separador de campos.
4. **Directorio de salida**: El directorio de salida de HDFS **no debe existir** previamente. Hadoop lo crea automáticamente.
5. **Codificación**: Los archivos están preparados para trabajar con texto en formato UTF-8.

