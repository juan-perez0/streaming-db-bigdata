#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
============================================================
VISUALIZACIÓN DE RESULTADOS MapReduce
Proyecto: Análisis Big Data - Plataforma de Streaming
============================================================
Lee los archivos de resultados generados por mapreduce_simulado.py
y crea gráficos con matplotlib para incluir en el informe técnico.

Requisitos: Python 3.8+, matplotlib, pandas (ver requirements.txt)

Uso:
    pip install -r requirements.txt
    python analisis_resultados.py
============================================================
"""

import os
import sys

# Verificar dependencias
try:
    import matplotlib
    matplotlib.use("Agg")  # Backend sin pantalla
    import matplotlib.pyplot as plt
    import matplotlib.patches as mpatches
    import pandas as pd
    import numpy as np
except ImportError as e:
    print(f"ERROR: Dependencia faltante → {e}")
    print("Instale con:  pip install -r requirements.txt")
    sys.exit(1)

BASE_DIR     = os.path.dirname(os.path.abspath(__file__))
RESULTS_DIR  = os.path.join(BASE_DIR, "..", "resultados")
DATASET_PATH = os.path.join(BASE_DIR, "..", "datos", "streaming_ampliado.csv")

# Paleta de colores corporativa
COLORES = ["#2196F3", "#FF5722", "#4CAF50", "#9C27B0",
           "#FF9800", "#00BCD4", "#F44336", "#8BC34A",
           "#795548", "#607D8B", "#E91E63", "#3F51B5"]


# ─────────────────────────────────────────────────────────────
# Utilidades
# ─────────────────────────────────────────────────────────────
def guardar_figura(nombre: str):
    ruta = os.path.join(RESULTS_DIR, nombre)
    plt.tight_layout()
    plt.savefig(ruta, dpi=150, bbox_inches="tight", facecolor="white")
    plt.close()
    print(f"  → Gráfico guardado: {nombre}")


def estilo_base():
    plt.rcParams.update({
        "figure.facecolor": "white",
        "axes.facecolor":   "#F8F9FA",
        "axes.grid":        True,
        "grid.alpha":       0.4,
        "font.family":      "sans-serif",
        "font.size":        10,
    })


# ─────────────────────────────────────────────────────────────
# GRÁFICO 1: Barras horizontales — Géneros más populares
# ─────────────────────────────────────────────────────────────
def grafico_generos(df: pd.DataFrame):
    print("\n  Generando gráfico 1: Géneros más populares...")

    generos = {}
    for col in ["genero_1", "genero_2", "genero_3"]:
        counts = df[col].dropna().str.strip()
        counts = counts[counts != ""]
        for g, c in counts.value_counts().items():
            generos[g] = generos.get(g, 0) + c

    serie = pd.Series(generos).sort_values(ascending=True).tail(15)

    fig, ax = plt.subplots(figsize=(10, 7))
    bars = ax.barh(serie.index, serie.values, color=COLORES[:len(serie)], edgecolor="white")

    for bar, val in zip(bars, serie.values):
        ax.text(bar.get_width() + 0.3, bar.get_y() + bar.get_height() / 2,
                f"{val}", va="center", ha="left", fontsize=9, fontweight="bold")

    ax.set_title("Distribución de Contenido por Género\n(MapReduce Job 01 — Conteo por Género)",
                 fontsize=13, fontweight="bold", pad=15)
    ax.set_xlabel("Número de Títulos", fontsize=11)
    ax.set_ylabel("Género", fontsize=11)
    ax.set_xlim(0, serie.max() * 1.15)

    guardar_figura("grafico_01_generos.png")


# ─────────────────────────────────────────────────────────────
# GRÁFICO 2: Barras agrupadas — Puntuación promedio por país
# ─────────────────────────────────────────────────────────────
def grafico_puntuacion_pais(df: pd.DataFrame):
    print("  Generando gráfico 2: Puntuación promedio por país...")

    df["puntuacion"] = pd.to_numeric(df["puntuacion"], errors="coerce")
    stats = df.groupby("pais").agg(
        promedio=("puntuacion", "mean"),
        titulos=("puntuacion", "count")
    ).reset_index()
    stats = stats[stats["titulos"] >= 2].sort_values("promedio", ascending=False).head(12)

    fig, ax1 = plt.subplots(figsize=(12, 6))
    ax2 = ax1.twinx()

    x = range(len(stats))
    bars = ax1.bar(x, stats["promedio"], color=COLORES[:len(stats)],
                   alpha=0.85, label="Puntuación Promedio", zorder=3)
    ax2.plot(x, stats["titulos"], "ko--", markersize=7, linewidth=1.5,
             label="Nº de Títulos", zorder=4)

    ax1.set_xticks(x)
    ax1.set_xticklabels(stats["pais"], rotation=35, ha="right", fontsize=9)
    ax1.set_ylabel("Puntuación Promedio (0-10)", fontsize=11)
    ax2.set_ylabel("Número de Títulos", fontsize=11)
    ax1.set_ylim(7, 10)
    ax1.set_title("Puntuación Promedio por País Productor\n(MapReduce Job 02 — Promedio por País)",
                  fontsize=13, fontweight="bold", pad=15)

    for bar, val in zip(bars, stats["promedio"]):
        ax1.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.02,
                 f"{val:.2f}", ha="center", va="bottom", fontsize=9, fontweight="bold")

    lines1, labels1 = ax1.get_legend_handles_labels()
    lines2, labels2 = ax2.get_legend_handles_labels()
    ax1.legend(lines1 + lines2, labels1 + labels2, loc="upper right")

    guardar_figura("grafico_02_puntuacion_pais.png")


# ─────────────────────────────────────────────────────────────
# GRÁFICO 3: Top 10 vistas — Barras horizontales con gradiente
# ─────────────────────────────────────────────────────────────
def grafico_top_vistas(df: pd.DataFrame):
    print("  Generando gráfico 3: Top 10 más vistos...")

    df["vistas"] = pd.to_numeric(df["vistas"], errors="coerce")
    top = df.dropna(subset=["vistas"]).nlargest(10, "vistas")[["titulo", "tipo", "vistas"]]
    top = top.sort_values("vistas", ascending=True)

    colores_tipo = top["tipo"].map({"pelicula": "#2196F3", "serie": "#FF5722"})

    fig, ax = plt.subplots(figsize=(11, 7))
    bars = ax.barh(top["titulo"], top["vistas"] / 1_000_000,
                   color=colores_tipo, edgecolor="white", height=0.7)

    for bar, val in zip(bars, top["vistas"]):
        ax.text(bar.get_width() + 0.5, bar.get_y() + bar.get_height() / 2,
                f"{val/1_000_000:.1f}M", va="center", fontsize=9, fontweight="bold")

    leyenda = [
        mpatches.Patch(color="#2196F3", label="Película"),
        mpatches.Patch(color="#FF5722", label="Serie"),
    ]
    ax.legend(handles=leyenda, loc="lower right")
    ax.set_title("Top 10 Contenido Más Visto en la Plataforma\n(MapReduce Job 04 — Top N Vistas)",
                 fontsize=13, fontweight="bold", pad=15)
    ax.set_xlabel("Visualizaciones (millones)", fontsize=11)
    ax.set_xlim(0, top["vistas"].max() / 1_000_000 * 1.2)

    guardar_figura("grafico_03_top_vistas.png")


# ─────────────────────────────────────────────────────────────
# GRÁFICO 4: Línea temporal — Producciones por año
# ─────────────────────────────────────────────────────────────
def grafico_tendencias_anio(df: pd.DataFrame):
    print("  Generando gráfico 4: Tendencias por año...")

    df["anio"] = pd.to_numeric(df["anio"], errors="coerce")
    df["puntuacion"] = pd.to_numeric(df["puntuacion"], errors="coerce")

    # Solo años desde 1990
    df_reciente = df[df["anio"] >= 1990].copy()

    por_anio = df_reciente.groupby(["anio", "tipo"]).size().unstack(fill_value=0)
    punt_anio = df_reciente.groupby("anio")["puntuacion"].mean()

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(13, 9), sharex=True)

    # Subplot 1: Producciones por año (apiladas)
    if "pelicula" in por_anio.columns:
        ax1.bar(por_anio.index, por_anio.get("pelicula", 0),
                label="Películas", color="#2196F3", alpha=0.8)
    if "serie" in por_anio.columns:
        ax1.bar(por_anio.index, por_anio.get("serie", 0),
                bottom=por_anio.get("pelicula", 0),
                label="Series", color="#FF5722", alpha=0.8)
    ax1.set_ylabel("Nº de Títulos", fontsize=11)
    ax1.set_title("Tendencias de Producción Anual\n(MapReduce Job 05 — Tendencias por Año)",
                  fontsize=13, fontweight="bold", pad=15)
    ax1.legend()

    # Subplot 2: Puntuación promedio por año
    ax2.plot(punt_anio.index, punt_anio.values, "g-o",
             markersize=5, linewidth=2, label="Puntuación Promedio")
    ax2.fill_between(punt_anio.index, punt_anio.values, alpha=0.2, color="green")
    ax2.set_ylabel("Puntuación Promedio", fontsize=11)
    ax2.set_xlabel("Año de Estreno", fontsize=11)
    ax2.set_ylim(6, 10)
    ax2.legend()

    plt.xticks(rotation=45)
    guardar_figura("grafico_04_tendencias.png")


# ─────────────────────────────────────────────────────────────
# GRÁFICO 5: Distribución por idioma — Pastel
# ─────────────────────────────────────────────────────────────
def grafico_idiomas(df: pd.DataFrame):
    print("  Generando gráfico 5: Distribución por idioma...")

    conteo_idioma = df["idioma"].value_counts()

    # Agrupar idiomas con < 3 en "Otros"
    umbral = 3
    otros = conteo_idioma[conteo_idioma < umbral].sum()
    conteo_idioma = conteo_idioma[conteo_idioma >= umbral]
    if otros > 0:
        conteo_idioma["Otros"] = otros

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 6))

    # Pie chart
    wedges, texts, autotexts = ax1.pie(
        conteo_idioma.values,
        labels=conteo_idioma.index,
        autopct="%1.1f%%",
        colors=COLORES[:len(conteo_idioma)],
        startangle=140,
        pctdistance=0.75,
    )
    for t in autotexts:
        t.set_fontsize(9)
    ax1.set_title("Distribución de Contenido\npor Idioma Original", fontsize=12, fontweight="bold")

    # Barras por tipo de contenido
    peliculas = df[df["tipo"] == "pelicula"]["idioma"].value_counts().head(8)
    series    = df[df["tipo"] == "serie"]["idioma"].value_counts().head(8)

    idiomas_comunes = list(set(peliculas.index) | set(series.index))
    x = range(len(idiomas_comunes))
    vals_p = [peliculas.get(i, 0) for i in idiomas_comunes]
    vals_s = [series.get(i, 0) for i in idiomas_comunes]

    w = 0.35
    ax2.bar([xi - w / 2 for xi in x], vals_p, w, label="Películas", color="#2196F3", alpha=0.85)
    ax2.bar([xi + w / 2 for xi in x], vals_s, w, label="Series", color="#FF5722", alpha=0.85)
    ax2.set_xticks(list(x))
    ax2.set_xticklabels(idiomas_comunes, rotation=35, ha="right")
    ax2.set_title("Películas vs Series\npor Idioma", fontsize=12, fontweight="bold")
    ax2.set_ylabel("Número de Títulos")
    ax2.legend()

    guardar_figura("grafico_05_idiomas.png")


# ─────────────────────────────────────────────────────────────
# PUNTO DE ENTRADA
# ─────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("  VISUALIZACIÓN DE RESULTADOS MapReduce")
    print("  Generando gráficos para el informe técnico")
    print("=" * 60)

    if not os.path.exists(DATASET_PATH):
        print(f"\nERROR: No se encontró el dataset en:\n  {DATASET_PATH}")
        sys.exit(1)

    # Cargar dataset
    print(f"\n  Cargando: {DATASET_PATH}")
    df = pd.read_csv(DATASET_PATH, encoding="utf-8")
    df.columns = df.columns.str.strip()
    print(f"  Registros cargados: {len(df)}")

    os.makedirs(RESULTS_DIR, exist_ok=True)
    estilo_base()

    print("\n  Generando gráficos...")
    grafico_generos(df)
    grafico_puntuacion_pais(df)
    grafico_top_vistas(df)
    grafico_tendencias_anio(df)
    grafico_idiomas(df)

    print("\n" + "=" * 60)
    print("  VISUALIZACIONES GENERADAS EXITOSAMENTE")
    print(f"  Archivos PNG en: {RESULTS_DIR}")
    print("=" * 60 + "\n")
