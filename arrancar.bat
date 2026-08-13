@echo off
title Channel Breakout - Servidor
color 0B

echo ============================================
echo   CHANNEL BREAKOUT - Iniciando servidor...
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
echo Verificando dependencias...
pip show flask        >nul 2>&1 || pip install flask        -q
pip show flask-cors   >nul 2>&1 || pip install flask-cors   -q
pip show pandas       >nul 2>&1 || pip install pandas       -q
pip show numpy        >nul 2>&1 || pip install numpy        -q
pip show matplotlib   >nul 2>&1 || pip install matplotlib   -q
pip show MetaTrader5  >nul 2>&1 || pip install MetaTrader5  -q
echo Dependencias OK
echo.

:: ── 4. Aviso sobre MetaTrader 5 ─────────────────────────────────
echo IMPORTANTE: MetaTrader 5 debe estar ABIERTO y con sesion iniciada.
echo Si no lo está, se mostraran datos DEMO.
echo.

:: ── 5. Abrir navegador y arrancar servidor ───────────────────────

:: Abrir también el archivo index.html local
if exist "%~dp0index.html" (
    start "" "%~dp0index.html"
) else (
    echo ADVERTENCIA: No se encontró index.html en %~dp0
)

echo Servidor corriendo en http://localhost:5051
echo Deja esta ventana abierta mientras usas el grafico.
echo Cierra esta ventana para detener el servidor.
echo.

"%~dp0\venv\Scripts\python.exe" servidor.py

:: ── Si servidor.py se cerro solo (crash) ─────────────────────────
echo.
echo ============================================
echo   El servidor se detuvo o fallo al arrancar.
echo   Copia el error de arriba y pasamelo.
echo ============================================
pause
