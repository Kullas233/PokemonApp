$Games = @("Red","Blue","Yellow","Gold","Silver","Crystal","Ruby","Saphire","Emerald","FireRed","LeafGreen","Diamond","Pearl","Platinum","HeartGold","SoulSilver","Black","White","Black 2","White 2","X","Y","Omega Ruby","Alpha Saphire","Let's Go Pikachu","Let's Go Eevee","Sword","Shield","Brilliant Diamond","Shining Pearl")


function Show-MainScreen
{
    #main Page
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='GUI for my PoSh script'
    $main_form.StartPosition = "CenterScreen"
    $main_form.Width = $ScreenWidth-($ScreenWidth*.2)
    $main_form.Height = $ScreenHeight-($ScreenHeight*.2)

    #Title Label
    $Title = New-Object System.Windows.Forms.Label
    $Title.Text = "Kullas's Poke Helper"
    $Title.Font = New-Object System.Drawing.Font("Lucida Console",20,[System.Drawing.FontStyle]::Regular)
    $Title.Location  = New-Object System.Drawing.Point(800,100)
    $Title.AutoSize = $true
    $Title.BackColor = "Cyan"
    $main_form.Controls.Add($Title) | Out-Null

    #Games DropDown
    $ComboBox = New-Object System.Windows.Forms.ComboBox
    $ComboBox.Location  = New-Object System.Drawing.Point(650,1280)
    $ComboBox.Width = 500
    Foreach ($Game in $Games)
    {
        $ComboBox.Items.Add($Game) | Out-Null;
    }
    $ComboBox.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    $ComboBox.SelectedIndex = $games.Count-1
    $main_form.Controls.Add($ComboBox) | Out-Null

    #Load Game Button
    $LoadGameButton = New-Object System.Windows.Forms.Button
    $LoadGameButton.Location = New-Object System.Drawing.Size(1250,1250)
    $LoadGameButton.Size = New-Object System.Drawing.Size(350,100)
    $LoadGameButton.Text = "Load Game"
    $LoadGameButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($LoadGameButton) | Out-Null
    $LoadGameButton.Add_Click(
        {
            Write-Host "Click"
        }
    )

    #Pokedex Button
    $PokedexButton = New-Object System.Windows.Forms.Button
    $PokedexButton.Location = New-Object System.Drawing.Size(300,300)
    $PokedexButton.Size = New-Object System.Drawing.Size(700,250)
    $PokedexButton.Text = "Pokedex"
    $PokedexButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($PokedexButton) | Out-Null
    $PokedexButton.Add_Click(
        {
            $main_form.Hide()
            Show-Pokedex
        }
    )

    #Search Button
    $SearchButton = New-Object System.Windows.Forms.Button
    $SearchButton.Location = New-Object System.Drawing.Size(1400,300)
    $SearchButton.Size = New-Object System.Drawing.Size(700,250)
    $SearchButton.Text = "Search"
    $SearchButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($SearchButton) | Out-Null
    $SearchButton.Add_Click(
        {
            Write-Host "Click"
        }
    )

    #Good Against Button
    $GAButton = New-Object System.Windows.Forms.Button
    $GAButton.Location = New-Object System.Drawing.Size(300,600)
    $GAButton.Size = New-Object System.Drawing.Size(700,250)
    $GAButton.Text = "Good Against"
    $GAButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($GAButton) | Out-Null
    $GAButton.Add_Click(
        {
            Write-Host "Click"
        }
    )

    #Bad Against Button
    $BAButton = New-Object System.Windows.Forms.Button
    $BAButton.Location = New-Object System.Drawing.Size(1400,600)
    $BAButton.Size = New-Object System.Drawing.Size(700,250)
    $BAButton.Text = "Bad Against"
    $BAButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($BAButton) | Out-Null
    $BAButton.Add_Click(
        {
            Write-Host "Click"
        }
    )

    #Good Against It Button
    $GAIButton = New-Object System.Windows.Forms.Button
    $GAIButton.Location = New-Object System.Drawing.Size(300,900)
    $GAIButton.Size = New-Object System.Drawing.Size(700,250)
    $GAIButton.Text = "Good Against It"
    $GAIButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($GAIButton) | Out-Null
    $GAIButton.Add_Click(
        {
            Write-Host "Click"
        }
    )

    #Bad Against It Button
    $BAIButton = New-Object System.Windows.Forms.Button
    $BAIButton.Location = New-Object System.Drawing.Size(1400,900)
    $BAIButton.Size = New-Object System.Drawing.Size(700,250)
    $BAIButton.Text = "Bad Against It"
    $BAIButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($BAIButton) | Out-Null
    $BAIButton.Add_Click(
        {
            Write-Host "Click"
        }
    ) 




    #RULER
    #########################################################
    for($x = 0; $x -lt $main_form.Width;$x=$x+100)
    {
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $x
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",5,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point($x,10)
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)
    }
    for($x = 100; $x -lt $main_form.Width;$x=$x+100)
    {
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $x
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",5,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(0,$x)
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)
    }
    ##########################################################

    #Show Page
    $main_form.ShowDialog() | Out-Null
}

function Show-Pokedex
{
    #main Page
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='GUI for my PoSh script'
    $main_form.StartPosition = "CenterScreen"
    $main_form.Width = $ScreenWidth-($ScreenWidth*.2)
    $main_form.Height = $ScreenHeight-($ScreenHeight*.2)

    #Pokedex Button
    $PokedexButton = New-Object System.Windows.Forms.Button
    $PokedexButton.Location = New-Object System.Drawing.Size(300,300)
    $PokedexButton.Size = New-Object System.Drawing.Size(700,250)
    $PokedexButton.Text = "Pokedex"
    $PokedexButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($PokedexButton) | Out-Null
    $PokedexButton.Add_Click(
        {
            $main_form.Hide()
            Show-MainScreen
        }
    )




    #RULER
    #########################################################
    for($x = 0; $x -lt $main_form.Width;$x=$x+100)
    {
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $x
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",5,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point($x,10)
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)
    }
    for($x = 100; $x -lt $main_form.Width;$x=$x+100)
    {
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $x
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",5,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(0,$x)
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)
    }
    ##########################################################

    #Show Page
    $main_form.ShowDialog() | Out-Null
}

Add-Type -AssemblyName System.Windows.Forms    
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.Screen]::AllScreens
$ScreenWidth = $screen.workingArea.Width
$ScreenHeight = $screen.workingArea.height

Show-MainScreen


<#$image = [System.Drawing.Image]::FromFile("C:\Users\kulla\OneDrive\Documents\Powershell Scripts\Poke Type Buttons.png")
$bitmap = New-Object System.Drawing.Bitmap($image, 200, 150)
$LoadGameButton.Image = $bitmap#>