# 📂 Descripción de los Datos

## Archivos disponibles

### `streaming_ampliado.csv`

Dataset ampliado con información de películas y series de plataformas de streaming. Contiene **100 registros** con datos realistas de títulos reconocidos a nivel mundial.

#### Columnas

| Columna | Tipo | Descripción |
|---|---|---|
| `titulo` | texto | Nombre del título (película o serie) |
| `tipo` | texto | `pelicula` o `serie` |
| `anio` | entero | Año de estreno (rango: 2000–2025) |
| `director` | texto | Director o creador principal |
| `genero_1` | texto | Género principal |
| `genero_2` | texto | Género secundario (puede estar vacío) |
| `genero_3` | texto | Género terciario (puede estar vacío) |
| `idioma` | texto | Idioma principal del contenido |
| `puntuacion` | decimal | Puntuación promedio (escala 1.0–10.0) |
| `vistas` | entero | Cantidad de visualizaciones estimadas |
| `duracion_min` | entero | Duración en minutos (**solo para películas**) |
| `temporadas` | entero | Número de temporadas (**solo para series**) |
| `episodios` | entero | Número total de episodios (**solo para series**) |
| `clasificacion` | texto | Clasificación de contenido (PG, PG-13, R, G, TV-MA, TV-14, TV-PG) |
| `pais` | texto | País de origen |
| `presupuesto_usd` | entero | Presupuesto en dólares USD (**solo para películas**) |
| `recaudacion_usd` | entero | Recaudación en taquilla en USD (**solo para películas**) |

#### Valores únicos por columna categórica

- **Idiomas**: Inglés, Español, Coreano, Japonés, Francés, Alemán, Hindi, Portugués, Noruego, Danés, Turco, Italiano
- **Países**: Estados Unidos, España, Corea del Sur, Japón, Francia, Alemania, India, Brasil, México, Colombia, Reino Unido, Argentina, Italia, Australia, Noruega, Dinamarca, Turquía
- **Géneros**: Acción, Drama, Comedia, Terror, Ciencia Ficción, Romance, Thriller, Crimen, Animación, Documental, Fantasía, Musical, Aventura, Misterio, Bélico, Biografía, Western, Deportes, Histórico, Superhéroes

#### Notas importantes

- Para registros de tipo `pelicula`, los campos `temporadas` y `episodios` están vacíos.
- Para registros de tipo `serie`, los campos `duracion_min`, `presupuesto_usd` y `recaudacion_usd` están vacíos.
- Los datos numéricos (presupuesto, recaudación, vistas) son valores realistas basados en información pública.
- El dataset incluye una mezcla diversa de contenido internacional y de distintos géneros.

---

*Datos recopilados con fines académicos y de análisis.*
