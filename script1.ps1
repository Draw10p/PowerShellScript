function Start-ProgressBar { 
    # function → es la palabra clave que declara una función en PowerShell.
    #  Start-ProgressBar → nombramos la función.
    # { → iniciamos el bloque de código de la función.
    [CmdletBinding()] 
    # [ ... ] → atributo decorador aplicado a la función.
    # CmdletBinding → convierte la función en una función avanzada tipo cmdlet, habilitando características como -Verbose, -Debug, manejo de parámetros avanzado, etc.
    # () → invoca el atributo (sin argumentos en este caso).
    param ( 
        # param → es el bloque de declaración de parámetros de la función.
        # ( → inicia de la lista de parámetros.
        [Parameter(Mandatory = $true)]
        $Title,
        #[Parameter(...)] → es un atributo que nos ayuda para configurar el comportamiento del parámetro.
        # Mandatory = $true → este vuelve obligatorio el parámetro (PowerShell pedirá el valor si falta).
         # $Title → nombre del primer parámetro, sin tipo explícito (acepta cualquier tipo).
        [Parameter(Mandatory = $true)]
        [int]$Timer
        # [int] → tipo entero de 32 bits; fuerza que Timer sea un número entero.
        #$Timer → nombre del segundo parámetro: cantidad de segundos del temporizador.
        
    for ($i = 1; $i -le $Timer; $i++) {
        #for → bucle for clásico (inicialización; condición; incremento).
        # $i = 1 → variable de contador inicia en 1 (primer segundo).
        # ; → separador entre las partes del for.
        # $i -le $Timer → condición: mientras i sea menor o igual que Timer.
        # -le → operador “less than or equal” (≤) en PowerShell
        # $i++ → suma 1 a $i encada iteración.
        # { → inicio del bloque del bucle.

        Start-Sleep -Seconds 1
        # Start-Sleep → es el cmdlet que pausa la ejecución.
        # -Seconds 1 → pausa por 1 segundo por iteración, simulando el paso del tiempo.
        $percentComplete = ($i / $Timer) * 100
        # $percentComplete → variable que guardará el porcentaje completado.
        # ($i / $Timer) → fracción del avance (progreso relativo).
        # * 100 → conversión a porcentaje (0–100).
        # = → operador de asignación.
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete
        # Write-Progress → cmdlet que muestra una barra de progreso en la consola.
        # -Activity $Title → texto principal de la actividad (usa el título que pasaste).
        # -Status "…"` → subtítulo/estado. Aquí muestra los segundos transcurridos con interpolación de cadena:
        # "$i seconds elapsed" → al estar entre comillas dobles, interpela $i.
        # -PercentComplete $percentComplete → le indica a la barra el porcentaje a pintar (0–100).
    }
} 

# Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30
# Start-ProgressBar → invoca la función por su nombre.
# -Title "Test timeout" → pasa el argumento Title con el texto “Test timeout”.
# -Timer 30 → ejecuta el temporizador por 30 segundos 