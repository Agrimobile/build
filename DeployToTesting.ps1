param(
  [string]$ExtJsSource, # folder origin, de aqui tomamos solo los archivos necesarios
  [string]$TestingWeb # folder destino, aqui se deploya el sitio con los files minimos
  )

if (-not (test-path $ExtJsSource)) {
  "Este directorio no existe: " + $ExtJsSource + ". Configure correctamente Builder. Se aborta el deployment a Testing."
  exit
}

if (-not (test-path $TestingWeb)) {
  "Este directorio no existe: " + $TestingWeb + ". Configure correctamente Builder. Se aborta el deployment a Testing." 
  exit
}

# clear the folder
$clearPattern = $TestingWeb + "\*"
Remove-item $clearPattern -recurse

$cssFolder = $ExtJsSource + "\resources"

if( -not (test-path $cssFolder)) {
  "Este directorio no existe: " + $cssFolder + ". Necesita estos estilos para que la aplicacion se renderice correctamente." 
  exit
}

$cssFiles = Get-childitem $cssFolder

if ($cssFiles.length -le 0) {
  "Este directorio esta vacio: " + $cssFolder + ". Necesita estos estilos para que la aplicacion se renderice correctamente. Se aborta el deployment a Testing."
  exit
}

$pattern = "^preview\-theme\-triton\S*css$"

$cssFiles | foreach-object { 
  if( $_.name -match $pattern) {

    # Copia el archivo Css compilado por el framework

    $cssFolderTarget = $TestingWeb + "\ext_library\resources"
    $newCssFilePath = $cssFolderTarget + "\" + $_.name

    robocopy $cssFolder $cssFolderTarget $_.name
    if(test-path $newCssFilePath) {
      Rename-Item $newCssFilePath "preview-theme-triton.css"
    }
    else {
      "El archivo: " + $_.name + " no se copio correctamente. Chequee el archivo fuente y el proceso de copiado robocopy. Se aborta el deployment a Testing."
      exit
    }
  }
}

$extAllFile = "ext-all-rtl-debug.js"
$extAllSource = $ExtJsSource + "\ext\build"
$extAll = $extAllSource + "\" + $extAllFile

if( -not (test-path $extAll) ) {
  "Este archivo no existe: " + $extAll + ". Necesita un archivo js minificado del framework para trabajar. Se aborta el deployment a Testing." 
  exit
}

# copy ext-all.js en alguna parte (?) de $TestingWeb

$extAllTarget =  $TestingWeb + "\ext_library"

robocopy $extAllSource $extAllTarget $extAllFile

# copy app.js, index-testing.html (cambia nombre a index.html) directamente en $TestingWeb

robocopy $ExtJsSource $TestingWeb "app.js"

robocopy $ExtJsSource $TestingWeb "index-testing.html"

$newIndexFilePath = $TestingWeb +"\index-testing.html"

if(test-path $newIndexFilePath) {
  Rename-Item $newIndexFilePath "index.html"
}

# copy /app directamente en $TestingWeb

$appSource = $ExtJsSource + "\app"
$appTarget = $TestingWeb + "\app"

robocopy $appSource $appTarget /MIR

# copy /LibJS directamente en $TestingWeb

pushd $ExtJsSource
cd ..
$www = get-location
$LibJSSource = $www.path + "\LibJS"
popd

$LibJSTarget = $TestingWeb + "\LibJS"
robocopy $LibJSSource $LibJSTarget *.js