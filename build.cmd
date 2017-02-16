@echo off
cls

powershell Set-ExecutionPolicy unrestricted

SET ExtJsSource=C:\wamp64\www\AgriManager
SET TestingWeb=C:\wamp64\www\agromobile-testing
SET CordovaProject=C:\agromobile
SET Platform=android

ECHO.
ECHO.
ECHO                 AGROMOBILE BUILDER
ECHO ********************************************************
ECHO ********************************************************

ECHO.
ECHO Paso 1 - Deployment de Development(webapp) a TestingWeb(webapp)
ECHO ************************************************************

powershell .\DeployToTesting.ps1 %ExtJsSource% %TestingWeb%

ECHO.
ECHO Paso 2 - TODO: Deployment de Testing(webapp) a ProyectoCordova(www - webapp)
ECHO ************************************************************ (Process Empty)

powershell .\TestingToCordovaProject.ps1 %TestingWeb% %CordovaProject%

ECHO.
ECHO Paso 3 - TODO: Building del ProyectoCordova(www - webapp) a TestingApp(Native-android)
ECHO ************************************************************ (Process Empty)

powershell .\run.ps1 %CordovaProject% %Platform%

powershell Set-ExecutionPolicy restricted

ECHO.
ECHO FIN AGROMOBILE BUILDER
ECHO ************************************************************