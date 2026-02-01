# 🚀 Java 8 Auto-Installer Pro
### *Configuración automatizada de alto rendimiento para Windows 11*

<div align="center">

![Java](https://img.shields.io/badge/Java-8-007396?style=for-the-badge&logo=java&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Maintenance](https://img.shields.io/badge/Mantenimiento-Activo-brightgreen?style=for-the-badge)

**Optimiza tu flujo de trabajo eliminando la configuración manual del entorno Java.**

[Manual de Uso](#-guía-de-inicio-rápido) • [Prerrequisitos](#-prerrequisitos-del-sistema) • [Soporte](#-solución-de-problemas)

</div>

---

## 💎 Sobre el Proyecto

Este script de **PowerShell** es una herramienta profesional diseñada para desarrolladores y administradores de sistemas. Automatiza el ciclo completo de vida de la instalación de **Java 8 (64-bit)**, garantizando consistencia en cada despliegue.

### ✨ Características Principales
* 🛠️ **Full Automation:** Descarga silenciosa desde repositorios oficiales.
* 🌐 **Smart Pathing:** Inyección automática en las Variables de Entorno globales.
* 🛡️ **Zero Waste:** Limpieza profunda de instaladores residuales tras el éxito.
* 🔍 **System Audit:** Verificación de arquitectura y permisos antes de iniciar.

---

## ⚙️ Prerrequisitos del Sistema

| Requisito | Especificación Mínima |
| :--- | :--- |
| **Arquitectura** | x64 (64-bit) |
| **OS** | Windows 11 / Windows 10 |
| **Shell** | PowerShell 5.1 o superior |
| **Privilegios** | Nivel de Administrador |

---

## 🚀 Guía de Inicio Rápido

Sigue estos tres pasos para transformar tu entorno en segundos:

### 1. Preparación
Crea el archivo `InstalarJava8.ps1` en tu directorio de preferencia con el código fuente proporcionado.

### 2. Autorización
Abre la **Terminal de Windows (Admin)** y otorga permisos temporales de ejecución:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
