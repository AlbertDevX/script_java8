<#
    JDK 8 Professional Installer - Oracle Build 2026
    Soporte oficial para despliegue silencioso (Silent Install)
#>

$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249553_4d245e941845490c91360409ecffb3b4"
$InstallerPath = Join-Path $env:TEMP "JDK8_Setup_x64.exe"

function Show-Header {
    Clear-Host
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "    ORACLE JAVA JDK 8 - OFFICIAL DEPLOYMENT SCRIPT           " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
}

function Set-JavaPath {
    Write-Host " [OK] Localizando binarios de Java..." -ForegroundColor Cyan
    $jdk = Get-ChildItem "C:\Program Files\Java\jdk1.8*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($jdk) {
        $path = $jdk.FullName
        $bin = Join-Path $path "bin"
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $path, "Machine")
        $p = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($p -notlike "*$bin*") {
            [Environment]::SetEnvironmentVariable("Path", "$bin;$p", "Machine")
        }
        Write-Host " [V] Variable JAVA_HOME y Path actualizadas." -ForegroundColor Green
    }
}

function Main {
    Show-Header
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host " [X] ERROR: Ejecuta como Administrador." -ForegroundColor Red; return
    }

    Write-Host " [>] Iniciando descarga segura desde Oracle..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $headers = @{
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
            "Cookie"     = "oraclelicense=accept-securebackup-cookie"
        }
        Invoke-WebRequest -Uri $JDK8_Url -OutFile $InstallerPath -Headers $headers -UseBasicParsing
        Write-Host " [V] Paquete descargado con exito." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error 403/Forbidden: Revisa el token de descarga de Oracle." -ForegroundColor Red; return
    }

    Write-Host " [>] Ejecutando Instalador (Modo Silencioso)..." -ForegroundColor Cyan
    try {
        $proc = Start-Process -FilePath $InstallerPath -ArgumentList "/s", "SPONSORS=0" -Wait -PassThru
        if ($proc.ExitCode -eq 0) {
            Write-Host " [V] Instalacion finalizada." -ForegroundColor Green
            Set-JavaPath
        }
    } catch {
        Write-Host " [X] Error en instalacion: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
    }

    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host " CONFIGURACION COMPLETA - REINICIA TU TERMINAL" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
}

Main
