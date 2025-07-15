
# INSTALAR

```winget install Microsoft.Powershell```

```Install-Module -Name WinTuner```

```Import-Module -Name WinTuner```

# WINGET PACKAGES

```https://github.com/microsoft/winget-pkgs/tree/master/manifests```

# COMANDOS

**Conectar al tennant**

```Connect-WtWinTuner -Username <String>```

**Buscar el paquete**

```Search-WtWinGetPackage -SearchQuery <String>```

**Obtener archivo intunewin**

```New-WtWingetPackage -PackageId <String> -PackageFolder <String> [-Version <String>]```

**Desplegar aplicacion en Intune (-RootPackageFolder es la carpeta que contiene el paquete descargado desde New-WtWingetPackage)**

```Deploy-WtWin32App -PackageId <String> -Version <String> -RootPackageFolder <String>```

# Website

```https://wintuner.app/```