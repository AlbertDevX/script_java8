# 🚀 Java 8 Auto-Installer (64-bit) for Windows 11

![Java](https://img.shields.io/badge/Java-8-007396?style=for-the-badge&logo=java&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/Licencia-MIT-green?style=for-the-badge)

Script de PowerShell que automatiza la descarga e instalación completa de Java 8 en Windows 11.

---

## 📋 Tabla de Contenidos

* [Descripción](#descripción)
* [Características](#características)
* [Prerrequisitos](#prerrequisitos)
* [Instalación](#instalación)
* [Verificación](#verificación)
* [Solución de Problemas](#solución-de-problemas)

---

## 🎯 Descripción

Este script automatiza la instalación silenciosa de Java 8 (64-bit). Está diseñado para configurar el entorno de desarrollo en segundos, manejando la descarga oficial y las variables del sistema de forma automática.

## ✨ Características

* ✅ **Automatizado:** Descarga directa e instalación sin intervención.
* ✅ **Configuración:** Setea `JAVA_HOME` y actualiza el `Path` automáticamente.
* ✅ **Seguro:** Limpia archivos temporales tras la instalación.
* ✅ **Inteligente:** Detecta versiones previas instaladas.

## ⚙️ Prerrequisitos

* Windows 11 (64-bit).
* PowerShell 5.1 o superior.
* Ejecución con permisos de **Administrador**.
* Conexión a Internet activa.

---

## 📥 Instalación

1. **Guardar el archivo:** Crea un archivo llamado `InstalarJava8.ps1`.
2. **Abrir Terminal:** Ejecuta PowerShell como Administrador.
3. **Ejecutar comandos:**

```powershell
# Acceder a la ruta del archivo
cd "C:\ruta\de\tu\script"

# Habilitar permisos
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Correr instalador
.\InstalarJava8.ps1
