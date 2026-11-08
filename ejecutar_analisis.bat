@echo off
chcp 65001 >nul
echo ======================================================
echo   CONFIGURACIÓN Y EJECUCIÓN — Proyecto Big Data
echo   Análisis de Streaming con MapReduce
echo ======================================================
echo.

:: ─────────────────────────────────────────────────────
:: Detectar Python
:: ─────────────────────────────────────────────────────
set PYTHON=
for %%p in (python python3) do (
    %%p --version >nul 2>&1 && set PYTHON=%%p
)

if "%PYTHON%"=="" (
    echo [!] Python no encontrado en PATH.
    echo     Descargar desde: https://www.python.org/downloads/
    echo     Marcar la opcion "Add Python to PATH" al instalar.
    echo.
    pause
    exit /b 1
)

echo [OK] Python encontrado: %PYTHON%
%PYTHON% --version
echo.

:: ─────────────────────────────────────────────────────
:: Instalar dependencias
:: ─────────────────────────────────────────────────────
echo Instalando dependencias Python...
%PYTHON% -m pip install -r python\requirements.txt --quiet
if errorlevel 1 (
    echo [ERROR] Fallo al instalar dependencias.
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas correctamente.
echo.

:: ─────────────────────────────────────────────────────
:: Ejecutar simulación MapReduce
:: ─────────────────────────────────────────────────────
echo ======================================================
echo   PASO 1: Ejecutando simulación MapReduce local...
echo ======================================================
%PYTHON% python\mapreduce_simulado.py
if errorlevel 1 (
    echo [ERROR] Fallo en la simulación MapReduce.
    pause
    exit /b 1
)
echo.

:: ─────────────────────────────────────────────────────
:: Generar visualizaciones
:: ─────────────────────────────────────────────────────
echo ======================================================
echo   PASO 2: Generando gráficos de análisis...
echo ======================================================
%PYTHON% python\analisis_resultados.py
if errorlevel 1 (
    echo [AVISO] Fallo al generar graficos (continua sin graficos)
) else (
    echo [OK] Graficos guardados en: resultados\
)
echo.

:: ─────────────────────────────────────────────────────
:: Resultado final
:: ─────────────────────────────────────────────────────
echo ======================================================
echo   COMPLETADO — Archivos generados:
echo ======================================================
echo.
dir resultados\ /b
echo.
echo Abrir graficos con el explorador de archivos:
start "" "resultados\"
echo.
pause

