param(
  [string]$TestingWeb, 
  [string]$CordovaProject
)

$cdvWww = $CordovaProject + "\www"

if (-not (test-path $TestingWeb)) {
  "Este directorio no existe: " + $TestingWeb + ". Su build.cmd puede no haber sido configurado correctamente, o el deployment a Testing-Web no se hizo correctamente. Se aborta el deployment de testing-web a Cordova-Project"
  exit
}

if (-not (test-path $cdvWww)) {
  "Este directorio no existe: " + $cdvWww + ". Su build.cmd puede no haber sido configurado correctamente, o el proyecto de Cordova no se creo bien. Se aborta el deployment de testing-web a Cordova-Project"
  exit
}

robocopy $TestingWeb $cdvWww /MIR