-- ============================================================
-- SCRIPT 01: CREACIÓN DE TABLAS - SISTEMA STREAMING
-- Base de datos: NewSQL (Oracle SQL Developer)
-- Autor: Diego
-- Descripción: Estructura de base de datos para plataforma
--              de streaming tipo Netflix/HBO
-- ============================================================

-- Eliminar tablas si ya existen (orden inverso de FK)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE HISTORIAL_REPRODUCCION CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CALIFICACIONES CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CONTENIDO_GENERO CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EPISODIOS CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE TEMPORADAS CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE CONTENIDO CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE GENEROS CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE USUARIOS CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE PLANES CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ----------------------------------------------------------
-- TABLA: PLANES (Planes de suscripción)
-- ----------------------------------------------------------
CREATE TABLE PLANES (
    id_plan      NUMBER(3)     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre       VARCHAR2(50)  NOT NULL,
    precio_mes   NUMBER(8,2)   NOT NULL,
    max_pantallas NUMBER(2)    DEFAULT 1 NOT NULL,
    calidad_video VARCHAR2(10) DEFAULT 'HD' NOT NULL,
    CONSTRAINT chk_calidad CHECK (calidad_video IN ('SD','HD','4K'))
);

-- ----------------------------------------------------------
-- TABLA: USUARIOS
-- ----------------------------------------------------------
CREATE TABLE USUARIOS (
    id_usuario   NUMBER(10)    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre       VARCHAR2(100) NOT NULL,
    email        VARCHAR2(150) NOT NULL UNIQUE,
    fecha_registro DATE        DEFAULT SYSDATE NOT NULL,
    pais         VARCHAR2(50)  DEFAULT 'Colombia',
    id_plan      NUMBER(3)     NOT NULL,
    activo       CHAR(1)       DEFAULT 'S' NOT NULL,
    CONSTRAINT fk_usuario_plan FOREIGN KEY (id_plan) REFERENCES PLANES(id_plan),
    CONSTRAINT chk_activo CHECK (activo IN ('S','N'))
);

-- ----------------------------------------------------------
-- TABLA: GENEROS
-- ----------------------------------------------------------
CREATE TABLE GENEROS (
    id_genero    NUMBER(5)     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre       VARCHAR2(80)  NOT NULL UNIQUE,
    descripcion  VARCHAR2(300)
);

-- ----------------------------------------------------------
-- TABLA: CONTENIDO (Películas y Series)
-- ----------------------------------------------------------
CREATE TABLE CONTENIDO (
    id_contenido  NUMBER(10)    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo        VARCHAR2(200) NOT NULL,
    tipo          VARCHAR2(10)  NOT NULL,        -- 'PELICULA' o 'SERIE'
    anio_estreno  NUMBER(4)     NOT NULL,
    duracion_min  NUMBER(5),                     -- NULL para series
    sinopsis      VARCHAR2(1000),
    idioma        VARCHAR2(50)  DEFAULT 'Inglés',
    clasificacion VARCHAR2(10)  DEFAULT 'PG-13',
    puntuacion    NUMBER(3,1)   DEFAULT 0,
    vistas        NUMBER(10)    DEFAULT 0,
    fecha_agregado DATE         DEFAULT SYSDATE,
    CONSTRAINT chk_tipo CHECK (tipo IN ('PELICULA','SERIE')),
    CONSTRAINT chk_puntuacion CHECK (puntuacion BETWEEN 0 AND 10)
);

-- ----------------------------------------------------------
-- TABLA: CONTENIDO_GENERO (Relación muchos a muchos)
-- ----------------------------------------------------------
CREATE TABLE CONTENIDO_GENERO (
    id_contenido NUMBER(10) NOT NULL,
    id_genero    NUMBER(5)  NOT NULL,
    CONSTRAINT pk_contenido_genero PRIMARY KEY (id_contenido, id_genero),
    CONSTRAINT fk_cg_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_cg_genero    FOREIGN KEY (id_genero)    REFERENCES GENEROS(id_genero)
);

-- ----------------------------------------------------------
-- TABLA: TEMPORADAS (solo para SERIE)
-- ----------------------------------------------------------
CREATE TABLE TEMPORADAS (
    id_temporada NUMBER(10)    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_contenido NUMBER(10)    NOT NULL,
    numero       NUMBER(3)     NOT NULL,
    anio         NUMBER(4),
    CONSTRAINT fk_temp_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT uq_temporada UNIQUE (id_contenido, numero)
);

-- ----------------------------------------------------------
-- TABLA: EPISODIOS
-- ----------------------------------------------------------
CREATE TABLE EPISODIOS (
    id_episodio   NUMBER(10)    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_temporada  NUMBER(10)    NOT NULL,
    numero        NUMBER(3)     NOT NULL,
    titulo        VARCHAR2(200) NOT NULL,
    duracion_min  NUMBER(4)     NOT NULL,
    CONSTRAINT fk_ep_temporada FOREIGN KEY (id_temporada) REFERENCES TEMPORADAS(id_temporada),
    CONSTRAINT uq_episodio UNIQUE (id_temporada, numero)
);

-- ----------------------------------------------------------
-- TABLA: HISTORIAL_REPRODUCCION
-- ----------------------------------------------------------
CREATE TABLE HISTORIAL_REPRODUCCION (
    id_historial    NUMBER(15)    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario      NUMBER(10)    NOT NULL,
    id_contenido    NUMBER(10)    NOT NULL,
    id_episodio     NUMBER(10),                  -- NULL si es película
    fecha_inicio    DATE          DEFAULT SYSDATE NOT NULL,
    minutos_vistos  NUMBER(5)     DEFAULT 0,
    completado      CHAR(1)       DEFAULT 'N',
    CONSTRAINT fk_hist_usuario   FOREIGN KEY (id_usuario)   REFERENCES USUARIOS(id_usuario),
    CONSTRAINT fk_hist_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_hist_episodio  FOREIGN KEY (id_episodio)  REFERENCES EPISODIOS(id_episodio),
    CONSTRAINT chk_completado CHECK (completado IN ('S','N'))
);

-- ----------------------------------------------------------
-- TABLA: CALIFICACIONES
-- ----------------------------------------------------------
CREATE TABLE CALIFICACIONES (
    id_calificacion NUMBER(15)   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario      NUMBER(10)   NOT NULL,
    id_contenido    NUMBER(10)   NOT NULL,
    puntos          NUMBER(2)    NOT NULL,
    comentario      VARCHAR2(500),
    fecha           DATE         DEFAULT SYSDATE,
    CONSTRAINT fk_cal_usuario   FOREIGN KEY (id_usuario)   REFERENCES USUARIOS(id_usuario),
    CONSTRAINT fk_cal_contenido FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT uq_calificacion  UNIQUE (id_usuario, id_contenido),
    CONSTRAINT chk_puntos CHECK (puntos BETWEEN 1 AND 10)
);

-- Verificar estructura creada
SELECT table_name, num_rows
FROM   user_tables
WHERE  table_name IN ('PLANES','USUARIOS','GENEROS','CONTENIDO',
                      'CONTENIDO_GENERO','TEMPORADAS','EPISODIOS',
                      'HISTORIAL_REPRODUCCION','CALIFICACIONES')
ORDER  BY table_name;
