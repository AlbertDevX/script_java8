<#
    JDK 8 Professional Installer - Eclipse Temurin (Adoptium)
    Versión: 2.6 - Fix Error 1620
#>

$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jdk_x64_windows_hotspot_8u402b06.msi"
$InstallerPath = Join-Path $env:TEMP "Temurin8_Setup.msi"

function Show-Header {
    Clear-Host
    Write-Host "  _____________________________________________________________  " -ForegroundColor Cyan
    Write-Host " |                                                             | " -ForegroundColor Cyan
    Write-Host " |       JAVA JDK 8 - ADOPTIUM TEMURIN INSTALLER               | " -ForegroundColor Cyan
    Write-Host " |       AlbertDevX Open-Source Deployment                     | " -ForegroundColor Cyan
    Write-Host " |_____________________________________________________________| " -ForegroundColor Cyan
    Write-Host ""
}

function Set-JavaPath {
    Write-Host " [⚙] Configurando variables de entorno..." -ForegroundColor Cyan
    $jdkFolder = Get-ChildItem "C:\Program Files\Eclipse Adoptium\jdk-8*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($jdkFolder) {
        $fullPath = $jdkFolder.FullName
        $binPath = Join-Path $fullPath "bin"
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $fullPath, "Machine")
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        if ($currentPath -notlike "*$binPath*") {
            [Environment]::SetEnvironmentVariable("Path", "$binPath;$currentPath", "Machine")
        }
        Write-Host " [✓] Entorno configurado: $fullPath" -ForegroundColor Green
    }
}

function Main {
    Show-Header
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host " [X] ERROR: Debes ejecutar como ADMINISTRADOR." -ForegroundColor Red; return
    }

    Write-Host " [↓] Descargando JDK 8 (Temurin)..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $JDK8_Url -OutFile $InstallerPath -UserAgent "Mozilla/5.0"
        
        if (!(Test-Path $InstallerPath)) { throw "El archivo no se guardo correctamente." }
        Write-Host " [✓] Descarga completada." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error en descarga: $($_.Exception.Message)" -ForegroundColor Red; return
    }

    Write-Host " [⚙] Iniciando instalacion desatendida (MSI)..." -ForegroundColor Cyan
    try {
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", "`"$InstallerPath`"", "/qn", "ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome" -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host " [✓] JDK 8 instalado correctamente." -ForegroundColor Green
            Set-JavaPath
        } else {
            Write-Host " [X] Error del instalador: $($process.ExitCode). Reintenta manualmente." -ForegroundColor Red
        }
    } catch {
        Write-Host " [X] Error: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
    }

    Write-Host "`n=============================================================" -ForegroundColor Cyan
    Write-Host " PROCESO FINALIZADO" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Read-Host " Presiona Enter para finalizar"
}

Main
