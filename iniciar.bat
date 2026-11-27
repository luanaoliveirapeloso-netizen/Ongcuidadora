@echo off
cd /d "%~dp0"
set "NODE="
for %%P in ("%USERPROFILE%\node\node.exe" "%LOCALAPPDATA%\Programs\nodejs\node.exe" "%ProgramFiles%\nodejs\node.exe") do if not defined NODE if exist %%P set "NODE=%%~P"
if not defined NODE if exist "%USERPROFILE%\node" for /r "%USERPROFILE%\node" %%F in (node.exe) do if not defined NODE if exist "%%F" set "NODE=%%F"
if not defined NODE for /f "delims=" %%F in ('where node 2^>nul') do if not defined NODE set "NODE=%%F"
if not defined NODE (
  echo Node.js nao encontrado.
  echo Extraia o zip do Node em %USERPROFILE%\node
  pause
  exit /b 1
)
echo Usando Node: %NODE%
start "API" cmd /k ""%NODE%" --env-file=.env server/index.js"
timeout /t 2 >nul
start "Site" cmd /k ""%NODE%" node_modules\vite\bin\vite.js --open"