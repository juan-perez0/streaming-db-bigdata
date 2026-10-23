// ============================================================
// SCRIPT 04: MONGODB - UPDATE, DELETE Y AGGREGATIONS
// Base de datos: streaming_db
// ============================================================

const db = connect("mongodb://localhost:27017/streaming_db");

// ============================================================
// EJERCICIO 13: updateOne - Actualizar un documento
// ============================================================

// 13a. Actualizar puntuación de Inception
db.peliculas.updateOne(
  { titulo: "Inception" },
  {
    $set: {
      puntuacion: 9.0,
      "metadata.ultima_actualizacion": new Date()
    }
  }
)

// 13b. Agregar una nueva plataforma a Parasite
db.peliculas.updateOne(
  { titulo: "Parasite" },
  { $push: { plataformas_disponibles: "Chromecast" } }
)

// Verificar cambio
db.peliculas.findOne({ titulo: "Inception" }, { titulo: 1, puntuacion: 1, _id: 0 })

// ============================================================
// EJERCICIO 14: updateMany - Actualizar múltiples documentos
// ============================================================

// 14a. Aumentar vistas en 10% a todo el contenido disponible
db.peliculas.updateMany(
  { disponible: true },
  { $mul: { vistas: 1.1 } }
)

// 14b. Agregar campo "destacado" a contenido con puntuación >= 9.0
db.peliculas.updateMany(
  { puntuacion: { $gte: 9.0 } },
  { $set: { destacado: true } }
)

// 14c. Activar notificaciones para usuarios de Colombia
db.usuarios.updateMany(
  { pais: "Colombia" },
  { $set: { "preferencias.notificaciones": true } }
)

// ============================================================
// EJERCICIO 15: deleteOne y deleteMany
// ============================================================

// 15a. Insertar un documento de prueba para eliminarlo
db.peliculas.insertOne({
  titulo: "Película de Prueba",
  tipo: "pelicula",
  anio_estreno: 2024,
  generos: ["Test"],
  puntuacion: 1.0,
  disponible: false
})

// 15b. Eliminar la película de prueba
db.peliculas.deleteOne({ titulo: "Película de Prueba" })
print("Documento de prueba eliminado")

// 15c. deleteMany - Eliminar usuarios inactivos sin historial
// (Solo simulación - primero verificamos cuántos hay)
print("Usuarios inactivos: " + db.usuarios.countDocuments({ activo: false }))

// ============================================================
// EJERCICIO 16: AGGREGATION PIPELINE
// Pipeline 1: Promedio de puntuación por tipo de contenido
// ============================================================
db.peliculas.aggregate([
  {
    $group: {
      _id: "$tipo",
      promedio_puntuacion: { $avg: "$puntuacion" },
      total_vistas:        { $sum: "$vistas" },
      cantidad:            { $sum: 1 },
      max_puntuacion:      { $max: "$puntuacion" },
      min_puntuacion:      { $min: "$puntuacion" }
    }
  },
  {
    $project: {
      tipo: "$_id",
      _id: 0,
      promedio_puntuacion: { $round: ["$promedio_puntuacion", 2] },
      total_vistas:        1,
      cantidad:            1,
      max_puntuacion:      1,
      min_puntuacion:      1
    }
  },
  { $sort: { promedio_puntuacion: -1 } }
])

// ============================================================
// EJERCICIO 17: Aggregation - Top géneros más populares
// ============================================================
db.peliculas.aggregate([
  { $unwind: "$generos" },
  {
    $group: {
      _id: "$generos",
      total_contenido: { $sum: 1 },
      promedio_vistas: { $avg: "$vistas" },
      promedio_puntuacion: { $avg: "$puntuacion" }
    }
  },
  {
    $project: {
      genero: "$_id",
      _id: 0,
      total_contenido: 1,
      promedio_vistas: { $round: ["$promedio_vistas", 0] },
      promedio_puntuacion: { $round: ["$promedio_puntuacion", 1] }
    }
  },
  { $sort: { total_contenido: -1, promedio_vistas: -1 } }
])

// ============================================================
// EJERCICIO 18: Aggregation - Usuarios por plan y país
// ============================================================
db.usuarios.aggregate([
  {
    $match: { activo: true }
  },
  {
    $group: {
      _id: { pais: "$pais", plan: "$plan" },
      total_usuarios: { $sum: 1 },
      promedio_horas: { $avg: "$total_horas_vistas" },
      ingresos_mensuales: { $sum: "$precio_plan" }
    }
  },
  {
    $project: {
      _id: 0,
      pais: "$_id.pais",
      plan: "$_id.plan",
      total_usuarios: 1,
      promedio_horas: { $round: ["$promedio_horas", 1] },
      ingresos_mensuales: 1
    }
  },
  { $sort: { pais: 1, ingresos_mensuales: -1 } }
])

// ============================================================
// EJERCICIO 19: Aggregation con $lookup (simula un JOIN)
// ============================================================
// Primero insertar calificaciones
db.calificaciones.insertMany([
  { email_usuario: "camila.torres@email.com",  titulo_pelicula: "Inception",        puntos: 9, comentario: "Obra maestra absoluta",       fecha: new Date("2024-10-02") },
  { email_usuario: "andres.martinez@email.com", titulo_pelicula: "Interstellar",    puntos: 9, comentario: "Visualmente impactante",        fecha: new Date("2024-10-05") },
  { email_usuario: "carlos.ramirez@email.com", titulo_pelicula: "Parasite",         puntos: 10, comentario: "La mejor película del año",  fecha: new Date("2024-10-08") },
  { email_usuario: "valentina.lopez@email.com", titulo_pelicula: "Stranger Things", puntos: 9, comentario: "Nostalgia perfecta",           fecha: new Date("2024-10-10") },
  { email_usuario: "julian.castro@email.com",   titulo_pelicula: "Breaking Bad",    puntos: 10, comentario: "La mejor serie de la historia", fecha: new Date("2024-10-12") },
  { email_usuario: "camila.torres@email.com",  titulo_pelicula: "Avengers: Endgame", puntos: 8, comentario: "Cierre épico del MCU",        fecha: new Date("2024-10-15") },
  { email_usuario: "santiago.gomez@email.com", titulo_pelicula: "Dune: Parte 1",    puntos: 8, comentario: "Épico e impresionante",        fecha: new Date("2024-10-18") },
  { email_usuario: "andres.martinez@email.com", titulo_pelicula: "Dark",            puntos: 10, comentario: "La serie más inteligente",   fecha: new Date("2024-10-20") }
])

// Aggregation con $lookup para unir calificaciones con películas
db.calificaciones.aggregate([
  {
    $lookup: {
      from: "peliculas",
      localField: "titulo_pelicula",
      foreignField: "titulo",
      as: "info_pelicula"
    }
  },
  { $unwind: "$info_pelicula" },
  {
    $project: {
      _id: 0,
      usuario: "$email_usuario",
      pelicula: "$titulo_pelicula",
      generos: "$info_pelicula.generos",
      puntos_usuario: "$puntos",
      puntuacion_oficial: "$info_pelicula.puntuacion",
      comentario: 1,
      fecha: 1
    }
  },
  { $sort: { puntos_usuario: -1 } }
])

// ============================================================
// EJERCICIO 20: Aggregation - Estadísticas finales de la plataforma
// ============================================================
db.peliculas.aggregate([
  {
    $facet: {
      por_tipo: [
        { $group: { _id: "$tipo", total: { $sum: 1 } } }
      ],
      top_3_vistas: [
        { $sort: { vistas: -1 } },
        { $limit: 3 },
        { $project: { _id: 0, titulo: 1, vistas: 1 } }
      ],
      top_3_puntuacion: [
        { $sort: { puntuacion: -1 } },
        { $limit: 3 },
        { $project: { _id: 0, titulo: 1, puntuacion: 1 } }
      ],
      resumen_general: [
        {
          $group: {
            _id: null,
            total_contenido:  { $sum: 1 },
            promedio_puntuacion: { $avg: "$puntuacion" },
            total_vistas:    { $sum: "$vistas" }
          }
        },
        { $project: { _id: 0 } }
      ]
    }
  }
])
