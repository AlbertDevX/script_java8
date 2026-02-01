<#
.SYNOPSIS
    JAVA JDK 8 PROFESSIONAL AUTO-INSTALLER (x64)
    Optimizado para Windows 11 - Edición 2026
    Desarrollado por: AlbertDevX
#>

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

$Sources = @{
    "1" = @{
        Name = "Eclipse Temurin (Adoptium)"
        Url  = "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jdk_x64_windows_hotspot_8u402b06.msi"
        Type = "MSI"
    }
    "2" = @{
        Name = "Amazon Corretto"
        Url  = "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-windows-jdk.msi"
        Type = "MSI"
    }
}

function Show-AestheticHeader {
    Clear-Host
    $Cyan = "Cyan"; $White = "White"; $Green = "Green"
    Write-Host "  _____________________________________________________________  " -ForegroundColor $Cyan
    Write-Host " |                                                             | " -ForegroundColor $Cyan
    Write-Host " |        ADXTOOLS | TOOL FOR INSTALL JAVA JDK 8                | " -ForegroundColor $Cyan
    Write-Host " |         AlbertDevX Open-Source Script Code                  | " -ForegroundColor $Cyan
    Write-Host " |_____________________________________________________________| " -ForegroundColor $Cyan
    Write-Host ""
}

function Get-AdminCheck {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-EnvironmentVariables {
    param([string]$installPath)
    Write-Host " [⚙] Configurando variables de entorno del sistema..." -ForegroundColor Cyan
    
    try {
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $installPath, "Machine")
        $binPath = Join-Path $installPath "bin"
        $oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        
        if ($oldPath -notlike "*$binPath*") {
            $newPath = "$binPath;$oldPath"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        }
        Write-Host " [✓] Entorno configurado: JAVA_HOME -> $installPath" -ForegroundColor Green
    } catch {
        Write-Host " [X] Error al configurar variables: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Start-Deployment {
    Show-AestheticHeader
    
    if (-not (Get-AdminCheck)) {
        Write-Host " [!] ERROR CRITICO: Se requieren privilegios de ADMINISTRADOR." -ForegroundColor Red
        Write-Host " Por favor, reinicia la terminal como Administrador."
        return
    }

    Write-Host " Selecciona la distribucion de JDK 8 (64-bit) que deseas instalar:" -ForegroundColor White
    Write-Host " 1. Eclipse Temurin (Adoptium) - Recomendado" -ForegroundColor Cyan
    Write-Host " 2. Amazon Corretto - Alto Rendimiento AWS" -ForegroundColor Cyan
    Write-Host ""
    $choice = Read-Host " Elige una opcion [1-2]"
    
    if (-not $Sources.ContainsKey($choice)) {
        Write-Host " [!] Opcion no valida. Abortando..." -ForegroundColor Red
        return
    }

    $selected = $Sources[$choice]
    $tempFile = Join-Path $env:TEMP "Java8_Installer.msi"

    Write-Host "`n [↓] Descargando $($selected.Name)..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($selected.Url, $tempFile)
        
        if ((Get-Item $tempFile).Length -lt 1MB) { throw "El archivo descargado esta corrupto." }
        Write-Host " [✓] Descarga verificada con exito." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error en la descarga: $($_.Exception.Message)" -ForegroundColor Red
        return
    }

    Write-Host " [⚙] Iniciando instalacion silenciosa (No cerrar ventana)..." -ForegroundColor Cyan
    try {
        $msiArgs = "/i `"$tempFile`" /qn ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome"
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $msiArgs -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host " [✓] $($selected.Name) instalado correctamente." -ForegroundColor Green
            
            $searchPath = if($choice -eq "1") { "C:\Program Files\Eclipse Adoptium\jdk-8*" } else { "C:\Program Files\Amazon Corretto\jdk1.8*" }
            $jdkDir = Get-ChildItem $searchPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            
            if ($jdkDir) { Set-EnvironmentVariables -installPath $jdkDir.FullName }
        } else {
            Write-Host " [X] Error MSI: El instalador devolvio el codigo $($process.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host " [X] Excepcion durante la instalacion: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
    }

    Write-Host "`n=============================================================" -ForegroundColor Cyan
    Write-Host "   PROCESO FINALIZADO CON EXITO" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Read-Host " Presiona Enter para salir"
}

# Ejecutar Main
Start-Deployment
