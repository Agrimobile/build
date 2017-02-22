@echo off
cls

ECHO.
ECHO.
ECHO                 AGROMOBILE BUILDER
ECHO ********************************************************
ECHO ********************************************************

goto check_Permissions

:check_Permissions
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Nivel de permiso de admin confirmado.
    ) else (
    	echo.
        echo Error: Necesita que la consola este levantada como admin para seguir.
        echo Abra Inicio de Windows, busque Cmd y haga clic derecho, luego seleccione Ejecutar Como Administrador, y finalmente navegue hasta la carpeta de build.cmd e intentelo nuevamente.
        goto :endNoAdmin
    )

set isWeb=%1

powershell Set-ExecutionPolicy unrestricted

SET ExtJsSource=C:\wamp64\www\AgriManager
SET TestingWeb=C:\wamp64\www\agromobile-testing
SET CordovaProject=C:\agromobile
SET Platform=android

ECHO.
ECHO SenchaCmd Build
ECHO ************************************************************
pushd %ExtJsSource%
sencha app build
popd

ECHO.
ECHO Paso 1 - Deployment de Development(webapp) a TestingWeb(webapp)
ECHO ************************************************************

powershell .\DeployToTesting.ps1 %ExtJsSource% %TestingWeb%

if "%isWeb%"=="web" goto :end

ECHO.
ECHO Paso 2 - TODO: Deployment de Testing(webapp) a ProyectoCordova(www - webapp)
ECHO ************************************************************ 

powershell .\TestingToCordovaProject.ps1 %TestingWeb% %CordovaProject%

ECHO.
ECHO Paso 3 - TODO: Building del ProyectoCordova(www - webapp) a TestingApp(Native-android)
ECHO ************************************************************ 

powershell .\run.ps1 %CordovaProject% %Platform%

:end

powershell Set-ExecutionPolicy restricted

:endNoAdmin
ECHO.
ECHO FIN AGROMOBILE BUILDER
ECHO ************************************************************