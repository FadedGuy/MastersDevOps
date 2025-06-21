<#
.Synopsis
Muestra los discos con espacio libre por debajo del porcentaje del parámetro dado 
.Description
Esta script revisa los discos duros locales y muestra los que tienen un porcentaje de espacio libre menor al parámetro especificado 
.Example
PS .\script3.ps1 15
Mostrara los discos con menos del 15% de espacio libres
.Inputs
Entero que representa el porcentaje de umbral en el rango de 0 a 100
.Outputs
Letra de unidad, espacio libre en GB, tamaño total en GB
.Notes
Autor: Kevin Aceves
Fecha: 2025/06/21
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(0, 100)]
    [int]$porcentaje
)
$discos = Get-WmiObject Win32_LogicalDisk 
foreach ($disco in $discos) {
    if (-not $disco.Size -or $disco.Size -eq 0) {
        continue
    }

    $totalGB = [math]::Floor($disco.Size / 1GB)
    $libreGB = [math]::Floor($disco.FreeSpace / 1GB)
    $librePorcentaje = ($disco.FreeSpace / $disco.Size) * 100

    if ($librePorcentaje -lt $porcentaje) {
        Write-Output "Unidad: $($disco.DeviceID) - Libre: ${libreGB}GB - Tamaño: ${totalGB}GB"
    }
}