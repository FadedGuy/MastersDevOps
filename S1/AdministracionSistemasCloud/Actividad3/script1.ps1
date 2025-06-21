<#
.Synopsis
Muestra los ficheros del directorio actual con más de 1024 bytes
.Description
Esta script muestra los ficheros del directorio actual cuyo tamaño es mayor a 1024 bytes
.Example
PS .\script1.ps1
.Inputs
Sin datos de entrada
.Outputs
Muestra los ficheros del directorio actual que cumplan la condición
.Notes
Autor: Kevin Aceves
Fecha: 2025/06/21
#>
Get-ChildItem -File | Where-Object { $_.Length -gt 1024 } 