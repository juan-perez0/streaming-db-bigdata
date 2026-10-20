-- ============================================================
-- SCRIPT 04: UPDATE, DELETE Y PROCEDIMIENTOS PL/SQL
-- Base de datos: NewSQL (Oracle SQL Developer)
-- ============================================================

-- ============================================================
-- EJERCICIO 12: UPDATE - Actualizar datos
-- ============================================================

-- 12a. Actualizar puntuación de contenido basándose en calificaciones
UPDATE CONTENIDO c
SET puntuacion = (
    SELECT ROUND(AVG(cal.puntos), 1)
    FROM CALIFICACIONES cal
    WHERE cal.id_contenido = c.id_contenido
)
WHERE EXISTS (
    SELECT 1 FROM CALIFICACIONES cal
    WHERE cal.id_contenido = c.id_contenido
);

-- 12b. Aumentar precio del plan Básico en 10%
UPDATE PLANES
SET precio_mes = ROUND(precio_mes * 1.10, 0)
WHERE nombre = 'Básico';

-- 12c. Desactivar usuarios sin actividad en los últimos 90 días
UPDATE USUARIOS u
SET activo = 'N'
WHERE u.id_usuario NOT IN (
    SELECT DISTINCT h.id_usuario
    FROM HISTORIAL_REPRODUCCION h
    WHERE h.fecha_inicio >= SYSDATE - 90
);

COMMIT;

-- Verificar actualizaciones
SELECT nombre, precio_mes FROM PLANES;
SELECT nombre, activo FROM USUARIOS ORDER BY activo, nombre;

-- ============================================================
-- EJERCICIO 13: DELETE - Eliminar registros
-- ============================================================

-- 13a. Eliminar historial de reproducción de más de 1 año
DELETE FROM HISTORIAL_REPRODUCCION
WHERE fecha_inicio < ADD_MONTHS(SYSDATE, -12);

COMMIT;

-- ============================================================
-- EJERCICIO 14: Bloque PL/SQL Básico
-- Calcular estadísticas de la plataforma
-- ============================================================
DECLARE
    v_total_contenido    NUMBER;
    v_total_peliculas    NUMBER;
    v_total_series       NUMBER;
    v_total_usuarios     NUMBER;
    v_puntuacion_prom    NUMBER;
    v_contenido_top      VARCHAR2(200);
BEGIN
    -- Contar contenido por tipo
    SELECT COUNT(*) INTO v_total_contenido FROM CONTENIDO;
    SELECT COUNT(*) INTO v_total_peliculas FROM CONTENIDO WHERE tipo = 'PELICULA';
    SELECT COUNT(*) INTO v_total_series    FROM CONTENIDO WHERE tipo = 'SERIE';
    
    -- Contar usuarios activos
    SELECT COUNT(*) INTO v_total_usuarios FROM USUARIOS WHERE activo = 'S';
    
    -- Puntuación promedio
    SELECT ROUND(AVG(puntuacion), 2) INTO v_puntuacion_prom FROM CONTENIDO;
    
    -- Contenido más visto
    SELECT titulo INTO v_contenido_top
    FROM CONTENIDO
    WHERE vistas = (SELECT MAX(vistas) FROM CONTENIDO);
    
    -- Imprimir resultados
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('   ESTADÍSTICAS DE LA PLATAFORMA');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Total de contenido:    ' || v_total_contenido);
    DBMS_OUTPUT.PUT_LINE('  - Películas:         ' || v_total_peliculas);
    DBMS_OUTPUT.PUT_LINE('  - Series:            ' || v_total_series);
    DBMS_OUTPUT.PUT_LINE('Usuarios activos:      ' || v_total_usuarios);
    DBMS_OUTPUT.PUT_LINE('Puntuación promedio:   ' || v_puntuacion_prom);
    DBMS_OUTPUT.PUT_LINE('Contenido más visto:   ' || v_contenido_top);
    DBMS_OUTPUT.PUT_LINE('========================================');
END;
/

-- ============================================================
-- EJERCICIO 15: PROCEDIMIENTO ALMACENADO
-- Registrar reproducción de contenido
-- ============================================================
CREATE OR REPLACE PROCEDURE registrar_reproduccion(
    p_id_usuario    IN NUMBER,
    p_id_contenido  IN NUMBER,
    p_minutos       IN NUMBER,
    p_completado    IN CHAR DEFAULT 'N'
) AS
    v_duracion      NUMBER;
    v_existe_hist   NUMBER;
    v_completado    CHAR(1) := p_completado;
BEGIN
    -- Verificar que el usuario existe
    BEGIN
        SELECT 1 INTO v_existe_hist
        FROM USUARIOS WHERE id_usuario = p_id_usuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Usuario no encontrado: ' || p_id_usuario);
    END;
    
    -- Obtener duración del contenido
    SELECT NVL(duracion_min, 9999) INTO v_duracion
    FROM CONTENIDO WHERE id_contenido = p_id_contenido;
    
    -- Si los minutos vistos superan la duración, marcar como completado
    IF p_minutos >= v_duracion THEN
        v_completado := 'S';
    END IF;
    
    -- Insertar historial
    INSERT INTO HISTORIAL_REPRODUCCION (
        id_usuario, id_contenido, fecha_inicio, minutos_vistos, completado
    ) VALUES (
        p_id_usuario, p_id_contenido, SYSDATE, p_minutos, v_completado
    );
    
    -- Actualizar contador de vistas del contenido
    UPDATE CONTENIDO
    SET vistas = vistas + 1
    WHERE id_contenido = p_id_contenido;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('✓ Reproducción registrada para usuario ' || p_id_usuario ||
                         ' - Contenido: ' || p_id_contenido ||
                         ' - ' || p_minutos || ' minutos - ' ||
                         CASE v_completado WHEN 'S' THEN 'COMPLETADO' ELSE 'EN PROGRESO' END);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error al registrar reproducción: ' || SQLERRM);
END registrar_reproduccion;
/

-- Llamar al procedimiento
EXEC registrar_reproduccion(2, 3, 118, 'S');
EXEC registrar_reproduccion(5, 7, 60, 'N');

-- ============================================================
-- EJERCICIO 16: FUNCIÓN - Calcular porcentaje visto
-- ============================================================
CREATE OR REPLACE FUNCTION calcular_porcentaje_visto(
    p_id_usuario   IN NUMBER,
    p_id_contenido IN NUMBER
) RETURN NUMBER AS
    v_minutos_vistos NUMBER;
    v_duracion       NUMBER;
    v_porcentaje     NUMBER;
BEGIN
    SELECT NVL(SUM(h.minutos_vistos), 0)
    INTO   v_minutos_vistos
    FROM   HISTORIAL_REPRODUCCION h
    WHERE  h.id_usuario   = p_id_usuario
      AND  h.id_contenido = p_id_contenido;
    
    SELECT NVL(duracion_min, 0) INTO v_duracion
    FROM   CONTENIDO WHERE id_contenido = p_id_contenido;
    
    IF v_duracion = 0 THEN
        RETURN 0;
    END IF;
    
    v_porcentaje := ROUND((v_minutos_vistos / v_duracion) * 100, 1);
    
    RETURN LEAST(v_porcentaje, 100);  -- No puede superar 100%
END calcular_porcentaje_visto;
/

-- Probar la función
SELECT 
    u.nombre,
    c.titulo,
    calcular_porcentaje_visto(u.id_usuario, c.id_contenido) AS porcentaje_visto
FROM HISTORIAL_REPRODUCCION h
JOIN USUARIOS u ON h.id_usuario = u.id_usuario
JOIN CONTENIDO c ON h.id_contenido = c.id_contenido
WHERE c.tipo = 'PELICULA'
ORDER BY porcentaje_visto DESC;
