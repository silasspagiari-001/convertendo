@echo off
rem Build do Atlas_MG (teste da casca do menu MiniGUI).
rem Ajuste MINIGUI_DIR para a pasta do seu MiniGUI (a que contem Compile.bat).
set MINIGUI_DIR=c:\minigui
if not exist "%MINIGUI_DIR%\Compile.bat" (
  echo Compile.bat nao encontrado em %MINIGUI_DIR%
  echo Ajuste MINIGUI_DIR neste arquivo.
  pause
  exit /b 1
)
call "%MINIGUI_DIR%\Compile.bat" menu_minigui /nl
if errorlevel 1 goto ERRO
call "%MINIGUI_DIR%\Compile.bat" stubs_migracao /nl
if errorlevel 1 goto ERRO
call "%MINIGUI_DIR%\Compile.bat" atlas_mg /b menu_minigui /b stubs_migracao
if errorlevel 1 goto ERRO
if exist atlas_mg.exe (
  echo.
  echo OK: atlas_mg.exe gerado nesta pasta.
) else (
  echo.
  echo ATENCAO: atlas_mg.exe nao foi gerado. Envie a saida completa.
)
pause
exit /b 0
:ERRO
echo.
echo Falha na compilacao. Envie a saida completa.
pause
exit /b 1
