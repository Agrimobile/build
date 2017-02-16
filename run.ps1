param(
  [string]$CordovaProject, 
  [string]$platform
)

$cdvWww = $CordovaProject + "\www"

if (-not (test-path $cdvWww)) {
  "Este directorio no existe: " + $cdvWww + ". Su build.cmd puede no haber sido configurado correctamente, o el proyecto de Cordova no se creo bien. Se aborta el buildeo y ejecucion a la app-nativa."
  exit
}

if ($platform) {
  $platform = "android"
}

pushd $cdvWww

cordova run $platform

popd