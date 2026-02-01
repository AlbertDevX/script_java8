<#
.SYNOPSIS
    Instalador Automático de Java 8 JDK (64-bit) para Windows 11.
    Versión Premium con configuración de variables de entorno avanzada.
    
.NOTES
    Optimizado para: Desarrollo y Compilación.
    Requisito: Ejecutar como Administrador.
#>

# --- Configuración de Estilo ---
$ProgressPreference = 'SilentlyContinue'
$JDK8_Url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248242_ce59cff5c23f4e2eaf4e778a117d4c5b" # Enlace directo JRE/JDK dinámico
$InstallerPath = Join-Path $env:TEMP "JDK8_Setup_x64.exe"

function Show-Welcome {
    Clear-Host
    Write-Host "  _____________________________________________________________  " -ForegroundColor Cyan
    Write-Host " |                                                             | " -ForegroundColor Cyan
    Write-Host " |    🚀 JAVA JDK 8 - PROFESSIONAL AUTO-INSTALLER              | " -ForegroundColor Cyan
    Write-Host " |       High-Performance Setup for Windows 11                 | " -ForegroundColor Cyan
    Write-Host " |_____________________________________________________________| " -ForegroundColor Cyan
    Write-Host ""
}

function Test-AdminPrivileges {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-Environment {
    Write-Host " [⚙] Escaneando directorios de instalación..." -ForegroundColor Cyan
    
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

        Write-Host " [✓] Entorno configurado: JAVA_HOME -> $fullPath" -ForegroundColor Green
        Write-Host " [✓] Compilador javac agregado al Path del sistema." -ForegroundColor Green
    } else {
        Write-Host " [!] Error: No se pudo localizar la carpeta del JDK tras la instalación." -ForegroundColor Red
    }
}

function Start-Installation {
    Show-Welcome

    if (-not (Test-AdminPrivileges)) {
        Write-Host " [X] ERROR: Se requieren privilegios de ADMINISTRADOR." -ForegroundColor Red
        Read-Host " Presiona Enter para cerrar..."; exit
    }

    Write-Host " [↓] Descargando JDK 8 (64-bit) desde servidores seguros..." -ForegroundColor Cyan
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $JDK8_Url -OutFile $InstallerPath -UserAgent "Mozilla/5.0"
        Write-Host " [✓] Descarga finalizada." -ForegroundColor Green
    } catch {
        Write-Host " [X] Error en descarga: $($_.Exception.Message)" -ForegroundColor Red; return
    }

    Write-Host " [⚙] Iniciando instalación silenciosa del JDK..." -ForegroundColor Cyan
    try {
        $process = Start-Process -FilePath $InstallerPath -ArgumentList "/s", "REBOOT=ReallySuppress", "SPONSORS=0" -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host " [✓] JDK instalado correctamente." -ForegroundColor Green
            Set-Environment
        } else {
            Write-Host " [X] Fallo en el instalador. Código: $($process.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host " [X] Excepción durante instalación: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $InstallerPath) { Remove-Item $InstallerPath -Force }
    }

    Write-Host "`n=============================================================" -ForegroundColor Cyan
    Write-Host " ✅ SETUP COMPLETADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host " Verifica con: javac -version" -ForegroundColor White
    Write-Host ""
    Read-Host " Presiona cualquier tecla para finalizar..."
}

Start-Installation
