# 🎬 Sistema de Streaming — Bases de Datos NewSQL & NoSQL

> **Informe de práctica** | Manejo de bases de datos NewSQL y NoSQL en entornos Big Data  
> **Herramientas:** Oracle SQL Developer · MongoDB Compass  
> **Tema:** Plataforma de Streaming (Películas y Series)

---

## 📋 Descripción del Proyecto

Este repositorio contiene todos los scripts, datasets y recursos utilizados en la práctica de bases de datos relacionales (NewSQL) y no relacionales (NoSQL), aplicados a un sistema de gestión de una plataforma de streaming de video similar a Netflix/HBO.

El proyecto implementa un modelo completo de base de datos que incluye:
- Gestión de **usuarios y planes de suscripción**
- Catálogo de **películas y series** con géneros
- **Historial de reproducción** y calificaciones
- **Temporadas y episodios** para series

---

## 🗂️ Estructura del Repositorio

```
📦 streaming-db-bigdata/
├── 📁 sql/                          # Scripts Oracle SQL Developer (NewSQL)
│   ├── 01_crear_tablas.sql          # Creación de tablas y restricciones
│   ├── 02_insertar_datos.sql        # Datos de prueba (INSERT)
│   ├── 03_consultas_select.sql      # Consultas SELECT, JOIN, GROUP BY
│   └── 04_update_delete_plsql.sql   # UPDATE, DELETE, PL/SQL, Procedimientos
│
├── 📁 nosql/                        # Scripts MongoDB Compass (NoSQL)
│   ├── 01_crear_colecciones.js      # Crear DB, colecciones e índices
│   ├── 02_insertar_documentos.js    # Insertar documentos (insertMany)
│   ├── 03_consultas_find.js         # Consultas con find, filtros, proyecciones
│   └── 04_update_delete_aggregations.js  # Update, delete y aggregation pipelines
│
├── 📁 datos/                        # Datasets utilizados
│   └── peliculas_dataset.json       # Dataset JSON para importar en MongoDB
│
├── 📁 capturas/                     # Evidencias visuales del desarrollo
│   └── (capturas de pantalla)
│
└── 📄 README.md                     # Este archivo
```

---

## 🛠️ Tecnologías Utilizadas

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| Oracle SQL Developer | 23.x | Gestión de base de datos NewSQL |
| Oracle Database XE | 21c | Motor de base de datos relacional |
| MongoDB | 7.x | Base de datos NoSQL documental |
| MongoDB Compass | 1.x | IDE visual para MongoDB |

---

## 🏗️ Parte I — NewSQL (Oracle SQL Developer)

### Modelo Entidad-Relación

```
PLANES ──< USUARIOS >──< HISTORIAL_REPRODUCCION >── CONTENIDO ──< CONTENIDO_GENERO >── GENEROS
                                                        │
                                                   TEMPORADAS ──< EPISODIOS
                                                        │
                                               CALIFICACIONES (USUARIOS + CONTENIDO)
```

### Tablas Implementadas

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `PLANES` | Planes de suscripción (Básico/Estándar/Premium/Familiar) | 4 |
| `USUARIOS` | Usuarios registrados en la plataforma | 10 |
| `GENEROS` | Géneros cinematográficos | 10 |
| `CONTENIDO` | Películas y series disponibles | 13 |
| `CONTENIDO_GENERO` | Relación N:M contenido-géneros | 33 |
| `TEMPORADAS` | Temporadas de series | 7 |
| `EPISODIOS` | Episodios por temporada | 15 |
| `HISTORIAL_REPRODUCCION` | Registro de reproducciones | 15 |
| `CALIFICACIONES` | Puntuaciones y reseñas | 12 |

### Ejercicios SQL Desarrollados

1. ✅ **Creación de tablas** con llaves primarias, foráneas y restricciones CHECK
2. ✅ **INSERT masivo** de datos de prueba
3. ✅ **SELECT + WHERE + ORDER BY** — Filtrado y ordenamiento básico
4. ✅ **GROUP BY + HAVING** — Agregaciones y filtros de grupos
5. ✅ **JOIN múltiple** — Consultas relacionales entre varias tablas
6. ✅ **Subconsultas** — Filtros basados en consultas anidadas
7. ✅ **CASE expressions** — Categorización dinámica de datos
8. ✅ **UPDATE** — Actualización de registros individuales y masivos
9. ✅ **DELETE** — Eliminación con condiciones
10. ✅ **Bloque PL/SQL** — Lógica procedural con DBMS_OUTPUT
11. ✅ **Procedimiento almacenado** — `registrar_reproduccion()`
12. ✅ **Función** — `calcular_porcentaje_visto()`

---

## 🍃 Parte II — NoSQL (MongoDB Compass)

### Modelo de Documentos

```json
// Colección: peliculas
{
  "titulo": "Breaking Bad",
  "tipo": "serie",
  "generos": ["Drama", "Thriller"],
  "puntuacion": 9.5,
  "temporadas_detalle": [
    { "numero": 1, "episodios": 7 }
  ],
  "metadata": { "emmys_ganados": 16 }
}

// Colección: usuarios
{
  "nombre": "Camila Torres",
  "plan": "Estándar",
  "preferencias": {
    "generos_favoritos": ["Acción", "Thriller"],
    "notificaciones": true
  },
  "dispositivos": ["Smart TV", "Smartphone"]
}
```

### Colecciones Implementadas

| Colección | Descripción | Documentos |
|-----------|-------------|-----------|
| `peliculas` | Catálogo de películas y series con datos anidados | 10 |
| `usuarios` | Perfiles de usuario con preferencias y dispositivos | 8 |
| `calificaciones` | Reseñas de usuarios sobre el contenido | 8 |
| `historial` | Registro de reproducciones | — |

### Ejercicios MongoDB Desarrollados

1. ✅ **Crear BD y colecciones** con validación de esquema JSON
2. ✅ **Crear índices** únicos y simples
3. ✅ **insertOne / insertMany** — Inserción de documentos simples y complejos
4. ✅ **find + proyecciones** — Consultas con campos seleccionados
5. ✅ **Operadores**: `$gt`, `$gte`, `$in`, `$and`, `$or`, `$elemMatch`, `$regex`
6. ✅ **Filtros en campos anidados** — `"preferencias.notificaciones": true`
7. ✅ **Filtros por fecha** — Rangos con `$gte` y `$lte`
8. ✅ **updateOne / updateMany** — Con `$set`, `$push`, `$mul`
9. ✅ **deleteOne / deleteMany** — Eliminación con condiciones
10. ✅ **Aggregation Pipeline** — `$group`, `$project`, `$sort`, `$match`
11. ✅ **$unwind** — Descomposición de arrays
12. ✅ **$lookup** — Simulación de JOIN entre colecciones
13. ✅ **$facet** — Múltiples análisis en paralelo

---

## 📊 Dataset de Películas

El archivo `datos/peliculas_dataset.json` contiene **13 registros** de películas y series para importar directamente en MongoDB Compass.

**Fuente de datos:** Datos curados manualmente basados en información pública de IMDb y plataformas de streaming.

**Campos incluidos:** título, tipo, año, director, géneros, idioma, puntuación, vistas, duración/temporadas, clasificación, país, presupuesto y recaudación.

---

## 🚀 Cómo Ejecutar

### SQL (Oracle SQL Developer)
```
1. Abrir Oracle SQL Developer
2. Crear conexión a Oracle XE (puerto 1521, SID: XE)
3. Abrir cada script en orden: 01 → 02 → 03 → 04
4. Ejecutar con F5 o Ctrl+Enter
```

### NoSQL (MongoDB Compass)
```
1. Abrir MongoDB Compass
2. Conectar a: mongodb://localhost:27017
3. Ir a MongoShell (botón ">_" inferior)
4. Copiar y pegar cada script .js en orden
5. Para importar dataset: Collections → ADD DATA → Import JSON File
   → Seleccionar datos/peliculas_dataset.json
```

---

## 📚 Referencias

- Oracle. (2023). *Oracle SQL Developer User's Guide*. Oracle Documentation.
- MongoDB. (2023). *MongoDB Manual 7.0*. MongoDB Inc. https://www.mongodb.com/docs/
- Sadalage, P. J., & Fowler, M. (2012). *NoSQL Distilled: A Brief Guide to the Emerging World of Polyglot Persistence*. Addison-Wesley.
- Date, C. J. (2004). *An Introduction to Database Systems* (8th ed.). Pearson Education.
- Stonebraker, M., & Cattell, R. (2011). 10 Rules for Scalable Performance in 'Simple Operation' Datastores. *Communications of the ACM, 54*(6), 72–80.

---

## 👤 Autor

**Diego** | Práctica — Bases de Datos NewSQL y NoSQL  
Semanas 10, 11 y 12 — Big Data  
