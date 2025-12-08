
function Write-Log {                          # Declara una función llamada Write-Log
    [CmdletBinding()]                         # Función avanzada (estilo cmdlet)
    param(
        # --- Conjunto de parámetros: que funciona para crear archivos
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [Alias('Names')]                      # Permite usar -Names como alias de -Name
        [object]$Name,                        # Puede ser string ÚNICO o ARREGLO de strings (p.ej. "App" o "App","Svc")

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext,                         # Extensión del archivo SIN punto (ej: "log", "txt")

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder,                      # Nombre/relativo de carpeta (ej: "logs")

        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create,                      # Conmutador (switch) que marca este set; funciona como "indicador" para seleccionar el set

        # --- Conjunto de parámetros: "Message" (para escribir mensajes) ---
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message,                     # Contenido del mensaje a registrar

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path,                        # Ruta COMPLETA del archivo donde se agrega el mensaje

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',    # Severidad: valida que solo sea Info/Warning/Error; por defecto "Information"

        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG                          # Conmutador para seleccionar el set "Message"
    )

    # Cambia el comportamiento según el "parameter set" que se usó al invocar la función
    switch ($PsCmdlet.ParameterSetName) {
        "Create" {                            # Rama: crear archivos de log
            $created = @()                    # Arreglo para acumular rutas de archivos creados

            # Normaliza $Name a un arreglo (si viene un string, lo convierte en array con un elemento)
            $namesArray = @()
            if ($null -ne $Name) {
                if ($Name -is [System.Array]) { $namesArray = $Name }  # Si ya es array, se usa tal cual
                else { $namesArray = @($Name) }                        # Si no, envuélvelo en array
            }

            # Fecha y hora con formato seguro para nombres de archivo (sin ":" ni "/" problemáticos)
            $date1 = (Get-Date -Format "yyyy-MM-dd")   # Ej: 2025-12-08
            $time  = (Get-Date -Format "HH-mm-ss")     # Ej: 07-41-15

            # Asegura la carpeta y obtiene la ruta absoluta (usa la función anterior)
            $folderPath = New-FolderCreation -foldername $folder

            foreach ($n in $namesArray) {              # Itera por cada nombre base
                # Sanitiza a string explícito
                $baseName = [string]$n

                # Construye el nombre del archivo: Base_YYYY-MM-DD_HH-mm-ss.ext
                $fileName = "${baseName}_${date1}_${time}.$Ext"

                # Ruta completa del archivo dentro de la carpeta
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName

                # Crea el archivo. -Force sobrescribe si existe. -ErrorAction Stop para capturar errores en try/catch
                try {
                    # Si NO quieres sobrescribir, podrías chequear primero:
                    # if (-not (Test-Path $fullPath)) { New-Item ... }
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null

                    # Ejemplo opcional: escribir cabecera (comentado)
                    # "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append

                    $created += $fullPath             # Agrega la ruta creada al arreglo de resultados
                }
                catch {
                    Write-Warning "Failed to create file '$fullPath' - $_"  # Muestra advertencia si falla la creación
                }
            }

            return $created                           # Devuelve todas las rutas creadas
        }

        "Message" {                                   # Rama: escribir un mensaje en un archivo existente/ruta dada
            # Asegura que exista el directorio padre del archivo indicado en -path
            $parent = Split-Path -Path $path -Parent
            if ($parent -and -not (Test-Path -Path $parent)) {
                New-Item -Path $parent -ItemType Directory -Force | Out-Null
            }

            # Construye el mensaje con fecha, texto y severidad
            $date = Get-Date
            $concatmessage = "|$date| |$message| |$Severity|"    # Formato simple y legible en línea

            # Muestra en consola con color según severidad (feedback visual)
            switch ($Severity) {
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

            # Agrega (append) el mensaje al archivo indicado; crea el archivo si no existe (-Force)
            Add-Content -Path $path -Value $concatmessage -Force

            return $path                               # Devuelve la ruta del archivo donde se escribió
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"  # esto hace que un Error se invoque con un set no contemplado
        }
    }
}
