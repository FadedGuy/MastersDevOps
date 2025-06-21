<#
.Synopsis
Renombra los ficheros del directorio con extensión JPG
.Description
Esta script renombra los ficheros con extensión JPG, agregando un prefijo con el formato año, mes, día.
.Example
PS .\script2.ps1
imagen1.jpg -> 20250621-image1.jpg
.Inputs
Sin datos de entrada
.Outputs
Los ficheros del directorio actual que cumplan la condición seran renombrados
.Notes
Autor: Kevin Aceves
Fecha: 2025/06/21
#>
$fecha = Get-Date -Format "yyyyMMdd"
$archivos = Get-ChildItem -File -Filter *.jpg

foreach ($archivo in $archivos) {
    $nuevoNombre = "$fecha-$($archivo.Name)"
    
    if ($($archivo.Name.StartsWith($fecha))) {
        Write-Output "El archivo $($archivo.Name) ya ha sido procesado"
    }
    elseif (Test-Path -Path $nuevoNombre) {
        Write-Warning "Conflicto: ya existe '$nuevoNombre'. '$($archivo.Name)' no será renombrado."
    }
    else {
        Rename-Item -Path $archivo.FullName -NewName $nuevoNombre
        Write-Output "$($archivo.Name) -> $($nuevoNombre)"
    }
}