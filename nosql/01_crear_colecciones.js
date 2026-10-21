// ============================================================
// SCRIPT 01: MONGODB - CREACIÓN DE BASE DE DATOS Y COLECCIONES
// Adaptado para mongosh --file (sin comandos interactivos)
// ============================================================

const db = connect("mongodb://localhost:27017/streaming_db");

// Eliminar colecciones si ya existen (para re-ejecutar limpiamente)
try { db.usuarios.drop(); } catch(e) {}
try { db.peliculas.drop(); } catch(e) {}
try { db.calificaciones.drop(); } catch(e) {}
try { db.historial.drop(); } catch(e) {}

// --- Crear colecciones con validación de esquema ---

db.createCollection("usuarios", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "email", "plan", "fecha_registro"],
      properties: {
        nombre:         { bsonType: "string",  description: "Nombre completo del usuario" },
        email:          { bsonType: "string",  description: "Email único del usuario" },
        plan:           { bsonType: "string",  enum: ["Básico", "Estándar", "Premium", "Familiar"] },
        fecha_registro: { bsonType: "date",    description: "Fecha de registro" },
        pais:           { bsonType: "string" },
        activo:         { bsonType: "bool" }
      }
    }
  }
});

db.createCollection("peliculas", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["titulo", "tipo", "anio_estreno", "generos", "puntuacion"],
      properties: {
        titulo:       { bsonType: "string" },
        tipo:         { bsonType: "string", enum: ["pelicula", "serie"] },
        anio_estreno: { bsonType: "int" },
        puntuacion:   { bsonType: "double", minimum: 0, maximum: 10 },
        generos:      { bsonType: "array", items: { bsonType: "string" } }
      }
    }
  }
});

db.createCollection("calificaciones");
db.createCollection("historial");

// Crear índices
db.usuarios.createIndex({ email: 1 }, { unique: true });
db.peliculas.createIndex({ titulo: 1 });
db.calificaciones.createIndex({ email_usuario: 1, titulo_pelicula: 1 }, { unique: true });

print("=== COLECCIONES CREADAS ===");
printjson(db.getCollectionNames());
