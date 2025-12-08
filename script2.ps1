
# Se Carga librerías .NET de Windows Forms y Drawing (para GUI y tamaños/posiciones)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear la ventana (formulario)
$form = New-Object System.Windows.Forms.Form
$form.Text = "Input Form"                                   # Título
$form.Size = New-Object System.Drawing.Size(500,250)        # Tamaño (ancho x alto)
$form.StartPosition = "CenterScreen"                        # Centrar en pantalla

# Se crea etiquetas para cada campo
$textLabel1 = New-Object System.Windows.Forms.Label
$textLabel1.Text = "Input 1:"
$textLabel1.Left = 20
{textLabel1.Top = 20}
{textLabel1.Width = 120}

$textLabel2 = New-Object System.Windows.Forms.Label
$textLabel2.Text = "Input 2:"
$textLabel2.Left = 20
{textLabel2.Top = 60}
{textLabel2.Width = 120}

$textLabel3 = New-Object System.Windows.Forms.Label
{textLabel3.Text = "Input 3:"}
{textLabel3.Left = 20}
{textLabel3.Top = 100}
{textLabel3.Width = 120}

# Se crean las cajas de texto alineadas con las etiquetas
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Left = 150
$textBox1.Top = 20
$textBox1.Width = 200

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Left = 150
{textBox2.Top = 60}
{textBox2.Width = 200}

$textBox3 = New-Object System.Windows.Forms.TextBox
{textBox3.Left = 150}
{textBox3.Top = 100}
{textBox3.Width = 200}

# Se crean valores por defecto (vacíos, puedes cambiarlos)
$defaultValue = ""
$textBox1.Text = $defaultValue
$textBox2.Text = $defaultValue
$textBox3.Text = $defaultValue

# Botón OK para confirmar
$button = New-Object System.Windows.Forms.Button
$button.Left = 360
$button.Top = 140
$button.Width = 100
$button.Text = "OK"

# Evento de clic: cuando el usuario presiona OK,
# guardamos los valores en $form.Tag y cerramos el formulario
$button.Add_Click({
    $form.Tag = @{
        Box1 = $textBox1.Text
        Box2 = $textBox2.Text
        Box3 = $textBox3.Text
    }
    $form.Close()
})

# Se agrega todos los controles a la ventana
$form.Controls.Add($button)
$form.Controls.Add($textLabel1)
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

# Mostramos el formulario como diálogo modal (bloqueado hasta que sea cerradp)
$form.ShowDialog() | Out-Null

# Devolvemos los valores capturados
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3
