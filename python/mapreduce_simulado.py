#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
============================================================
SIMULACION LOCAL DE MAPREDUCE EN PYTHON
Proyecto: Análisis Big Data - Plataforma de Streaming
Dataset:  datos/streaming_ampliado.csv
============================================================
Este script simula el paradigma MapReduce sin necesidad de
tener Hadoop instalado. Implementa los 5 análisis del proyecto
usando las mismas lógicas que los Jobs Java.

Requisitos: Python 3.8+  (sin dependencias externas)

Uso:
    python mapreduce_simulado.py
============================================================
"""

import csv
import os
from collections import defaultdict
from functools import reduce

# ─────────────────────────────────────────────────────────────
# Ruta al dataset
# ─────────────────────────────────────────────────────────────
BASE_DIR    = os.path.dirname(os.path.abspath(__file__))
DATASET_CSV = os.path.join(BASE_DIR, "..", "datos", "streaming_ampliado.csv")
RESULTS_DIR = os.path.join(BASE_DIR, "..", "resultados")


# ─────────────────────────────────────────────────────────────
# Utilidades generales
# ─────────────────────────────────────────────────────────────
def leer_csv(ruta: str):
    """Lee el CSV y devuelve una lista de diccionarios."""
    registros = []
    with open(ruta, encoding="utf-8") as f:
        lector = csv.DictReader(f)
        for fila in lector:
            registros.append({k: v.strip() for k, v in fila.items()})
    return registros


def guardar_resultado(nombre_archivo: str, lineas: list):
    """Guarda una lista de líneas en el directorio resultados/."""
    os.makedirs(RESULTS_DIR, exist_ok=True)
    ruta = os.path.join(RESULTS_DIR, nombre_archivo)
    with open(ruta, "w", encoding="utf-8") as f:
        for linea in lineas:
            f.write(linea + "\n")
    print(f"  → Resultado guardado en: {ruta}")


def separador(titulo: str):
    print("\n" + "=" * 60)
    print(f"  {titulo}")
    print("=" * 60)


# ─────────────────────────────────────────────────────────────
# ANÁLISIS 1: Conteo de contenido por género
# ─────────────────────────────────────────────────────────────
def analisis_conteo_genero(registros):
    separador("ANÁLISIS 1 — Conteo de Contenido por Género")

    # ── FASE MAP ──────────────────────────────────────────────
    pares_mapeados = []  # Lista de (genero, 1)
    for fila in registros:
        for col in ["genero_1", "genero_2", "genero_3"]:
            genero = fila.get(col, "").strip()
            if genero:
                pares_mapeados.append((genero, 1))

    print(f"  MAP: {len(pares_mapeados)} pares (genero, 1) emitidos")

    # ── FASE SHUFFLE (agrupación) ──────────────────────────────
    grupos = defaultdict(list)
    for clave, valor in pares_mapeados:
        grupos[clave].append(valor)

    # ── FASE REDUCE ───────────────────────────────────────────
    resultado = {genero: sum(valores) for genero, valores in grupos.items()}
    ordenado  = sorted(resultado.items(), key=lambda x: x[1], reverse=True)

    print(f"  REDUCE: {len(ordenado)} géneros únicos\n")
    print(f"  {'GÉNERO':<25} {'TÍTULOS':>10}")
    print(f"  {'─'*25} {'─'*10}")

    lineas_archivo = ["GÉNERO\t\t\t\tTÍTULOS", "-" * 40]
    for genero, conteo in ordenado:
        barra = "█" * min(conteo, 30)
        print(f"  {genero:<25} {conteo:>6}  {barra}")
        lineas_archivo.append(f"{genero}\t{conteo}")

    guardar_resultado("resultado_conteo_genero.txt", lineas_archivo)
    return resultado


# ─────────────────────────────────────────────────────────────
# ANÁLISIS 2: Promedio de puntuación por país
# ─────────────────────────────────────────────────────────────
def analisis_promedio_puntuacion(registros):
    separador("ANÁLISIS 2 — Promedio de Puntuación por País")

    # ── FASE MAP ──────────────────────────────────────────────
    pares_mapeados = []
    for fila in registros:
        pais      = fila.get("pais", "").strip()
        punt_str  = fila.get("puntuacion", "").strip()
        if pais and punt_str:
            try:
                pares_mapeados.append((pais, float(punt_str)))
            except ValueError:
                pass

    print(f"  MAP: {len(pares_mapeados)} pares (pais, puntuacion) emitidos")

    # ── FASE SHUFFLE ──────────────────────────────────────────
    grupos = defaultdict(list)
    for clave, valor in pares_mapeados:
        grupos[clave].append(valor)

    # ── FASE REDUCE ───────────────────────────────────────────
    resultado = {}
    for pais, punts in grupos.items():
        resultado[pais] = {
            "promedio": round(sum(punts) / len(punts), 2),
            "titulos":  len(punts),
            "min":      round(min(punts), 1),
            "max":      round(max(punts), 1),
        }

    ordenado = sorted(resultado.items(), key=lambda x: x[1]["promedio"], reverse=True)

    print(f"  REDUCE: {len(ordenado)} países únicos\n")
    print(f"  {'PAÍS':<20} {'PROM':>6} {'TÍTULOS':>8} {'MIN':>5} {'MAX':>5}")
    print(f"  {'─'*20} {'─'*6} {'─'*8} {'─'*5} {'─'*5}")

    lineas_archivo = ["PAÍS\tPROMEDIO\tTÍTULOS\tMIN\tMAX", "-" * 55]
    for pais, stats in ordenado:
        print(f"  {pais:<20} {stats['promedio']:>6.2f} {stats['titulos']:>8} "
              f"{stats['min']:>5.1f} {stats['max']:>5.1f}")
        lineas_archivo.append(
            f"{pais}\tpromedio={stats['promedio']}\ttitulos={stats['titulos']}"
            f"\tmin={stats['min']}\tmax={stats['max']}"
        )

    guardar_resultado("resultado_promedio_puntuacion.txt", lineas_archivo)
    return resultado


# ─────────────────────────────────────────────────────────────
# ANÁLISIS 3: Análisis de ingresos por director
# ─────────────────────────────────────────────────────────────
def analisis_ingresos(registros):
    separador("ANÁLISIS 3 — Análisis de Ingresos por Director")

    # ── FASE MAP ──────────────────────────────────────────────
    pares_mapeados = []
    for fila in registros:
        director  = fila.get("director", "").strip()
        presup_s  = fila.get("presupuesto_usd", "").strip()
        recaud_s  = fila.get("recaudacion_usd", "").strip()

        if not director or not recaud_s:
            continue
        try:
            recaud = int(recaud_s)
            presup = int(presup_s) if presup_s else 0
            pares_mapeados.append((director, {"presup": presup, "recaud": recaud}))
        except ValueError:
            pass

    print(f"  MAP: {len(pares_mapeados)} pares (director, datos_financieros) emitidos")

    # ── FASE SHUFFLE ──────────────────────────────────────────
    grupos = defaultdict(list)
    for clave, valor in pares_mapeados:
        grupos[clave].append(valor)

    # ── FASE REDUCE ───────────────────────────────────────────
    resultado = {}
    for director, datos in grupos.items():
        total_recaud = sum(d["recaud"] for d in datos)
        total_presup = sum(d["presup"] for d in datos)
        peliculas    = len(datos)
        roi          = round(total_recaud / total_presup, 2) if total_presup > 0 else 0.0

        resultado[director] = {
            "peliculas":    peliculas,
            "total_recaud": total_recaud,
            "prom_recaud":  total_recaud // peliculas,
            "roi":          roi,
        }

    ordenado = sorted(resultado.items(), key=lambda x: x[1]["total_recaud"], reverse=True)

    print(f"  REDUCE: {len(ordenado)} directores con datos financieros\n")
    print(f"  {'DIRECTOR':<30} {'TÍTULOS':>7} {'RECAUD. TOTAL':>15} {'ROI':>6}")
    print(f"  {'─'*30} {'─'*7} {'─'*15} {'─'*6}")

    lineas_archivo = ["DIRECTOR\tTÍTULOS\tRECAUD_TOTAL_USD\tPROM_USD\tROI", "-" * 65]
    for director, stats in ordenado[:15]:
        print(f"  {director:<30} {stats['peliculas']:>7} "
              f"${stats['total_recaud']:>14,} {stats['roi']:>5.1f}x")
        lineas_archivo.append(
            f"{director}\tpeliculas={stats['peliculas']}"
            f"\ttotal_recaud={stats['total_recaud']}"
            f"\tpromedio={stats['prom_recaud']}"
            f"\troi={stats['roi']}"
        )

    guardar_resultado("resultado_ingresos.txt", lineas_archivo)
    return resultado


# ─────────────────────────────────────────────────────────────
# ANÁLISIS 4: Top 10 contenido más visto
# ─────────────────────────────────────────────────────────────
def analisis_top_vistas(registros):
    separador("ANÁLISIS 4 — Top 10 Contenido Más Visto")

    # ── FASE MAP ──────────────────────────────────────────────
    pares_mapeados = []
    for fila in registros:
        titulo  = fila.get("titulo", "").strip()
        tipo    = fila.get("tipo", "").strip()
        vista_s = fila.get("vistas", "").strip()

        if not titulo or not vista_s:
            continue
        try:
            vistas = int(vista_s)
            pares_mapeados.append((f"{titulo} [{tipo}]", vistas))
        except ValueError:
            pass

    print(f"  MAP: {len(pares_mapeados)} pares (titulo, vistas) emitidos")

    # ── FASE SHUFFLE + REDUCE ─────────────────────────────────
    grupos = defaultdict(list)
    for clave, valor in pares_mapeados:
        grupos[clave].append(valor)

    totales = {titulo: sum(vals) for titulo, vals in grupos.items()}

    # Ordenar y tomar Top 10
    top10 = sorted(totales.items(), key=lambda x: x[1], reverse=True)[:10]

    print(f"  REDUCE: Top 10 seleccionado de {len(totales)} títulos\n")
    print(f"  {'#':>3} {'TÍTULO':<45} {'VISTAS':>12}")
    print(f"  {'─'*3} {'─'*45} {'─'*12}")

    lineas_archivo = ["#\tTÍTULO\t\t\t\t\tVISTAS", "-" * 65]
    for i, (titulo, vistas) in enumerate(top10, 1):
        print(f"  {i:>3} {titulo:<45} {vistas:>12,}")
        lineas_archivo.append(f"#{i}\t{titulo}\t{vistas}")

    guardar_resultado("resultado_top_vistas.txt", lineas_archivo)
    return top10


# ─────────────────────────────────────────────────────────────
# ANÁLISIS 5: Tendencias de producción por año
# ─────────────────────────────────────────────────────────────
def analisis_tendencias_anio(registros):
    separador("ANÁLISIS 5 — Tendencias de Producción por Año")

    # ── FASE MAP ──────────────────────────────────────────────
    pares_mapeados = []
    for fila in registros:
        anio     = fila.get("anio", "").strip()
        tipo     = fila.get("tipo", "").strip()
        punt_s   = fila.get("puntuacion", "").strip()
        vista_s  = fila.get("vistas", "").strip()

        if not anio or not punt_s:
            continue
        try:
            pares_mapeados.append((int(anio), {
                "tipo":      tipo,
                "puntuacion": float(punt_s),
                "vistas":    int(vista_s) if vista_s else 0,
            }))
        except ValueError:
            pass

    print(f"  MAP: {len(pares_mapeados)} pares (anio, datos) emitidos")

    # ── FASE SHUFFLE ──────────────────────────────────────────
    grupos = defaultdict(list)
    for clave, valor in pares_mapeados:
        grupos[clave].append(valor)

    # ── FASE REDUCE ───────────────────────────────────────────
    resultado = {}
    for anio, datos in grupos.items():
        peliculas   = sum(1 for d in datos if d["tipo"] == "pelicula")
        series      = sum(1 for d in datos if d["tipo"] == "serie")
        punt_prom   = round(sum(d["puntuacion"] for d in datos) / len(datos), 2)
        total_vistas = sum(d["vistas"] for d in datos)

        resultado[anio] = {
            "total":        len(datos),
            "peliculas":    peliculas,
            "series":       series,
            "punt_prom":    punt_prom,
            "total_vistas": total_vistas,
        }

    ordenado = sorted(resultado.items())

    print(f"  REDUCE: {len(ordenado)} años únicos\n")
    print(f"  {'AÑO':>5} {'TOTAL':>7} {'PELÍCS':>8} {'SERIES':>7} {'PROM.PUNT':>10} {'VISTAS':>15}")
    print(f"  {'─'*5} {'─'*7} {'─'*8} {'─'*7} {'─'*10} {'─'*15}")

    lineas_archivo = ["AÑO\tTITULOS\tPELICULAS\tSERIES\tPUNT_PROM\tVISTAS_TOTAL", "-" * 70]
    for anio, stats in ordenado:
        print(f"  {anio:>5} {stats['total']:>7} {stats['peliculas']:>8} "
              f"{stats['series']:>7} {stats['punt_prom']:>10.2f} {stats['total_vistas']:>15,}")
        lineas_archivo.append(
            f"{anio}\ttitulos={stats['total']}\tpeliculas={stats['peliculas']}"
            f"\tseries={stats['series']}\tpunt_prom={stats['punt_prom']}"
            f"\tvistas_total={stats['total_vistas']}"
        )

    guardar_resultado("resultado_tendencias.txt", lineas_archivo)
    return resultado


# ─────────────────────────────────────────────────────────────
# PUNTO DE ENTRADA
# ─────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("\n" + "=" * 60)
    print("  SIMULACIÓN MAPREDUCE — PLATAFORMA DE STREAMING")
    print("  Dataset: streaming_ampliado.csv")
    print("=" * 60)

    # Cargar datos
    print(f"\n  Cargando dataset desde: {DATASET_CSV}")
    registros = leer_csv(DATASET_CSV)
    print(f"  Total de registros cargados: {len(registros)}")

    # Ejecutar los 5 análisis
    analisis_conteo_genero(registros)
    analisis_promedio_puntuacion(registros)
    analisis_ingresos(registros)
    analisis_top_vistas(registros)
    analisis_tendencias_anio(registros)

    print("\n" + "=" * 60)
    print("  SIMULACIÓN COMPLETADA EXITOSAMENTE")
    print(f"  Resultados guardados en: {RESULTS_DIR}")
    print("=" * 60 + "\n")
