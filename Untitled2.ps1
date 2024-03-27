function Import-Pokemon
{
    param($String)
    
    for($x=0; $x -lt $String.Count; $x++)
    {
        if($x % 6 -eq 0)
        {
            $Pokemon.Add([PSCustomObject]@{"Name"=$name; "Type"=@(); "CatchRate" = ""; "EggGroup"=@(); "Location"=@()})
            $Pokemon[$Pokemon.Count-1].Name = $String[$x].Substring(12)
        }
        elseif($x % 6 -eq 1)
        {
            if($dataString[$x].Substring(12).Contains(","))
            {
                $types = $dataString[$x].Substring(12).Split(",")
                $Pokemon[$Pokemon.Count-1].Type += $types[0]
                $Pokemon[$Pokemon.Count-1].Type += $types[1]
            }
            else
            {
                 $Pokemon[$Pokemon.Count-1].Type += $dataString[$x].Substring(12, $dataString[$x].IndexOf(")")-11)
            }
        }
        elseif($x % 6 -eq 2)
        {
            $Pokemon[$Pokemon.Count-1].CatchRate = $String[$x].Substring(12)
        }
        elseif($x % 6 -eq 3)
        {
            if($dataString[$x].Substring(12).Contains(","))
            {
                $eggGroups = $String[$x].Substring(12).Split(",")
                $Pokemon[$Pokemon.Count-1].EggGroup += $eggGroups[0]
                $Pokemon[$Pokemon.Count-1].EggGroup += $eggGroups[1]
            }
            else
            {
                 $Pokemon[$Pokemon.Count-1].EggGroup += $dataString[$x].Substring(12)
            }
        }
        elseif($x % 6 -eq 4)
        {
            if($dataString[$x].Substring(12).Contains(","))
            {
                $locations = $String[$x].Substring(12).Split(",")
                foreach($loc in $locations)
                {
                    $Pokemon[$Pokemon.Count-1].Location += $loc
                }
            }
            else
            {
                 $Pokemon[$Pokemon.Count-1].Location += $dataString[$x].Substring(12)
            }
        }
    }
}

$CGames = @("Red","Blue","Yellow","Gold","Silver","Crystal","Ruby","Saphire","Emerald","FireRed","LeafGreen","Diamond","Pearl","Platinum","HeartGold","SoulSilver","Black","White","Black 2","White 2","X","Y","Omega Ruby","Alpha Saphire","Let's Go Pikachu","Let's Go Eevee","Sword","Shield","Brilliant Diamond","Shining Pearl")
$CEggGroups = @()
$CTypes = @()
foreach($poke in $Pokemon)
{
    foreach($type in $poke.type)
    {
        $CTypes += $type
    }
    foreach($egg in $poke.EggGroup)
    {
        if($egg -notmatch "—")
        {
            $CEggGroups += $egg
        }
    }
}
$CEggGroups = $CEggGroups | Sort-Object | Get-Unique
$CTypes = $CTypes | Sort-Object | Get-Unique

function Show-MainScreen
{
    #main Page
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='PokeHelper'
    $main_form.StartPosition = "CenterScreen"
    $main_form.Width = $ScreenWidth-($ScreenWidth*.2)
    $main_form.Height = $ScreenHeight-($ScreenHeight*.2)

    #Title Label
    $Title = New-Object System.Windows.Forms.Label
    $Title.Text = "PokeHelper"
    $Title.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    $Title.Location  = New-Object System.Drawing.Point(800,100)
    $Title.AutoSize = $true
    $Title.BackColor = "Cyan"
    $main_form.Controls.Add($Title) | Out-Null

    #Games DropDown
    $ComboBox = New-Object System.Windows.Forms.ComboBox
    $ComboBox.Location  = New-Object System.Drawing.Point(650,1280)
    $ComboBox.Width = 500
    Foreach ($Game in $cGames)
    {
        $ComboBox.Items.Add($Game) | Out-Null
    }
    $ComboBox.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    $ComboBox.SelectedIndex = $cgames.Count-1
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
            Show-Pokedex -Show $Pokemon
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
    Param(
        [Parameter(Mandatory=$true)]
        $Show = $null,

        [Parameter(Mandatory=$false)]
        $Name = $null,

        [Parameter(Mandatory=$false)]
        $Type1 = $null,

        [Parameter(Mandatory=$false)]
        $Type2 = $null,

        [Parameter(Mandatory=$false)]
        $EggGroup1 = $null,

        [Parameter(Mandatory=$false)]
        $EggGroup2 = $null
    )
    
    $nextPage = [System.Collections.ArrayList]::new()
    #main Page
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='Pokedex'
    $main_form.StartPosition = "CenterScreen"
    $main_form.Width = $ScreenWidth-($ScreenWidth*.2)+150
    $main_form.Height = $ScreenHeight-($ScreenHeight*.2)

    #Back Button
    $BackButton = New-Object System.Windows.Forms.Button
    $BackButton.Location = New-Object System.Drawing.Size(50,50)
    $BackButton.Size = New-Object System.Drawing.Size(200,100)
    $BackButton.Text = "Back"
    $BackButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($BackButton) | Out-Null
    $BackButton.Add_Click(
        {
            $main_form.Hide()
            Show-MainScreen
        }
    )

    #Type DropDown
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location  = New-Object System.Drawing.Point(50,380)
    $textbox.Width = 400
    $textbox.Height = 50
    $textbox.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    #$ComboBox.SelectedIndex = $cEggGroups.Count-1
    $textbox.Text = "Name"
    if($Name -ne $null)
    {
        $textbox.Text = $Name
    }
    $textbox.Add_KeyDown({
        if ($_.KeyCode -eq "Enter") 
        {
            $main_form.Hide()
            $main_form.Close()
            $args = @{
                Show = $show
                Name = $textbox.Text
                Type1 = $null
                Type2 = $null
                EggGroup1 = $null
                EggGroup2 = $null
            }
            if($type1Box.Text -ne "Type 1")
            {
                $args.Type1 = $type1Box.Text
            }
            if($type2Box.Text -ne "Type 2")
            {
                $args.Type2 = $type2Box.Text
            }
            if($egg1Box.Text -ne "Egg Group 1")
            {
                $args.EggGroup1 = $egg1Box.Text
            }
            if($egg2Box.Text -ne "Egg Group 2")
            {
                $args.eggGroup2 = $egg2Box.Text
            }
            Show-Pokedex @args
        }
    })
    $main_form.Controls.Add($textbox) | Out-Null

    #Type DropDown
    $type1Box = New-Object System.Windows.Forms.ComboBox
    $type1Box.Location  = New-Object System.Drawing.Point(537.5,380)
    $type1Box.Width = 400
    Foreach ($type in $CTypes)
    {
        $type1Box.Items.Add($type) | Out-Null
    }
    $type1Box.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    #$ComboBox.SelectedIndex = $cEggGroups.Count-1
    $type1Box.Text = "Type 1"
    if($Type1 -ne $null)
    {
        $type1Box.Text = $Type1
    }
    $type1Box.add_SelectedIndexChanged({
            $main_form.Hide()
            $main_form.Close()
            $args = @{
                Show = $show
                Name = $null
                Type1 = $type1Box.Text
                Type2 = $null
                EggGroup1 = $null
                EggGroup2 = $null
            }
            if($textbox.Text -ne "Name")
            {
                $args.Name = $textBox.Text
            }
            if($type2Box.Text -ne "Type 2")
            {
                $args.Type2 = $type2Box.Text
            }
            if($egg1Box.Text -ne "Egg Group 1")
            {
                $args.EggGroup1 = $egg1Box.Text
            }
            if($egg2Box.Text -ne "Egg Group 2")
            {
                $args.eggGroup2 = $egg2Box.Text
            }
            Show-Pokedex @args
        }
    )
    $main_form.Controls.Add($type1Box) | Out-Null

    #Type DropDown
    $type2Box = New-Object System.Windows.Forms.ComboBox
    $type2Box.Location  = New-Object System.Drawing.Point(1025,380)
    $type2Box.Width = 400
    Foreach ($type in $CTypes)
    {
        $type2Box.Items.Add($type) | Out-Null
    }
    $type2Box.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    #$ComboBox.SelectedIndex = $cEggGroups.Count-1
    $type2Box.Text = "Type 2"
    if($Type2 -ne $null)
    {
        $type2Box.Text = $Type2
    }
    $type2Box.add_SelectedIndexChanged({
            $main_form.Hide()
            $main_form.Close()
            $args = @{
                Show = $show
                Name = $null
                Type1 = $null
                Type2 = $type2Box.Text
                EggGroup1 = $null
                EggGroup2 = $null
            }
            if($type1Box.Text -ne "Type 1")
            {
                $args.Type1 = $type1Box.Text
            }
            if($textBox.Text -ne "Name")
            {
                $args.Name = $textBox.Text
            }
            if($egg1Box.Text -ne "Egg Group 1")
            {
                $args.EggGroup1 = $egg1Box.Text
            }
            if($egg2Box.Text -ne "Egg Group 2")
            {
                $args.eggGroup2 = $egg2Box.Text
            }
            Show-Pokedex @args
        }
    )
    $main_form.Controls.Add($type2Box) | Out-Null

    #egg 1 DropDown
    $egg1Box = New-Object System.Windows.Forms.ComboBox
    $egg1Box.Location  = New-Object System.Drawing.Point(1512.5,380)
    $egg1Box.Width = 400
    Foreach ($egg in $cEggGroups)
    {
        $egg1Box.Items.Add($egg) | Out-Null
    }
    $egg1Box.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    #$ComboBox.SelectedIndex = $cEggGroups.Count-1
    $egg1Box.Text = "Egg Group 1"
    if($EggGroup1 -ne $null)
    {
        $egg1Box.Text = $EggGroup1
    }
    $egg1Box.add_SelectedIndexChanged({
            $main_form.Hide()
            $main_form.Close()
            $args = @{
                Show = $show
                Name = $null
                Type1 = $null
                Type2 = $null
                EggGroup1 = $egg1Box.Text
                EggGroup2 = $null
            }
            if($type1Box.Text -ne "Type 1")
            {
                $args.Type1 = $type1Box.Text
            }
            if($type2Box.Text -ne "Type 2")
            {
                $args.Type2 = $type2Box.Text
            }
            if($textBox.Text -ne "Name")
            {
                $args.Name = $textBox.Text
            }
            if($egg2Box.Text -ne "Egg Group 2")
            {
                $args.eggGroup2 = $egg2Box.Text
            }
            Show-Pokedex @args
        }
    )
    $main_form.Controls.Add($egg1Box) | Out-Null

    #Type DropDown
    $egg2Box = New-Object System.Windows.Forms.ComboBox
    $egg2Box.Location  = New-Object System.Drawing.Point(2000,380)
    $egg2Box.Width = 400
    Foreach ($egg in $cEggGroups)
    {
        $egg2Box.Items.Add($egg) | Out-Null
    }
    $egg2Box.Font = New-Object System.Drawing.Font("Lucida Console",28,[System.Drawing.FontStyle]::Regular)
    #$ComboBox.SelectedIndex = $cEggGroups.Count-1
    $egg2Box.Text = "Egg Group 2"
    if($EggGroup2 -ne $null)
    {
        $egg2Box.Text = $EggGroup2
    }
    $egg2Box.add_SelectedIndexChanged({
            $main_form.Hide()
            $main_form.Close()
            $args = @{
                Show = $show
                Name = $null
                Type1 = $null
                Type2 = $null
                EggGroup1 = $null
                EggGroup2 = $egg2box.Text
            }
            if($type1Box.Text -ne "Type 1")
            {
                $args.Type1 = $type1Box.Text
            }
            if($type2Box.Text -ne "Type 2")
            {
                $args.Type2 = $type2Box.Text
            }
            if($egg1Box.Text -ne "Egg Group 1")
            {
                $args.EggGroup1 = $egg1Box.Text
            }
            if($textBox.Text -ne "Name")
            {
                $args.Name = $textBox.Text
            }
            Show-Pokedex @args
        }
    )
    $main_form.Controls.Add($egg2Box) | Out-Null

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = "Pokedex"
    $Label.Font = New-Object System.Drawing.Font("Lucida Console",50,[System.Drawing.FontStyle]::Regular)
    $Label.Location  = New-Object System.Drawing.Point(800,100)
    $Label.AutoSize = $true
    $Label.BackColor = "Cyan"
    $main_form.Controls.Add($Label)

    $x = 250
    $y = 500
    $switch = $true
    foreach($poke in $Show)
    {
        if($y -gt 32000)
        {
            $nextPage += $poke
            continue
        }

        if($Name -ne $null)
        {
            if($poke.Name -ne $Name)
            {
                continue
            }
        }
        if($Type1 -ne $null)
        {
            if($poke.type -notcontains $Type1)
            {
                continue
            }
        }
        if($Type2 -ne $null)
        {
            if($poke.type -notcontains $Type2)
            {
                continue
            }
        }
        if($EggGroup1 -ne $null)
        {
            if($poke.eggGroup -notcontains $EggGroup1)
            {
                continue
            }
        }
        if($EggGroup2 -ne $null)
        {
            if($poke.eggGroup -notcontains $EggGroup2)
            {
                continue
            }
        }


        $Label = New-Object System.Windows.Forms.Label
        #$Label.BackColor = "Cyan"
        $image = [System.Drawing.Image]::FromFile("$PSScriptRoot\Images\$($poke.name).jpg")
        $bitmap = New-Object System.Drawing.Bitmap($image)
        $ratio = $($bitmap.Height/250)
        $resized = New-Object System.Drawing.Bitmap($bitmap,$(New-Object System.Drawing.Size($($bitmap.Width/$ratio),$($bitmap.Height/$ratio))))
        #$resized = New-Object System.Drawing.Bitmap($bitmap,$(New-Object System.Drawing.Size(250,250)))
        while($resized.Width -gt 499)
        {
            $resized = New-Object System.Drawing.Bitmap($bitmap,$(New-Object System.Drawing.Size($($resized.Width/1.1),$($resized.Height))))
        }
        $Label.Image = $resized
        $Label.Location  = New-Object System.Drawing.Point(($x-$resized.Width/2),$y)
        $Label.Size = New-Object System.Drawing.Size($resized.Width,$resized.Height)
        $main_form.Controls.Add($Label)

        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $poke.name
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",15,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(($x+$resized.Width/2+25),$y)
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)

        $Label = New-Object System.Windows.Forms.Label
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",10,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(($x+$resized.Width/2+30),($y+60))
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        foreach($type in $poke.type)
        {
            $Label.Text += $type
            $Label.Text += "   "
        }
        $main_form.Controls.Add($Label)

        $Label = New-Object System.Windows.Forms.Label
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",10,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(($x+$resized.Width/2+30),($y+100))
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        foreach($egg in $poke.eggGroup)
        {
            $Label.Text += $egg
            $Label.Text += "   "
        }
        $main_form.Controls.Add($Label)

        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $poke.catchRate
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",10,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(($x+$resized.Width/2+30),($y+140))
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)

        $Label = New-Object System.Windows.Forms.TextBox
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",25,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(($x+$resized.Width/2+30),($y+180))
        $Label.Size = New-Object System.Drawing.Size(650,80)
        $Label.ReadOnly = $true
        $Label.Multiline = $True
        $Label.Scrollbars = "Vertical" 
        #$Label.BackColor = "Cyan"
        foreach($loc in $poke.location)
        {
            $Label.Text += $loc
            $Label.Text += ", "
        }
        $main_form.Controls.Add($Label)

        if($switch)
        {
            $x=1450
        }
        else
        {
            #break
            $y+=($resized.Height+50)
            $x=250
        }
        $switch = !$switch
    }

    if($nextPage.Count -ne 0)
    {
        #Back Button
        $NextButton = New-Object System.Windows.Forms.Button
        $NextButton.Location = New-Object System.Drawing.Size(1150,32300)
        $NextButton.Size = New-Object System.Drawing.Size(200,100)
        $NextButton.Text = "Next"
        $NextButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
        $main_form.Controls.Add($NextButton) | Out-Null
        $NextButton.Add_Click(
            {
                $main_form.Hide()
                $main_form.Close()
                Show-Pokedex -Show $nextPage
            }
        )
    }

    #RULER
    <#########################################################
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
    for($x = 100; $x -lt 50000;$x=$x+500)
    {
        $Label = New-Object System.Windows.Forms.Label
        $Label.Text = $x
        $Label.Font = New-Object System.Drawing.Font("Lucida Console",5,[System.Drawing.FontStyle]::Regular)
        $Label.Location  = New-Object System.Drawing.Point(0,$x)
        $Label.AutoSize = $true
        #$Label.BackColor = "Cyan"
        $main_form.Controls.Add($Label)
    }
    ##########################################################>

    #Show Page
    $main_form.AutoScroll = $true
    $main_form.ShowDialog() | Out-Null
}
Show-MainScreen


Add-Type -assembly System.Windows.Forms
Add-Type -assembly System.Drawing
$dataFilePath = "C:\Users\kulla\OneDrive\Documents\Powershell Scripts\Pokemon.txt"
$dataString = Get-Content -Path $dataFilePath
#$Pokemon = [System.Collections.ArrayList]::new()
#Import-Pokemon -String $dataString

$screen = [System.Windows.Forms.Screen]::AllScreens
$ScreenWidth = $screen.workingArea.Width
$ScreenHeight = $screen.workingArea.height