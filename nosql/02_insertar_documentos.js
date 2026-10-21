// ============================================================
// SCRIPT 02: MONGODB - INSERCIÓN DE DOCUMENTOS
// Base de datos: streaming_db
// Colecciones: usuarios, peliculas
// ============================================================

const db = connect("mongodb://localhost:27017/streaming_db");

// ============================================================
// INSERTAR USUARIOS (insertMany)
// ============================================================
db.usuarios.insertMany([
  {
    nombre: "Camila Torres",
    email: "camila.torres@email.com",
    plan: "Estándar",
    precio_plan: 24900,
    fecha_registro: new Date("2024-01-15"),
    pais: "Colombia",
    ciudad: "Bogotá",
    activo: true,
    preferencias: {
      generos_favoritos: ["Acción", "Thriller", "Ciencia Ficción"],
      idioma_preferido: "Español",
      notificaciones: true
    },
    dispositivos: ["Smart TV", "Smartphone"],
    total_horas_vistas: 145.5
  },
  {
    nombre: "Andrés Martínez",
    email: "andres.martinez@email.com",
    plan: "Premium",
    precio_plan: 39900,
    fecha_registro: new Date("2024-02-20"),
    pais: "Colombia",
    ciudad: "Medellín",
    activo: true,
    preferencias: {
      generos_favoritos: ["Ciencia Ficción", "Drama", "Documental"],
      idioma_preferido: "Inglés",
      notificaciones: true
    },
    dispositivos: ["Smart TV", "Laptop", "Tablet"],
    total_horas_vistas: 287.2
  },
  {
    nombre: "Luisa Fernández",
    email: "luisa.fernandez@email.com",
    plan: "Básico",
    precio_plan: 14900,
    fecha_registro: new Date("2024-03-10"),
    pais: "México",
    ciudad: "Ciudad de México",
    activo: true,
    preferencias: {
      generos_favoritos: ["Romance", "Comedia", "Drama"],
      idioma_preferido: "Español",
      notificaciones: false
    },
    dispositivos: ["Smartphone"],
    total_horas_vistas: 62.0
  },
  {
    nombre: "Carlos Ramírez",
    email: "carlos.ramirez@email.com",
    plan: "Premium",
    precio_plan: 39900,
    fecha_registro: new Date("2024-04-05"),
    pais: "Argentina",
    ciudad: "Buenos Aires",
    activo: true,
    preferencias: {
      generos_favoritos: ["Thriller", "Drama", "Terror"],
      idioma_preferido: "Español",
      notificaciones: true
    },
    dispositivos: ["Smart TV", "Laptop"],
    total_horas_vistas: 198.8
  },
  {
    nombre: "Valentina López",
    email: "valentina.lopez@email.com",
    plan: "Familiar",
    precio_plan: 49900,
    fecha_registro: new Date("2024-05-18"),
    pais: "Colombia",
    ciudad: "Cali",
    activo: true,
    preferencias: {
      generos_favoritos: ["Animación", "Comedia", "Fantasía"],
      idioma_preferido: "Español",
      notificaciones: true
    },
    dispositivos: ["Smart TV", "Tablet", "Smartphone", "Laptop"],
    total_horas_vistas: 312.1
  },
  {
    nombre: "Santiago Gómez",
    email: "santiago.gomez@email.com",
    plan: "Estándar",
    precio_plan: 24900,
    fecha_registro: new Date("2024-06-22"),
    pais: "Perú",
    ciudad: "Lima",
    activo: true,
    preferencias: {
      generos_favoritos: ["Acción", "Ciencia Ficción"],
      idioma_preferido: "Inglés",
      notificaciones: false
    },
    dispositivos: ["Laptop", "Smartphone"],
    total_horas_vistas: 89.4
  },
  {
    nombre: "María González",
    email: "maria.gonzalez@email.com",
    plan: "Básico",
    precio_plan: 14900,
    fecha_registro: new Date("2024-07-30"),
    pais: "Colombia",
    ciudad: "Barranquilla",
    activo: false,
    preferencias: {
      generos_favoritos: ["Drama", "Romance"],
      idioma_preferido: "Español",
      notificaciones: false
    },
    dispositivos: ["Smartphone"],
    total_horas_vistas: 28.3
  },
  {
    nombre: "Julián Castro",
    email: "julian.castro@email.com",
    plan: "Premium",
    precio_plan: 39900,
    fecha_registro: new Date("2024-08-11"),
    pais: "Chile",
    ciudad: "Santiago",
    activo: true,
    preferencias: {
      generos_favoritos: ["Thriller", "Acción", "Ciencia Ficción"],
      idioma_preferido: "Inglés",
      notificaciones: true
    },
    dispositivos: ["Smart TV", "Laptop"],
    total_horas_vistas: 175.6
  }
])

// ============================================================
// INSERTAR PELÍCULAS Y SERIES (insertMany)
// ============================================================
db.peliculas.insertMany([
  {
    titulo: "Inception",
    titulo_original: "Inception",
    tipo: "pelicula",
    anio_estreno: 2010,
    duracion_min: 148,
    director: "Christopher Nolan",
    actores_principales: ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Ellen Page"],
    generos: ["Acción", "Ciencia Ficción", "Thriller"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "PG-13",
    puntuacion: 8.8,
    vistas: 4500000,
    disponible: true,
    sinopsis: "Un ladrón que roba secretos del subconsciente durante el estado de sueño recibe la tarea inversa de plantar una idea.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    metadata: {
      presupuesto_usd: 160000000,
      recaudacion_usd: 836800000,
      premios: ["Oscar a Mejor Fotografía", "Oscar a Mejores Efectos Visuales"]
    },
    fecha_agregado: new Date("2023-01-10")
  },
  {
    titulo: "Interstellar",
    titulo_original: "Interstellar",
    tipo: "pelicula",
    anio_estreno: 2014,
    duracion_min: 169,
    director: "Christopher Nolan",
    actores_principales: ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain"],
    generos: ["Ciencia Ficción", "Drama", "Aventura"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "PG-13",
    puntuacion: 8.6,
    vistas: 3900000,
    disponible: true,
    sinopsis: "Un equipo de exploradores viaja a través de un agujero de gusano en busca de un nuevo hogar para la humanidad.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    metadata: {
      presupuesto_usd: 165000000,
      recaudacion_usd: 701700000,
      premios: ["Oscar a Mejores Efectos Visuales"]
    },
    fecha_agregado: new Date("2023-02-15")
  },
  {
    titulo: "Parasite",
    titulo_original: "Gisaengchung",
    tipo: "pelicula",
    anio_estreno: 2019,
    duracion_min: 132,
    director: "Bong Joon-ho",
    actores_principales: ["Song Kang-ho", "Lee Sun-kyun", "Cho Yeo-jeong"],
    generos: ["Drama", "Thriller", "Comedia Negra"],
    idioma: "Coreano",
    pais_produccion: "Corea del Sur",
    clasificacion: "R",
    puntuacion: 8.5,
    vistas: 5200000,
    disponible: true,
    sinopsis: "Una familia en situación de pobreza se infiltra en la vida de una rica familia con resultados imprevisibles.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    metadata: {
      presupuesto_usd: 11400000,
      recaudacion_usd: 258800000,
      premios: ["Oscar a Mejor Película", "Oscar a Mejor Director", "Palma de Oro Cannes"]
    },
    fecha_agregado: new Date("2023-03-20")
  },
  {
    titulo: "Avengers: Endgame",
    titulo_original: "Avengers: Endgame",
    tipo: "pelicula",
    anio_estreno: 2019,
    duracion_min: 181,
    director: "Anthony Russo",
    actores_principales: ["Robert Downey Jr.", "Chris Evans", "Mark Ruffalo", "Scarlett Johansson"],
    generos: ["Acción", "Ciencia Ficción", "Aventura"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "PG-13",
    puntuacion: 8.4,
    vistas: 9800000,
    disponible: true,
    sinopsis: "Los Vengadores supervivientes realizan un último intento para revertir los daños causados por Thanos.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    metadata: {
      presupuesto_usd: 356000000,
      recaudacion_usd: 2797800000,
      premios: ["Récord de taquilla mundial"]
    },
    fecha_agregado: new Date("2023-04-01")
  },
  {
    titulo: "Dune: Parte 1",
    titulo_original: "Dune: Part One",
    tipo: "pelicula",
    anio_estreno: 2021,
    duracion_min: 155,
    director: "Denis Villeneuve",
    actores_principales: ["Timothée Chalamet", "Zendaya", "Oscar Isaac", "Rebecca Ferguson"],
    generos: ["Ciencia Ficción", "Acción", "Drama"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "PG-13",
    puntuacion: 8.0,
    vistas: 4100000,
    disponible: true,
    sinopsis: "Paul Atreides lidera a su pueblo en la batalla por el planeta más peligroso del universo.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    metadata: {
      presupuesto_usd: 165000000,
      recaudacion_usd: 401800000,
      premios: ["Oscar a Mejor Fotografía", "Oscar a Mejor Banda Sonora"]
    },
    fecha_agregado: new Date("2023-05-10")
  },
  {
    titulo: "Breaking Bad",
    titulo_original: "Breaking Bad",
    tipo: "serie",
    anio_estreno: 2008,
    anio_fin: 2013,
    temporadas: 5,
    total_episodios: 62,
    duracion_ep_promedio: 47,
    director: "Vince Gilligan",
    actores_principales: ["Bryan Cranston", "Aaron Paul", "Anna Gunn"],
    generos: ["Drama", "Thriller", "Crimen"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "TV-MA",
    puntuacion: 9.5,
    vistas: 12000000,
    disponible: true,
    sinopsis: "Un profesor de química diagnosticado con cáncer fabrica metanfetamina para asegurar el futuro de su familia.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    temporadas_detalle: [
      { numero: 1, episodios: 7, anio: 2008 },
      { numero: 2, episodios: 13, anio: 2009 },
      { numero: 3, episodios: 13, anio: 2010 },
      { numero: 4, episodios: 13, anio: 2011 },
      { numero: 5, episodios: 16, anio: 2012 }
    ],
    metadata: {
      emmys_ganados: 16,
      golden_globes: 2
    },
    fecha_agregado: new Date("2022-06-01")
  },
  {
    titulo: "Stranger Things",
    titulo_original: "Stranger Things",
    tipo: "serie",
    anio_estreno: 2016,
    temporadas: 4,
    total_episodios: 34,
    duracion_ep_promedio: 51,
    director: "The Duffer Brothers",
    actores_principales: ["Millie Bobby Brown", "Finn Wolfhard", "David Harbour", "Winona Ryder"],
    generos: ["Ciencia Ficción", "Terror", "Drama", "Aventura"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "TV-14",
    puntuacion: 8.7,
    vistas: 18000000,
    disponible: true,
    sinopsis: "Un grupo de amigos se enfrenta a fuerzas sobrenaturales y experimentos secretos del gobierno en los años 80.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    temporadas_detalle: [
      { numero: 1, episodios: 8, anio: 2016 },
      { numero: 2, episodios: 9, anio: 2017 },
      { numero: 3, episodios: 8, anio: 2019 },
      { numero: 4, episodios: 9, anio: 2022 }
    ],
    metadata: {
      emmys_nominaciones: 71,
      golden_globes: 0
    },
    fecha_agregado: new Date("2022-07-15")
  },
  {
    titulo: "The Last of Us",
    titulo_original: "The Last of Us",
    tipo: "serie",
    anio_estreno: 2023,
    temporadas: 1,
    total_episodios: 9,
    duracion_ep_promedio: 54,
    director: "Craig Mazin",
    actores_principales: ["Pedro Pascal", "Bella Ramsey", "Anna Torv"],
    generos: ["Drama", "Acción", "Terror", "Post-apocalíptico"],
    idioma: "Inglés",
    pais_produccion: "Estados Unidos",
    clasificacion: "TV-MA",
    puntuacion: 8.8,
    vistas: 14500000,
    disponible: true,
    sinopsis: "En un mundo devastado por un hongo mutante, un contrabandista escolta a una adolescente inmune a través del país.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    temporadas_detalle: [
      { numero: 1, episodios: 9, anio: 2023 }
    ],
    metadata: {
      emmys_ganados: 8,
      basada_en: "Videojuego The Last of Us (2013)"
    },
    fecha_agregado: new Date("2023-01-15")
  },
  {
    titulo: "Narcos",
    titulo_original: "Narcos",
    tipo: "serie",
    anio_estreno: 2015,
    anio_fin: 2017,
    temporadas: 3,
    total_episodios: 30,
    duracion_ep_promedio: 49,
    director: "Chris Brancato",
    actores_principales: ["Wagner Moura", "Boyd Holbrook", "Pedro Pascal"],
    generos: ["Drama", "Crimen", "Thriller", "Biográfico"],
    idioma: "Español",
    idioma_secundario: "Inglés",
    pais_produccion: "Colombia",
    clasificacion: "TV-MA",
    puntuacion: 8.8,
    vistas: 11000000,
    disponible: true,
    sinopsis: "Crónica del auge y caída de los mayores carteles de narcotráfico en Colombia.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    temporadas_detalle: [
      { numero: 1, episodios: 10, anio: 2015 },
      { numero: 2, episodios: 10, anio: 2016 },
      { numero: 3, episodios: 10, anio: 2017 }
    ],
    metadata: {
      golden_globes_nominaciones: 2,
      filmado_en: "Colombia"
    },
    fecha_agregado: new Date("2022-09-01")
  },
  {
    titulo: "Dark",
    titulo_original: "Dark",
    tipo: "serie",
    anio_estreno: 2017,
    anio_fin: 2020,
    temporadas: 3,
    total_episodios: 26,
    duracion_ep_promedio: 52,
    director: "Baran bo Odar",
    actores_principales: ["Louis Hofmann", "Lisa Vicari", "Maja Schöne"],
    generos: ["Ciencia Ficción", "Drama", "Thriller", "Misterio"],
    idioma: "Alemán",
    pais_produccion: "Alemania",
    clasificacion: "TV-MA",
    puntuacion: 8.8,
    vistas: 7500000,
    disponible: true,
    sinopsis: "Desapariciones en Winden revelan una conspiración familiar que involucra viajes en el tiempo.",
    plataformas_disponibles: ["Web", "Android", "iOS", "SmartTV"],
    temporadas_detalle: [
      { numero: 1, episodios: 10, anio: 2017 },
      { numero: 2, episodios: 8, anio: 2019 },
      { numero: 3, episodios: 8, anio: 2020 }
    ],
    metadata: {
      primera_serie_alemana_original: true,
      idiomas_doblaje: ["Español", "Inglés", "Francés", "Italiano"]
    },
    fecha_agregado: new Date("2022-10-20")
  }
])

// Verificar inserción
print("=== USUARIOS INSERTADOS ===")
db.usuarios.countDocuments()
print("=== PELÍCULAS/SERIES INSERTADAS ===")
db.peliculas.countDocuments()
