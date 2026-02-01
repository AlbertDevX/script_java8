<#
    JDK 8 Installer - Amazon Corretto Edition
    Fuente: Amazon Services
    Optimizado para: Windows 11 / 2026
#>

$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://corretto.aws/downloads/latest/amazon-corretto-8-x64-windows-jdk.msi"
$InstallerPath = Join-Path $env:TEMP "Corretto8_Setup_x64.msi"

function Show-Header {
    Clear-Host
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "    JAVA JDK 8 - AMAZON CORRETTO AUTO-INSTALLER              " -ForegroundColor Cyan
    Write-Host "    Official OpenJDK Distribution - Secure & Stable          " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
}

function Set-JavaPath {
    Write-Host " [OK] Verificando variables de entorno..." -ForegroundColor Cyan
    $jdk = Get-ChildItem "C:\Program Files\Amazon Corretto\jdk1.8*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($jdk) {
        $path = $jdk.FullName
        $bin = Join-Path $path "bin"
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $path, "Machine")
        $p = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($p -notlike "*$bin*") {
            [Environment]::SetEnvironmentVariable("Path", "$bin;$p", "Machine")
        }
        Write-Host " [V] JAVA_HOME definido en: $path" -ForegroundColor Green
    }
}

function Main {
    Show-Header
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host " [X] ERROR: Ejecuta como Administrador." -ForegroundColor Red; return
    }

    Write-Host " [>] Descargando Amazon Corretto 8 (OpenJDK)..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $JDK8_Url -OutFile $InstallerPath -UserAgent "Mozilla/5.0"
        Write-Host " [V] Descarga completada desde AWS." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error en descarga: $($_.Exception.Message)" -ForegroundColor Red; return
    }

    Write-Host " [>] Instalando JDK de forma silenciosa..." -ForegroundColor Cyan
    try {
        # Instalación MSI desatendida
        $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", "`"$InstallerPath`"", "/qn", "ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome" -Wait -PassThru
        if ($proc.ExitCode -eq 0) {
            Write-Host " [V] Amazon Corretto instalado exitosamente." -ForegroundColor Green
            Set-JavaPath
        }
    } catch {
        Write-Host " [X] Error en instalacion: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
    }

    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host " PROCESO COMPLETADO - REINICIA TU TERMINAL" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
}

Main
