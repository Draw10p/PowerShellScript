
# INSTALAR POWERSHELL EN CODESPACE

# En primer lugar lo que hacemos en esta linea es actualizar la lista de paquetes disponibles 
# en tu sistema desde los repositorios configurados.
sudo apt-get update

# los cuales hacen:
# sudo → ejecuta el comando con permisos de administrador.
# apt-get → gestor de paquetes de Debian/Ubuntu.
# update → actualiza la lista de paquetes disponibles desde los repositorios configurados.

# Continuamos con la linea la instala herramientas, con las que descargaremos el archivo y el repositorios.
sudo apt-get install -y wget apt-transport-https software-properties-common

# sudo → permisos de administrador.
# apt-get → gestor de paquetes.
# install → acción para instalar paquetes.
# -y → responde “sí” automáticamente a cualquier pregunta.
# wget → herramienta para descargar archivos desde la web por HTTP/HTTPS/FTP.
# apt-transport-https → añade soporte para que apt use repositorios a través de HTTPS.
# software-properties-common → utilidades para manejar repositorios.

# Siguiente  a esto cargamos en el shell las variables del archivo /etc/os-release, que contiene información sobre tu distribución
source /etc/os-release

# source → ejecuta el contenido de un archivo en el shell actual.
# /etc/os-release → archivo de texto del sistema que contiene información de la distribución.

# De esta forma  descarga el archivo .deb que configura el repositorio oficial de Microsoft en tu sistema.
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

# wget → herramienta para descargar archivos desde internet.
# -q → modo “quiet”: suprime la salida (no muestra progreso ni mensajes).
# https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb → URL a un archivo .deb de Microsoft que configura su repositorio para Ubuntu:https → protocolo seguro.
# packages.microsoft.com → host (servidor de Microsoft).
# /config/ubuntu/ → ruta para configuraciones específicas de Ubuntu.
# $VERSION_ID → variable de ambiente 
# packages-microsoft-prod.deb → paquete Debian que agrega el repositorio de Microsoft al sistema.

# Instalamos el paquete .deb descargado, agregando el repositorio de Microsoft a tu lista de fuentes.
sudo dpkg -i packages-microsoft-prod.deb

# sudo → permisos de administrador.
# dpkg → gestor de paquetes de bajo nivel para archivos .deb.
# -i → opción que instala el paquete pasado como argumento.
# packages-microsoft-prod.deb → el archivo descargado que registra el repositorio oficial de Microsoft en tu sistema.

# Despues eliminamos el archivo .deb descargado, ya que no se necesita después de instalarlo.
rm packages-microsoft-prod.deb

# rm → elimina archivos.
# packages-microsoft-prod.deb → borra el archivo .deb ya instalado como si fuera limpieza.

# Volmemos a actualizar la lista de paquetes, ahora incluyendo el repositorio de Microsoft.
sudo apt-get update

# update → vuelve a actualizar la lista de paquetes, ahora incluyendo el nuevo repositorio de Microsoft recién configurado.

# Dando asi que isntalamos PowerShell desde el repositorio de Microsoft.
sudo apt-get install -y powershell

# install → instala un paquete.
# -y → acepta la instalación automáticamente.
# powershell → nombre del paquete de PowerShell proveniente del repositorio de Microsoft.

# Finalmente, iniciamos la consola de PowerShell.
pwsh

# pwsh → ejecutable de PowerShell 7+ (inicia la consola de PowerShell)

function Start-ProgressBar {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Title,
        
        [Parameter(Mandatory = $true)]
        [int]$Timer
    )
    
    for ($i = 1; $i -le $Timer; $i++) {
        Start-Sleep -Seconds 1
        $percentComplete = ($i / $Timer) * 100
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete
    }
} 

# Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30