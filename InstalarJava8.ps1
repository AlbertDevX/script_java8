<#
    Instalador Automático de Java 8 JDK (64-bit)
    Versión: 2.0 (UTF-8 Optimized)
#>

$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248242_ce59cff5c23f4e2eaf4e778a117d4c5b"
$InstallerPath = Join-Path $env:TEMP "JDK8_Setup_x64.exe"

function Show-Welcome {
    Clear-Host
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "    JAVA JDK 8 - AUTO-INSTALLER                 " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
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
        Write-Host " [V] JAVA_HOME configurado en: $fullPath" -ForegroundColor Green
    }
}

function Start-Installation {
    Show-Welcome
    if (-not (Test-Admin)) {
        Write-Host " [!] ERROR: Ejecuta como ADMINISTRADOR." -ForegroundColor Red
        return
    }

    Write-Host " [>] Descargando JDK 8... (Simulando Navegador)" -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0")
        $wc.Headers.Add("Cookie", "oraclelicense=accept-securebackup-cookie")
        $wc.DownloadFile($JDK8_Url, $InstallerPath)
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
    Write-Host " PROCESO FINALIZADO" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Read-Host " Presiona Enter para salir"
}

Start-Installation
