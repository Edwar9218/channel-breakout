@echo off
title Auto S/R Channels + Kalman Flow - Servidor
color 0B

echo ============================================
echo   AUTO CHANNELS + KALMAN - Iniciando...
echo ============================================
echo.

:: Ir a la carpeta donde está el bat
cd /d "%~dp0"

:: ── 1. Crear entorno virtual si no existe ────────────────────────
if not exist "venv\Scripts\activate.bat" (
    echo Creando entorno virtual...
    python -m venv venv
    if errorlevel 1 (
        echo ERROR: No se pudo crear el entorno virtual.
        echo Asegurate de tener Python instalado.
        pause
        exit /b 1
    )
    echo Entorno virtual creado OK
) else (
    echo Entorno virtual ya existe OK
)
echo.

:: ── 2. Activar entorno virtual ───────────────────────────────────
echo Activando entorno virtual...
call venv\Scripts\activate.bat
echo.

:: ── 3. Instalar dependencias si faltan ──────────────────────────
:: (matplotlib hace falta porque auto_channels.py lo importa a nivel de
::  modulo, aunque este servidor no genera imagenes .png)
echo Verificando dependencias...
pip show flask        >nul 2>&1 || pip install flask        -q
pip show flask-cors   >nul 2>&1 || pip install flask-cors   -q
pip show pandas       >nul 2>&1 || pip install pandas       -q
pip show numpy        >nul 2>&1 || pip install numpy        -q
pip show matplotlib   >nul 2>&1 || pip install matplotlib   -q
pip show MetaTrader5  >nul 2>&1 || pip install MetaTrader5  -q
echo Dependencias OK
echo.

:: ── 4. Aviso si MetaTrader 5 no esta abierto ─────────────────────
echo IMPORTANTE: el terminal MetaTrader 5 debe estar ABIERTO y con
echo             sesion iniciada en tu cuenta/broker para poder
echo             traer datos en vivo. Si no lo esta, el grafico
echo             va a mostrar datos DEMO en su lugar.
echo.

:: ── 5. Abrir navegador y arrancar servidor ───────────────────────
echo Abriendo grafico en el navegador...
start "" "http://localhost:5051"

echo Servidor corriendo en http://localhost:5051
echo Deja esta ventana abierta mientras usas el grafico.
echo Cierra esta ventana para detener el servidor.
echo.

python servidor.py

:: ── Si servidor.py se cerro solo (crash), la ventana NO se cierra ──
:: para que puedas leer el error de arriba antes de cerrarla vos mismo.
echo.
echo ============================================
echo   El servidor se detuvo o fallo al arrancar.
echo   Copia el error de arriba y pasamelo.
echo ============================================
pause
