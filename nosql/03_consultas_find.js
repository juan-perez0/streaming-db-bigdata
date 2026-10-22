// ============================================================
// SCRIPT 03: MONGODB - CONSULTAS (FIND, FILTROS, PROYECCIONES)
// Base de datos: streaming_db
// ============================================================

const db = connect("mongodb://localhost:27017/streaming_db");

// ============================================================
// EJERCICIO 1: Consulta básica - Listar todos los documentos
// ============================================================
db.peliculas.find().pretty()

// ============================================================
// EJERCICIO 2: Filtro simple - Solo películas (no series)
// ============================================================
db.peliculas.find(
  { tipo: "pelicula" },
  { titulo: 1, anio_estreno: 1, puntuacion: 1, _id: 0 }
).sort({ puntuacion: -1 })

// ============================================================
// EJERCICIO 3: Operadores de comparación
// Contenido con puntuación mayor o igual a 8.5
// ============================================================
db.peliculas.find(
  { puntuacion: { $gte: 8.5 } },
  { titulo: 1, tipo: 1, puntuacion: 1, vistas: 1, _id: 0 }
).sort({ puntuacion: -1 })

// ============================================================
// EJERCICIO 4: Operador $in - Contenido de géneros específicos
// ============================================================
db.peliculas.find(
  { generos: { $in: ["Ciencia Ficción", "Thriller"] } },
  { titulo: 1, generos: 1, puntuacion: 1, _id: 0 }
).sort({ puntuacion: -1 })

// ============================================================
// EJERCICIO 5: Operadores $and y $or
// Series con puntuación > 8.5 O películas de habla hispana
// ============================================================
db.peliculas.find({
  $or: [
    { $and: [{ tipo: "serie" }, { puntuacion: { $gt: 8.5 } }] },
    { $and: [{ tipo: "pelicula" }, { idioma: "Español" }] }
  ]
}, { titulo: 1, tipo: 1, idioma: 1, puntuacion: 1, _id: 0 })

// ============================================================
// EJERCICIO 6: Filtrar por campo de documento anidado
// Usuarios con notificaciones activas
// ============================================================
db.usuarios.find(
  { "preferencias.notificaciones": true, activo: true },
  { nombre: 1, pais: 1, plan: 1, "preferencias.generos_favoritos": 1, _id: 0 }
).sort({ nombre: 1 })

// ============================================================
// EJERCICIO 7: Operador $elemMatch - Usuarios que tienen Smart TV
// ============================================================
db.usuarios.find(
  { dispositivos: { $elemMatch: { $eq: "Smart TV" } } },
  { nombre: 1, plan: 1, dispositivos: 1, _id: 0 }
)

// ============================================================
// EJERCICIO 8: Buscar por rango de fechas
// Usuarios registrados en 2024 con plan Premium o Familiar
// ============================================================
db.usuarios.find({
  fecha_registro: {
    $gte: new Date("2024-01-01"),
    $lte: new Date("2024-12-31")
  },
  plan: { $in: ["Premium", "Familiar"] }
}, { nombre: 1, email: 1, plan: 1, fecha_registro: 1, _id: 0 }).sort({ fecha_registro: 1 })

// ============================================================
// EJERCICIO 9: Proyección con campos calculados (limit y skip)
// Top 5 contenido más visto
// ============================================================
db.peliculas.find(
  {},
  { titulo: 1, tipo: 1, vistas: 1, puntuacion: 1, generos: 1, _id: 0 }
).sort({ vistas: -1 }).limit(5)

// ============================================================
// EJERCICIO 10: Búsqueda por texto parcial (regex)
// Contenido cuyo director contiene "Nolan"
// ============================================================
db.peliculas.find(
  { director: { $regex: "Nolan", $options: "i" } },
  { titulo: 1, director: 1, anio_estreno: 1, puntuacion: 1, _id: 0 }
)

// ============================================================
// EJERCICIO 11: Consultar temporadas de una serie específica
// ============================================================
db.peliculas.find(
  { titulo: "Breaking Bad" },
  { titulo: 1, temporadas_detalle: 1, total_episodios: 1, _id: 0 }
).pretty()

// ============================================================
// EJERCICIO 12: Contar documentos con countDocuments
// ============================================================
print("Total películas:              " + db.peliculas.countDocuments({ tipo: "pelicula" }))
print("Total series:                 " + db.peliculas.countDocuments({ tipo: "serie" }))
print("Contenido puntuación >= 8.5:  " + db.peliculas.countDocuments({ puntuacion: { $gte: 8.5 } }))
print("Usuarios activos:             " + db.usuarios.countDocuments({ activo: true }))
print("Usuarios Premium:             " + db.usuarios.countDocuments({ plan: "Premium" }))
