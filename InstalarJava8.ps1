<#
.SYNOPSIS
    Instalador Automático de Java 8 JDK (64-bit) para Windows 11.
    Versión compatible con Bypass de Seguridad Oracle 2026.
#>

$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248242_ce59cff5c23f4e2eaf4e778a117d4c5b"
$InstallerPath = Join-Path $env:TEMP "JDK8_Setup_x64.exe"

function Show-Welcome {
    Clear-Host
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "    JAVA JDK 8 - PROFESSIONAL AUTO-INSTALLER                 " -ForegroundColor Cyan
    Write-Host "       Compatible con Windows 11 - Build 2026                " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-Environment {
    Write-Host " [OK] Configurando variables de entorno..." -ForegroundColor Cyan
    $jdkPath = Get-ChildItem "C:\Program Files\Java\jdk1.8*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($jdkPath) {
        $fullPath = $jdkPath.FullName
        $binPath = Join-Path $fullPath "bin"
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $fullPath, "Machine")
        $oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($oldPath -notlike "*$binPath*") {
            $newPath = "$binPath;" + $oldPath
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        }
        Write-Host " [V] Entorno configurado: JAVA_HOME -> $fullPath" -ForegroundColor Green
    }
}

function Start-Installation {
    Show-Welcome
    if (-not (Test-Admin)) {
        Write-Host " [!] ERROR: Ejecuta como ADMINISTRADOR." -ForegroundColor Red
        return
    }

    Write-Host " [>] Descargando JDK 8... (Esto puede tardar)" -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        $webClient.Headers.Add("Cookie", "oraclelicense=accept-securebackup-cookie")
        $webClient.DownloadFile($JDK8_Url, $InstallerPath)
        
        Write-Host " [V] Descarga exitosa." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error en descarga: $($_.Exception.Message)" -ForegroundColor Red
        return
    }

    Write-Host " [>] Instalando silenciosamente..." -ForegroundColor Cyan
    try {
        $process = Start-Process -FilePath $InstallerPath -ArgumentList "/s", "SPONSORS=0" -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Host " [V] Instalacion terminada." -ForegroundColor Green
            Set-Environment
        }
    } catch {
        Write-Host " [X] Error: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
    }

    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host " PROCESO FINALIZADO - REINICIA TU TERMINAL" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Read-Host " Presiona Enter para salir"
}

Start-Installation
