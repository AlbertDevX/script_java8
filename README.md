# 👑 Java 8 JDK Elite Installer (64-bit)

<div align="center">

![JDK](https://img.shields.io/badge/Java_JDK-8-007396?style=for-the-badge&logo=java&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Automation](https://img.shields.io/badge/Status-Automated-orange?style=for-the-badge)

**Despliegue profesional y automático del Entorno de Desarrollo Java (JDK) para Windows 11.**

[Documentación](#-tabla-de-contenidos) • [Guía de Inicio](#-guía-de-instalación-rápida) • [Verificación](#-verificación-final)

</div>

---

## 📋 Tabla de Contenidos

* [🎯 Propósito del Proyecto](#-propósito-del-proyecto)
* [⚙️ Componentes del Sistema](#️-componentes-del-sistema)
* [🚀 Guía de Instalación Rápida](#-guía-de-instalación-rápida)
* [✅ Verificación Final](#-verificación-final)
* [🛠️ Solución de Problemas](#️-solución-de-problemas)
* [📄 Licencia](#-licencia)

---

## 🎯 Propósito del Proyecto

Este ecosistema de scripts elimina la complejidad de configurar el **JDK 8**. A diferencia de una instalación estándar, este proceso:
1.  **Descarga el JDK:** No solo el runtime (JRE), permitiéndote compilar con `javac`.
2.  **Inyecta Variables:** Configura `JAVA_HOME` y el `Path` a nivel de máquina automáticamente.
3.  **Lanzamiento Simple:** Incluye un archivo `.bat` para ejecutar todo con un doble clic.

---

## ⚙️ Componentes del Sistema

| Archivo | Lenguaje | Función |
| :--- | :--- | :--- |
| `InstalarJava8.ps1` | **PowerShell** | Motor principal de descarga e instalación. |
| `LANZADOR.bat` | **Batch** | Ejecutor automático con permisos de administrador. |
| `README.md` | **Markdown** | Documentación y guía visual del proyecto. |

---

## 🚀 Guía de Instalación Rápida

### 1. Preparación de archivos
Asegúrate de tener los tres archivos en la misma carpeta:
* `InstalarJava8.ps1`

### 2. Ejecución de un solo paso
No necesitas abrir la terminal manualmente. 
> **Simplemente haz doble clic sobre el archivo `LANZADOR.bat`.**

El sistema te pedirá confirmación de administrador y comenzará la descarga automática.

---

## ✅ Verificación Final

Para asegurar que el compilador y el entorno están listos, abre una **nueva** terminal y ejecuta:

| Prueba | Comando | Salida Exitosa |
| :--- | :--- | :--- |
| **Compilador** | `javac -version` | `javac 1.8.0_401` |
| **Entorno** | `java -version` | `java version "1.8.0_401"` |
| **Variable Home** | `echo %JAVA_HOME%` | `C:\Program Files\Java\jdk1.8.x_xxx` |

---

## 🛠️ Solución de Problemas

> [!IMPORTANT]
> **Reinicio de Terminal:** Si los comandos `java` o `javac` no funcionan tras la instalación, **cierra y vuelve a abrir tu terminal**. Windows necesita refrescar las variables de entorno cargadas.

* **Error de Red:** Asegúrate de no tener un Firewall bloqueando a PowerShell.
* **Permisos:** Si el lanzador falla, intenta ejecutar PowerShell manualmente como Administrador y lanza el `.ps1`.

---

## 📄 Licencia

Este proyecto está bajo la **Licencia MIT**. Siéntete libre de clonarlo y mejorarlo.

---

<div align="center">
  <sub>Optimizado para desarrolladores por Gemini 3 Flash • 2026</sub>
</div>

---

# Comando para iniciar el script

Si prefieres no descargar archivos manualmente, puedes ejecutar la instalación completa directamente desde la nube. Copia y pega el siguiente comando en tu **PowerShell (Administrador)**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('[https://raw.githubusercontent.com/AlbertDevX/script_java8/main/InstalarJava8.ps1](https://raw.githubusercontent.com/AlbertDevX/script_java8/main/InstalarJava8.ps1)'))
