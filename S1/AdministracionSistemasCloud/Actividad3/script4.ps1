<#
.Synopsis
Muestra un menú con opciones para ejecutar tareas comunes del sistema
.Description
Este script presenta un menú interactivo al usuario. Según la opción ejecutara servicios activos, fecha del sistema, abrir bloc de notas o abrir la calculadora
.Notes
Autor: Kevin Aceves
Fecha: 2025/06/21
#>
do {
    Clear-Host
    Write-Host "===== MENU ====="
    Write-Host "1. Listar los servicios arrancados."
    Write-Host "2. Mostrar la fecha del sistema."
    Write-Host "3. Ejecutar el Bloc de notas"
    Write-Host "4. Ejecutar la Calculadora."
    Write-Host "5. Salir"
    Write-Host "================"

    $opcion = Read-Host "Introduce una opción (1-5)"
    switch ($opcion) {
        "1" {
            Get-Service | Where-Object { $_.Status -eq 'Running' -or $_.Status -eq 'StartPending' } 
            Pause
        }
        "2" { 
            Write-Host "Fecha y hora actual del sistema: $(Get-Date)"
            Pause
        }
        "3" { 
            Write-Host "Abriendo Bloc de notas"
            Start-Process notepad
            Pause
        }
        "4" { 
            Write-Host "Abriendo Calculadora"
            Start-Process calc
            Pause
        }
        "5" { 
            Write-Host "Saliendo del programa..."
        }
        Default {
            Write-Warning "Opción no válida. Por favor elige una opción válida."
            Pause
        }
    }
} while ($opcion -ne "5")