-- ============================================================
-- SCRIPT 02: INSERCIÓN DE DATOS - SISTEMA STREAMING
-- Base de datos: NewSQL (Oracle SQL Developer)
-- ============================================================

-- ----------------------------------------------------------
-- PLANES DE SUSCRIPCIÓN
-- ----------------------------------------------------------
INSERT INTO PLANES (nombre, precio_mes, max_pantallas, calidad_video) VALUES ('Básico',    14900, 1, 'SD');
INSERT INTO PLANES (nombre, precio_mes, max_pantallas, calidad_video) VALUES ('Estándar',  24900, 2, 'HD');
INSERT INTO PLANES (nombre, precio_mes, max_pantallas, calidad_video) VALUES ('Premium',   39900, 4, '4K');
INSERT INTO PLANES (nombre, precio_mes, max_pantallas, calidad_video) VALUES ('Familiar',  49900, 6, '4K');

-- ----------------------------------------------------------
-- USUARIOS
-- ----------------------------------------------------------
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Camila Torres',    'camila.torres@email.com',   DATE '2024-01-15', 'Colombia',  2);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Andrés Martínez',  'andres.martinez@email.com', DATE '2024-02-20', 'Colombia',  3);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Luisa Fernández',  'luisa.fernandez@email.com', DATE '2024-03-10', 'México',    1);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Carlos Ramírez',   'carlos.ramirez@email.com',  DATE '2024-04-05', 'Argentina', 3);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Valentina López',  'valentina.lopez@email.com', DATE '2024-05-18', 'Colombia',  4);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Santiago Gómez',   'santiago.gomez@email.com',  DATE '2024-06-22', 'Perú',      2);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('María González',   'maria.gonzalez@email.com',  DATE '2024-07-30', 'Colombia',  1);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Julián Castro',    'julian.castro@email.com',   DATE '2024-08-11', 'Chile',     3);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Isabella Moreno',  'isabella.moreno@email.com', DATE '2024-09-03', 'Colombia',  2);
INSERT INTO USUARIOS (nombre, email, fecha_registro, pais, id_plan) VALUES ('Felipe Herrera',   'felipe.herrera@email.com',  DATE '2024-10-25', 'Ecuador',   4);

-- ----------------------------------------------------------
-- GÉNEROS
-- ----------------------------------------------------------
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Acción',      'Películas y series con secuencias de acción intensa');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Drama',       'Contenido con narrativas emocionales y conflictos profundos');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Comedia',     'Contenido diseñado para entretener y provocar risa');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Ciencia Ficción', 'Tramas basadas en avances científicos y tecnológicos futuros');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Terror',      'Contenido diseñado para generar miedo y suspenso');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Thriller',    'Suspenso con giros inesperados y alta tensión');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Animación',   'Contenido creado mediante técnicas de animación');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Documental',  'Contenido basado en hechos y eventos reales');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Romance',     'Historias centradas en relaciones amorosas');
INSERT INTO GENEROS (nombre, descripcion) VALUES ('Fantasía',    'Mundos imaginarios con elementos mágicos y sobrenaturales');

-- ----------------------------------------------------------
-- CONTENIDO (Películas)
-- ----------------------------------------------------------
INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Inception', 'PELICULA', 2010, 148,
        'Un ladrón que roba secretos del subconsciente durante el estado de sueño recibe la tarea de plantar una idea en la mente de un CEO.',
        'Inglés', 'PG-13', 8.8, 4500000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Interstellar', 'PELICULA', 2014, 169,
        'Un equipo de exploradores viaja a través de un agujero de gusano en el espacio en un intento de asegurar la supervivencia de la humanidad.',
        'Inglés', 'PG-13', 8.6, 3900000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('El Laberinto del Fauno', 'PELICULA', 2006, 118,
        'En la España de la posguerra, una niña descubre un laberinto mágico y conoce al fauno que la lleva a un mundo fantástico.',
        'Español', 'R', 8.2, 2800000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Parasite', 'PELICULA', 2019, 132,
        'La familia Kim, que vive en la pobreza, se infiltra en la vida de la rica familia Park con resultados imprevisibles.',
        'Coreano', 'R', 8.5, 5200000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Avengers: Endgame', 'PELICULA', 2019, 181,
        'Los Vengadores supervivientes realizan un último intento para revertir los daños causados por Thanos y restaurar el universo.',
        'Inglés', 'PG-13', 8.4, 9800000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Spider-Man: No Way Home', 'PELICULA', 2021, 148,
        'Peter Parker busca la ayuda del Doctor Strange para que el mundo olvide que él es Spider-Man, con consecuencias multidimensionales.',
        'Inglés', 'PG-13', 8.2, 8700000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Dune: Parte 1', 'PELICULA', 2021, 155,
        'Paul Atreides lidera a su pueblo en la batalla por controlar el planeta más peligroso del universo y su recurso más valioso.',
        'Inglés', 'PG-13', 8.0, 4100000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Everything Everywhere All at Once', 'PELICULA', 2022, 139,
        'Una lavandera china es barrida en una aventura donde debe conectar con versiones de sí misma en universos paralelos.',
        'Inglés', 'R', 7.9, 3300000);

-- ----------------------------------------------------------
-- CONTENIDO (Series)
-- ----------------------------------------------------------
INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Breaking Bad', 'SERIE', 2008, NULL,
        'Un profesor de química de secundaria diagnosticado con cáncer se asocia con un exalumno para fabricar y vender metanfetamina.',
        'Inglés', 'TV-MA', 9.5, 12000000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Stranger Things', 'SERIE', 2016, NULL,
        'En la pequeña ciudad de Hawkins, un grupo de amigos se enfrenta a fuerzas sobrenaturales y experimentos secretos del gobierno.',
        'Inglés', 'TV-14', 8.7, 18000000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Dark', 'SERIE', 2017, NULL,
        'Una serie de misteriosas desapariciones en la pequeña ciudad alemana de Winden revela una conspiración que involucra cuatro familias a través del tiempo.',
        'Alemán', 'TV-MA', 8.8, 7500000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('The Last of Us', 'SERIE', 2023, NULL,
        'En un mundo postapocalíptico devastado por un hongo mutante, un hombre recibe la misión de escoltar a una adolescente inmune a través del país.',
        'Inglés', 'TV-MA', 8.8, 14500000);

INSERT INTO CONTENIDO (titulo, tipo, anio_estreno, duracion_min, sinopsis, idioma, clasificacion, puntuacion, vistas)
VALUES ('Narcos', 'SERIE', 2015, NULL,
        'Crónica del auge y caída de los mayores carteles de narcotráfico en Colombia, centrada en Pablo Escobar.',
        'Español', 'TV-MA', 8.8, 11000000);

-- ----------------------------------------------------------
-- GÉNEROS POR CONTENIDO
-- ----------------------------------------------------------
-- Inception (1): Acción(1), Ciencia Ficción(4), Thriller(6)
INSERT INTO CONTENIDO_GENERO VALUES (1, 1); INSERT INTO CONTENIDO_GENERO VALUES (1, 4); INSERT INTO CONTENIDO_GENERO VALUES (1, 6);
-- Interstellar (2): Ciencia Ficción(4), Drama(2)
INSERT INTO CONTENIDO_GENERO VALUES (2, 4); INSERT INTO CONTENIDO_GENERO VALUES (2, 2);
-- El Laberinto del Fauno (3): Drama(2), Fantasía(10)
INSERT INTO CONTENIDO_GENERO VALUES (3, 2); INSERT INTO CONTENIDO_GENERO VALUES (3, 10);
-- Parasite (4): Drama(2), Thriller(6), Comedia(3)
INSERT INTO CONTENIDO_GENERO VALUES (4, 2); INSERT INTO CONTENIDO_GENERO VALUES (4, 6); INSERT INTO CONTENIDO_GENERO VALUES (4, 3);
-- Avengers: Endgame (5): Acción(1), Ciencia Ficción(4)
INSERT INTO CONTENIDO_GENERO VALUES (5, 1); INSERT INTO CONTENIDO_GENERO VALUES (5, 4);
-- Spider-Man: No Way Home (6): Acción(1), Ciencia Ficción(4), Comedia(3)
INSERT INTO CONTENIDO_GENERO VALUES (6, 1); INSERT INTO CONTENIDO_GENERO VALUES (6, 4); INSERT INTO CONTENIDO_GENERO VALUES (6, 3);
-- Dune: Parte 1 (7): Acción(1), Ciencia Ficción(4), Drama(2)
INSERT INTO CONTENIDO_GENERO VALUES (7, 1); INSERT INTO CONTENIDO_GENERO VALUES (7, 4); INSERT INTO CONTENIDO_GENERO VALUES (7, 2);
-- Everything Everywhere (8): Acción(1), Comedia(3), Ciencia Ficción(4)
INSERT INTO CONTENIDO_GENERO VALUES (8, 1); INSERT INTO CONTENIDO_GENERO VALUES (8, 3); INSERT INTO CONTENIDO_GENERO VALUES (8, 4);
-- Breaking Bad (9): Drama(2), Thriller(6)
INSERT INTO CONTENIDO_GENERO VALUES (9, 2); INSERT INTO CONTENIDO_GENERO VALUES (9, 6);
-- Stranger Things (10): Ciencia Ficción(4), Terror(5), Drama(2)
INSERT INTO CONTENIDO_GENERO VALUES (10, 4); INSERT INTO CONTENIDO_GENERO VALUES (10, 5); INSERT INTO CONTENIDO_GENERO VALUES (10, 2);
-- Dark (11): Ciencia Ficción(4), Drama(2), Thriller(6)
INSERT INTO CONTENIDO_GENERO VALUES (11, 4); INSERT INTO CONTENIDO_GENERO VALUES (11, 2); INSERT INTO CONTENIDO_GENERO VALUES (11, 6);
-- The Last of Us (12): Drama(2), Acción(1), Terror(5)
INSERT INTO CONTENIDO_GENERO VALUES (12, 2); INSERT INTO CONTENIDO_GENERO VALUES (12, 1); INSERT INTO CONTENIDO_GENERO VALUES (12, 5);
-- Narcos (13): Drama(2), Thriller(6), Acción(1)
INSERT INTO CONTENIDO_GENERO VALUES (13, 2); INSERT INTO CONTENIDO_GENERO VALUES (13, 6); INSERT INTO CONTENIDO_GENERO VALUES (13, 1);

-- ----------------------------------------------------------
-- TEMPORADAS Y EPISODIOS (Breaking Bad - id=9)
-- ----------------------------------------------------------
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (9, 1, 2008);
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (9, 2, 2009);
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (9, 3, 2010);

-- Episodios Temporada 1 (id=1)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 1, 'Pilot', 58);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 2, 'Cat''s in the Bag', 48);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 3, 'And the Bag''s in the River', 48);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 4, 'Cancer Man', 48);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 5, 'Gray Matter', 48);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 6, 'Crazy Handful of Nothin', 47);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 7, 'A No-Rough-Stuff-Type Deal', 47);

-- Temporadas Stranger Things (id=10)
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (10, 1, 2016);
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (10, 2, 2017);
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (10, 3, 2019);
INSERT INTO TEMPORADAS (id_contenido, numero, anio) VALUES (10, 4, 2022);

-- Episodios Temporada 1 Stranger Things (id=4)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 1, 'Chapter One: The Vanishing of Will Byers', 47);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 2, 'Chapter Two: The Weirdo on Maple Street', 55);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 3, 'Chapter Three: Holly, Jolly', 51);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 4, 'Chapter Four: The Body', 50);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 5, 'Chapter Five: The Flea and the Detective', 46);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 6, 'Chapter Six: The Monster', 46);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 7, 'Chapter Seven: The Bathtub', 41);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 8, 'Chapter Eight: The Upside Down', 55);

-- ----------------------------------------------------------
-- HISTORIAL DE REPRODUCCIÓN
-- ----------------------------------------------------------
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (1, 1,  DATE '2024-10-01', 148, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (1, 5,  DATE '2024-10-05', 181, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (2, 2,  DATE '2024-10-02', 169, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (2, 7,  DATE '2024-10-08', 80,  'N');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (3, 3,  DATE '2024-10-03', 118, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (4, 4,  DATE '2024-10-04', 132, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (4, 9,  DATE '2024-10-10', 200, 'N');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (5, 10, DATE '2024-10-06', 350, 'N');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (6, 12, DATE '2024-10-07', 420, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (7, 6,  DATE '2024-10-09', 148, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (8, 13, DATE '2024-10-11', 300, 'N');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (9, 11, DATE '2024-10-12', 240, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (10, 8, DATE '2024-10-13', 139, 'S');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (1, 9,  DATE '2024-10-14', 510, 'N');
INSERT INTO HISTORIAL_REPRODUCCION (id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado) VALUES (3, 12, DATE '2024-10-15', 600, 'S');

-- ----------------------------------------------------------
-- CALIFICACIONES
-- ----------------------------------------------------------
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (1, 1,  9, 'Obra maestra del cine moderno. Nolan en su mejor momento.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (1, 5,  8, 'El cierre perfecto del MCU. Emocionalmente devastador.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (2, 2,  9, 'Una experiencia visual y narrativa sin igual.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (3, 3,  8, 'Una joya del cine de fantasía. Del Toro es un maestro.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (4, 4,  10,'Parasite es perfecta. Mejor película de 2019 sin duda.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (5, 10, 9, 'La nostalgia de los 80s capturada perfectamente.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (6, 12, 10,'The Last of Us supera a muchas películas de Hollywood.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (7, 6,  8, 'El multiverso de Spider-Man ejecutado de forma brillante.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (8, 13, 9, 'Narcos cuenta la historia con un realismo impactante.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (9, 11, 10,'Dark es la serie más inteligente que he visto. Alemanes increíbles.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (10, 8, 8, 'Completamente diferente a todo lo que existe. Innovadora.');
INSERT INTO CALIFICACIONES (id_usuario, id_contenido, puntos, comentario) VALUES (4, 9,  10,'Breaking Bad es simplemente la mejor serie de la historia.');

COMMIT;

-- Verificar registros insertados
SELECT 'PLANES'                AS tabla, COUNT(*) AS registros FROM PLANES        UNION ALL
SELECT 'USUARIOS',               COUNT(*) FROM USUARIOS                           UNION ALL
SELECT 'GENEROS',                COUNT(*) FROM GENEROS                            UNION ALL
SELECT 'CONTENIDO',              COUNT(*) FROM CONTENIDO                          UNION ALL
SELECT 'CONTENIDO_GENERO',       COUNT(*) FROM CONTENIDO_GENERO                  UNION ALL
SELECT 'TEMPORADAS',             COUNT(*) FROM TEMPORADAS                         UNION ALL
SELECT 'EPISODIOS',              COUNT(*) FROM EPISODIOS                          UNION ALL
SELECT 'HISTORIAL_REPRODUCCION', COUNT(*) FROM HISTORIAL_REPRODUCCION            UNION ALL
SELECT 'CALIFICACIONES',         COUNT(*) FROM CALIFICACIONES;
