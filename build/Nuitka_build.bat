@echo off
setlocal enabledelayedexpansion

REM ========================================
REM Logisim Launcher - Nuitka Build Script
REM ========================================
REM
REM Usage:  Double-click this file, or run from command line.
REM Prerequisites:
REM   - Python 3.8+  (3.9+ recommended)
REM   - A C compiler (MSVC / MinGW64 / clang)
REM   - Nuitka will auto-install if missing
REM
REM Output:
REM   - Binary files -> bin\  (exe + runtime DLLs/pyd, flat)
REM   - Intermediate  -> build\LogisimLauncher.build\  (reused by Nuitka)
REM
REM AV false-positive mitigation:
REM   1. --standalone: avoids onefile self-extraction pattern (dropper heuristic)
REM   2. version info metadata: makes exe look legitimate to heuristic scanners
REM   3. --lto=yes: link-time optimization for cleaner binary

REM --- Resolve directories from script location ---
REM Strip trailing backslash from %~dp0 to avoid escaping issues in quotes
set "BUILD_DIR=%~dp0"
if "%BUILD_DIR:~-1%"=="\" set "BUILD_DIR=%BUILD_DIR:~0,-1%"
set "SRC_DIR=%BUILD_DIR%\..\src"
set "BIN_DIR=%BUILD_DIR%\..\bin"
set "ICON_PATH=%BUILD_DIR%\Logisim.ico"
set "DIST_DIR=%BUILD_DIR%\LogisimLauncher.dist"

REM --- Verify source file exists ---
if not exist "%SRC_DIR%\LogisimLauncher.py" (
    echo [ERROR] LogisimLauncher.py not found in "%SRC_DIR%"
    echo Please check project structure.
    pause
    exit /b 1
)

REM --- Verify icon exists ---
if not exist "%ICON_PATH%" (
    echo [ERROR] Icon file not found: "%ICON_PATH%"
    pause
    exit /b 1
)

REM --- Check Python ---
where python >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Python not found in PATH. Please install Python 3.x.
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM --- Check / install Nuitka ---
python -m nuitka --version >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo [INFO] Nuitka not found. Installing...
    pip install nuitka
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Failed to install Nuitka.
        pause
        exit /b 1
    )
)

REM --- Navigate to source directory ---
cd /d "%SRC_DIR%"

REM --- Clean previous .dist (but keep .build for incremental reuse) ---
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"

REM --- Build (output to build\, .build reused across runs) ---
echo.
echo [BUILD] Compiling LogisimLauncher.py with Nuitka...
echo.
python -m nuitka ^
  --standalone ^
  --windows-console-mode=disable ^
  --windows-icon-from-ico="%ICON_PATH%" ^
  --company-name="Logisim-CN" ^
  --product-name="Logisim Launcher" ^
  --file-version=2.7.1.3 ^
  --product-version=2.7.1.3 ^
  --file-description="Logisim Chinese Version Launcher" ^
  --copyright="Logisim-CN Project" ^
  --lto=yes ^
  --assume-yes-for-downloads ^
  --output-dir="%BUILD_DIR%" ^
  LogisimLauncher.py

if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Build failed. See messages above.
    pause
    exit /b 1
)

REM --- Move all .dist files into bin\ (overwrite existing, auto-merge) ---
echo.
echo [MOVE] Moving .dist output into bin\...
move /y "%DIST_DIR%\*.*" "%BIN_DIR%\" >nul 2>&1

REM --- Remove the now-empty .dist directory ---
rmdir "%DIST_DIR%" 2>nul

REM --- Done ---
echo.
echo ========================================
echo [OK] Build complete!
echo.
echo Binary:  %BIN_DIR%\LogisimLauncher.exe
echo Inter:   %BUILD_DIR%\LogisimLauncher.build\ (preserved)
echo ========================================
pause
