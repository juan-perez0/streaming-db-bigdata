-- ============================================================
-- SCRIPT 03: CONSULTAS SQL - SISTEMA STREAMING
-- Base de datos: NewSQL (Oracle SQL Developer)
-- Ejercicios de SELECT, WHERE, ORDER BY, GROUP BY, JOIN
-- ============================================================

-- ============================================================
-- EJERCICIO 1: Consulta básica con WHERE y ORDER BY
-- Listar todas las películas ordenadas por puntuación descendente
-- ============================================================
SELECT 
    id_contenido,
    titulo,
    anio_estreno,
    duracion_min,
    puntuacion,
    idioma,
    clasificacion
FROM CONTENIDO
WHERE tipo = 'PELICULA'
ORDER BY puntuacion DESC, vistas DESC;

-- ============================================================
-- EJERCICIO 2: Filtros múltiples con AND/OR
-- Contenido con puntuación >= 8.5 en inglés o español
-- ============================================================
SELECT 
    titulo,
    tipo,
    anio_estreno,
    puntuacion,
    idioma,
    vistas
FROM CONTENIDO
WHERE puntuacion >= 8.5
  AND idioma IN ('Inglés', 'Español')
ORDER BY puntuacion DESC;

-- ============================================================
-- EJERCICIO 3: GROUP BY - Usuarios por país con su plan
-- ============================================================
SELECT 
    u.pais,
    p.nombre AS plan,
    COUNT(u.id_usuario) AS total_usuarios,
    ROUND(AVG(p.precio_mes), 0) AS precio_promedio
FROM USUARIOS u
JOIN PLANES p ON u.id_plan = p.id_plan
GROUP BY u.pais, p.nombre
ORDER BY total_usuarios DESC, u.pais;

-- ============================================================
-- EJERCICIO 4: GROUP BY con HAVING
-- Géneros con más de 3 contenidos asignados
-- ============================================================
SELECT 
    g.nombre AS genero,
    COUNT(cg.id_contenido) AS total_contenido
FROM GENEROS g
JOIN CONTENIDO_GENERO cg ON g.id_genero = cg.id_genero
GROUP BY g.id_genero, g.nombre
HAVING COUNT(cg.id_contenido) > 3
ORDER BY total_contenido DESC;

-- ============================================================
-- EJERCICIO 5: JOIN múltiple - Top contenido más visto con géneros
-- ============================================================
SELECT 
    c.titulo,
    c.tipo,
    c.puntuacion,
    TO_CHAR(c.vistas, '999,999,999') AS total_vistas,
    LISTAGG(g.nombre, ', ') WITHIN GROUP (ORDER BY g.nombre) AS generos
FROM CONTENIDO c
JOIN CONTENIDO_GENERO cg ON c.id_contenido = cg.id_contenido
JOIN GENEROS g ON cg.id_genero = g.id_genero
GROUP BY c.id_contenido, c.titulo, c.tipo, c.puntuacion, c.vistas
ORDER BY c.vistas DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================
-- EJERCICIO 6: JOIN - Historial de reproducción con usuarios
-- ============================================================
SELECT 
    u.nombre AS usuario,
    c.titulo  AS contenido,
    c.tipo,
    h.fecha_inicio,
    h.minutos_vistos,
    CASE h.completado 
        WHEN 'S' THEN 'Completado' 
        ELSE 'En progreso' 
    END AS estado
FROM HISTORIAL_REPRODUCCION h
JOIN USUARIOS u ON h.id_usuario = u.id_usuario
JOIN CONTENIDO c ON h.id_contenido = c.id_contenido
ORDER BY h.fecha_inicio DESC;

-- ============================================================
-- EJERCICIO 7: Subconsulta - Usuarios que vieron contenido con
-- puntuación mayor al promedio general
-- ============================================================
SELECT DISTINCT
    u.nombre,
    u.email,
    u.pais
FROM USUARIOS u
JOIN HISTORIAL_REPRODUCCION h ON u.id_usuario = h.id_usuario
JOIN CONTENIDO c ON h.id_contenido = c.id_contenido
WHERE c.puntuacion > (SELECT AVG(puntuacion) FROM CONTENIDO)
ORDER BY u.nombre;

-- ============================================================
-- EJERCICIO 8: Resumen de calificaciones por contenido
-- ============================================================
SELECT 
    c.titulo,
    COUNT(cal.id_calificacion)             AS total_calificaciones,
    ROUND(AVG(cal.puntos), 1)              AS promedio_puntos,
    MIN(cal.puntos)                        AS puntuacion_min,
    MAX(cal.puntos)                        AS puntuacion_max
FROM CONTENIDO c
LEFT JOIN CALIFICACIONES cal ON c.id_contenido = cal.id_contenido
GROUP BY c.id_contenido, c.titulo
ORDER BY total_calificaciones DESC, promedio_puntos DESC;

-- ============================================================
-- EJERCICIO 9: Consulta con CASE - Categorizar contenido por popularidad
-- ============================================================
SELECT 
    titulo,
    tipo,
    vistas,
    puntuacion,
    CASE 
        WHEN vistas >= 10000000 THEN 'VIRAL'
        WHEN vistas >= 5000000  THEN 'MUY POPULAR'
        WHEN vistas >= 2000000  THEN 'POPULAR'
        ELSE 'EN CRECIMIENTO'
    END AS nivel_popularidad
FROM CONTENIDO
ORDER BY vistas DESC;

-- ============================================================
-- EJERCICIO 10: Episodios de una serie específica con JOIN
-- ============================================================
SELECT 
    c.titulo AS serie,
    t.numero AS temporada,
    t.anio,
    e.numero AS episodio,
    e.titulo AS titulo_episodio,
    e.duracion_min AS duracion
FROM CONTENIDO c
JOIN TEMPORADAS t ON c.id_contenido = t.id_contenido
JOIN EPISODIOS e ON t.id_temporada = e.id_temporada
WHERE c.titulo = 'Breaking Bad'
ORDER BY t.numero, e.numero;

-- ============================================================
-- EJERCICIO 11: Análisis de ingresos por plan
-- ============================================================
SELECT 
    p.nombre AS plan,
    p.precio_mes,
    p.calidad_video,
    COUNT(u.id_usuario)                        AS usuarios_activos,
    COUNT(u.id_usuario) * p.precio_mes         AS ingreso_mensual
FROM PLANES p
LEFT JOIN USUARIOS u ON p.id_plan = u.id_plan AND u.activo = 'S'
GROUP BY p.id_plan, p.nombre, p.precio_mes, p.calidad_video
ORDER BY ingreso_mensual DESC;
