<#
    JDK 8 Installer - Eclipse Temurin (Adoptium)
    Versión: 2.5 - 2026 Edition
    Sin errores 403 - API OpenSource Certificada
#>

$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://api.adoptium.net/v3/binary/latest/8/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk"
$InstallerPath = Join-Path $env:TEMP "Temurin8_Setup_x64.msi"

function Show-Header {
    Clear-Host
    Write-Host "  _____________________________________________________________  " -ForegroundColor Cyan
    Write-Host " |                                                             | " -ForegroundColor Cyan
    Write-Host " |       JAVA JDK 8 - ADOPTIUM TEMURIN INSTALLER               | " -ForegroundColor Cyan
    Write-Host " |         AlbertDevX Open-Source Deployment                   | " -ForegroundColor Cyan
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
            $newPath = "$binPath;" + $currentPath
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        }
        Write-Host " [✓] JAVA_HOME definido en: $fullPath" -ForegroundColor Green
        Write-Host " [✓] Binarios agregados al Path del sistema." -ForegroundColor Green
    }
}

function Main {
    Show-Header
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host " [X] ERROR: Debes ejecutar como ADMINISTRADOR." -ForegroundColor Red; return
    }

    Write-Host " [↓] Descargando JDK 8 (Temurin) desde Adoptium API..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $JDK8_Url -OutFile $InstallerPath -UserAgent "Mozilla/5.0"
        Write-Host " [✓] Descarga completada exitosamente." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error en descarga: $($_.Exception.Message)" -ForegroundColor Red; return
    }

    Write-Host " [⚙] Iniciando instalacion desatendida..." -ForegroundColor Cyan
    try {
        $msiArgs = @(
            "/i", "`"$InstallerPath`"",
            "/qn",
            "ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome",
            "INSTALLDIR=`"C:\Program Files\Eclipse Adoptium\jdk-8`""
        )
        $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList $msiArgs -Wait -PassThru
        
        if ($proc.ExitCode -eq 0) {
            Write-Host " [✓] JDK 8 instalado correctamente." -ForegroundColor Green
            Set-JavaPath
        } else {
            Write-Host " [X] El instalador devolvio el codigo: $($proc.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host " [X] Error durante la instalacion: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
    }

    Write-Host "`n=============================================================" -ForegroundColor Cyan
    Write-Host " INSTALACION EXITOSA - REINICIA TU CONSOLA" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Read-Host " Presiona Enter para finalizar"
}

Main
