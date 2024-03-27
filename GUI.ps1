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
                 $Pokemon[$Pokemon.Count-1].Type += $dataString[$x].Substring(12)
            }
        }
        elseif($x % 6 -eq 2)
        {
            $Pokemon[$Pokemon.Count-1].CatchRate = $String[$x].Substring(12, $dataString[$x].IndexOf(")")-11)
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

function Get-PokemonByName
{
    Param(
        [Parameter(Mandatory=$true)]
        $Name = $null
    )

    foreach($poke in $Pokemon)
    {
        if($poke.Name -eq $Name)
        {
            return $poke
        }
    }
}

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
            $main_form.Close()
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
            $main_form.Hide()
            $main_form.Close()
            Get-GoodAgainst -Show $Pokemon
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
            $main_form.Hide()
            $main_form.Close()
            Get-BadAgainst -Show $Pokemon
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




    <#RULER
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
    ##########################################################>

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
            $main_form.Close()
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
        $Label.Text = $Label.Text.Substring(0, $Label.Text.Length-2)
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
        #Next Button
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

function Get-GoodAgainst
{
    Param(
        [Parameter(Mandatory=$true)]
        $Show = $null,

        [Parameter(Mandatory=$false)]
        $Name = $null
    )

    $nextPage = [System.Collections.ArrayList]::new()
    #main Page
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='Good Against'
    $main_form.StartPosition = "CenterScreen"
    $main_form.Width = $ScreenWidth-($ScreenWidth*.2)+150
    $main_form.Height = $ScreenHeight-($ScreenHeight*.2)

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = "Is Good Against"
    $Label.Font = New-Object System.Drawing.Font("Lucida Console",48,[System.Drawing.FontStyle]::Regular)
    $Label.Location  = New-Object System.Drawing.Point(900,50)
    $Label.AutoSize = $true
    $Label.BackColor = "Cyan"
    $main_form.Controls.Add($Label)

    #Back Button
    $BackButton = New-Object System.Windows.Forms.Button
    $BackButton.Location = New-Object System.Drawing.Size(50,300)
    $BackButton.Size = New-Object System.Drawing.Size(200,100)
    $BackButton.Text = "Back"
    $BackButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($BackButton) | Out-Null
    $BackButton.Add_Click(
        {
            $main_form.Hide()
            $main_form.Close()
            Show-MainScreen
        }
    )

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = "Types: "
    $Label.Font = New-Object System.Drawing.Font("Lucida Console",20,[System.Drawing.FontStyle]::Regular)
    $Label.Location  = New-Object System.Drawing.Point(300, 325)
    $Label.AutoSize = $true
    #$Label.BackColor = "Cyan"
    $main_form.Controls.Add($Label)

    #Type DropDown
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location  = New-Object System.Drawing.Point(50,100)
    $textbox.Width = 800
    $textbox.Height = 125
    $textbox.Font = New-Object System.Drawing.Font("Lucida Console",50,[System.Drawing.FontStyle]::Regular)
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
            }
            
            Get-GoodAgainst @args
        }
    })
    $main_form.Controls.Add($textbox) | Out-Null

    $x = 250
    $y = 500
    $switch = $true
    foreach($poke in $Show)
    {
        if($Name -eq $null)
        {
            break
        }
        elseif($poke.Name -eq $Show[0].Name)
        {
            $targetPoke = Get-PokemonByName -Name $Name
            if($targetPoke -eq $null)
            {
                break
            }
        }
        
        $good = $false
        $bad = $false
        foreach($type in $poke.Type)
        {
            foreach($targetType in $targetPoke.Type)
            {
                if($typeChart.$($targetType).BadAgainst.None -contains $type -or $typeChart.$($targetType).BadAgainst.Half -contains $type)
                {
                    $bad = $true
                    break
                }
                if($typeChart.$($targetType).GoodAgainst -contains $type)
                {
                    $good = $true
                }
            }
            if($bad)
            {
                $good = $false
                break
            }
        }

        if(-not $good)
        {
            continue
        }



        if($y -gt 32000)
        {
            $nextPage += $poke
            continue
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
        $Label.Text = $Label.Text.Substring(0, $Label.Text.Length-2)
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
        #Next Button
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
                Get-GoodAgainst -Name $Name -Show $nextPage
            }
        )
    }

    #Show Page
    $main_form.AutoScroll = $true
    $main_form.ShowDialog() | Out-Null
}

function Get-BadAgainst
{
    Param(
        [Parameter(Mandatory=$true)]
        $Show = $null,

        [Parameter(Mandatory=$false)]
        $Name = $null
    )

    $nextPage = [System.Collections.ArrayList]::new()
    #main Page
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text ='Bad Against'
    $main_form.StartPosition = "CenterScreen"
    $main_form.Width = $ScreenWidth-($ScreenWidth*.2)+150
    $main_form.Height = $ScreenHeight-($ScreenHeight*.2)

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = "Is Bad Against"
    $Label.Font = New-Object System.Drawing.Font("Lucida Console",48,[System.Drawing.FontStyle]::Regular)
    $Label.Location  = New-Object System.Drawing.Point(950,50)
    $Label.AutoSize = $true
    $Label.BackColor = "Cyan"
    $main_form.Controls.Add($Label)

    #Back Button
    $BackButton = New-Object System.Windows.Forms.Button
    $BackButton.Location = New-Object System.Drawing.Size(50,300)
    $BackButton.Size = New-Object System.Drawing.Size(200,100)
    $BackButton.Text = "Back"
    $BackButton.Font = New-Object System.Drawing.Font("Lucida Console",13,[System.Drawing.FontStyle]::Regular)
    $main_form.Controls.Add($BackButton) | Out-Null
    $BackButton.Add_Click(
        {
            $main_form.Hide()
            $main_form.Close()
            Show-MainScreen
        }
    )

    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = "Types: "
    $Label.Font = New-Object System.Drawing.Font("Lucida Console",20,[System.Drawing.FontStyle]::Regular)
    $Label.Location  = New-Object System.Drawing.Point(300, 325)
    $Label.AutoSize = $true
    #$Label.BackColor = "Cyan"
    $main_form.Controls.Add($Label)

    #Type DropDown
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location  = New-Object System.Drawing.Point(50,100)
    $textbox.Width = 800
    $textbox.Height = 125
    $textbox.Font = New-Object System.Drawing.Font("Lucida Console",50,[System.Drawing.FontStyle]::Regular)
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
            }
            
            Get-BadAgainst @args
        }
    })
    $main_form.Controls.Add($textbox) | Out-Null

    $x = 250
    $y = 500
    $switch = $true
    foreach($poke in $Show)
    {
        if($Name -eq $null)
        {
            break
        }
        elseif($poke.Name -eq $Show[0].Name)
        {
            $targetPoke = Get-PokemonByName -Name $Name
            if($targetPoke -eq $null)
            {
                break
            }
        }
        
        $good = $false
        $bad = $false
        $break = $false
        foreach($type in $poke.Type)
        {
            foreach($targetType in $targetPoke.Type)
            {
                if($typeChart.$($targetType).BadAgainst.None -contains $type)
                {
                    $good = $true
                    $break = $true
                    break
                }
                if($typeChart.$($targetType).GoodAgainst -contains $type)
                {
                    $good = $false
                    $bad = $true
                }
                if($typeChart.$($targetType).BadAgainst.Half -contains $type -and $bad -eq $false)
                {
                    $good = $true
                }
            }
            if($break)
            {
                break
            }
        }

        if(-not $good)
        {
            continue
        }



        if($y -gt 32000)
        {
            $nextPage += $poke
            continue
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
        $Label.Text = $Label.Text.Substring(0, $Label.Text.Length-2)
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
        #Next Button
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
                Get-BadAgainst -Name $Name -Show $nextPage
            }
        )
    }

    #Show Page
    $main_form.AutoScroll = $true
    $main_form.ShowDialog() | Out-Null
}
#Show-MainScreen
#Get-BadAgainst -Show $Pokemon

Add-Type -assembly System.Windows.Forms
Add-Type -assembly System.Drawing
$dataFilePath = "C:\Users\Dylan\OneDrive\Documents\Powershell Scripts\Pokemon\Pokemon.txt"
$dataString = Get-Content -Path $dataFilePath
$Pokemon = [System.Collections.ArrayList]::new()
Import-Pokemon -String $dataString


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

$CNormal = @{GoodAgainst = @(); BadAgainst = @{Half = @("Rock", "Steel"); None = @("Ghost")}; GoodAgainstIt = @("Fighting"); BadAgainstIt = @{Half = @(); None = @("Ghost")}}
$CFire = @{GoodAgainst = @("Grass", "Ice", "Bug", "Steel"); BadAgainst = @{Half = @("Fire", "Water", "Rock", "Dragon"); None = @()}; GoodAgainstIt = @("Water", "Ground", "Rock"); BadAgainstIt = @{Half = @("Fire", "Grass", "Ice", "Bug", "Steel", "Fairy"); None = @()}}
$CWater = @{GoodAgainst = @("Fire", "Ground", "Rock"); BadAgainst = @{Half = @("Water", "Grass", "Dragon"); None = @()}; GoodAgainstIt = @("Grass", "Electric"); BadAgainstIt = @{Half = @("Fire", "Water", "Ice", "Steel"); None = @()}}
$CGrass = @{GoodAgainst = @("Water", "Ground", "Rock"); BadAgainst = @{Half = @("Fire", "Grass", "Poison", "Flying", "Bug", "Dragon", "Steel"); None = @()}; GoodAgainstIt = @("Fire", "Ice", "Poison", "Flying", "Bug"); BadAgainstIt = @{Half = @("Water", "Grass", "Electric", "Ground"); None = @()}}
$CElectric = @{GoodAgainst = @("Water", "Flying"); BadAgainst = @{Half = @("Grass", "Electric", "Dragon"); None = @("Ground")}; GoodAgainstIt = @("Ground"); BadAgainstIt = @{Half = @("Electric", "Flying", "Steel"); None = @()}}
$CIce = @{GoodAgainst = @("Grass", "Ground", "Flying", "Dragon"); BadAgainst = @{Half = @("Fire", "Water", "Ice", "Steel"); None = @()}; GoodAgainstIt = @("Fire", "Fighting", "Rock", "Steel"); BadAgainstIt = @{Half = @("Ice"); None = @()}}
$CFighting = @{GoodAgainst = @("Normal", "Ice", "Rock", "Dark", "Steel"); BadAgainst = @{Half = @("Poison", "Flying", "Psychic", "Bug", "Fairy"); None = @("Ghost")}; GoodAgainstIt = @("Flying", "Psychic", "Fairy"); BadAgainstIt = @{Half = @("Bug", "Rock", "Dark"); None = @()}}
$CPoison = @{GoodAgainst = @("Grass", "Fairy"); BadAgainst = @{Half = @("Poison", "Ground", "Rock", "Ghost"); None = @("Steel")}; GoodAgainstIt = @("Ground", "Psychic"); BadAgainstIt = @{Half = @("Grass", "Fighting", "Poison", "Bug", "Fairy"); None = @()}}
$CGround = @{GoodAgainst = @("Fire", "Electric", "Poison", "Rock", "Steel"); BadAgainst = @{Half = @("Grass", "Bug"); None = @("Flying")}; GoodAgainstIt = @("Water", "Grass", "Ice"); BadAgainstIt = @{Half = @("Poison", "Rock"); None = @("Electric")}}
$CFlying = @{GoodAgainst = @("Grass", "Fighting", "Bug"); BadAgainst = @{Half = @("Electric", "Rock", "Steel"); None = @()}; GoodAgainstIt = @("Electric", "Ice", "Rock"); BadAgainstIt = @{Half = @("Grass", "Fighting", "Bug"); None = @("Ground")}}
$CPsychic = @{GoodAgainst = @("Fighting", "Poison"); BadAgainst = @{Half = @("Psychic", "Steel"); None = @("Dark")}; GoodAgainstIt = @("Bug", "Ghost", "Dark"); BadAgainstIt = @{Half = @("Fighting", "Psychic"); None = @()}}
$CBug = @{GoodAgainst = @("Grass", "Psychic", "Dark"); BadAgainst = @{Half = @("Fire", "Fighting", "Poison", "Flying", "Ghost", "Steel", "Fairy"); None = @()}; GoodAgainstIt = @("Fire", "Flying", "Rock"); BadAgainstIt = @{Half = @("Grass", "Fighting", "Ground"); None = @()}}
$CRock = @{GoodAgainst = @("Fire", "Ice", "Flying", "Bug"); BadAgainst = @{Half = @("Fighting", "Ground", "Steel"); None = @()}; GoodAgainstIt = @("Water", "Grass", "Fighting", "Ground", "steel"); BadAgainstIt = @{Half = @("Normal", "Fire", "Poison", "Flying"); None = @()}}
$CGhost = @{GoodAgainst = @("Psychic", "Ghost"); BadAgainst = @{Half = @("Dark"); None = @("Normal")}; GoodAgainstIt = @("Ghost", "Dark"); BadAgainstIt = @{Half = @("Poison", "Bug"); None = @("Normal", "Fighting")}}
$CDragon = @{GoodAgainst = @("Dragon"); BadAgainst = @{Half = @("Steel"); None = @("Fairy")}; GoodAgainstIt = @("Ice", "Dragon", "Fairy"); BadAgainstIt = @{Half = @("Fire", "Water", "Grass", "Electric"); None = @()}}
$CDark = @{GoodAgainst = @("Psychic", "Ghost"); BadAgainst = @{Half = @("Fighting", "Dark", "Fairy"); None = @()}; GoodAgainstIt = @("Fighting", "Bug", "Fairy"); BadAgainstIt = @{Half = @("Ghost", "Dark"); None = @("Psychic")}}
$CSteel = @{GoodAgainst = @("Ice", "Rock", "Fairy"); BadAgainst = @{Half = @("Fire", "Water", "Electric", "Steel"); None = @()}; GoodAgainstIt = @("Fire", "Fighting", "Ground"); BadAgainstIt = @{Half = @("Normal", "Grass", "Ice", "Flying", "Psychic", "Bug", "Rock", "Dragon", "Steel", "Fairy"); None = @("Poison")}}
$CFairy = @{GoodAgainst = @("Fighting", "Dragon", "Dark"); BadAgainst = @{Half = @("Fire", "Poison", "Steel"); None = @()}; GoodAgainstIt = @("Poison", "Steel"); BadAgainstIt = @{Half = @("Fighting", "Bug", "Dark"); None = @("Dragon")}}

$TypeChart = @{Normal = $CNormal; Fire = $CFire; Water = $CWater; Grass = $CGrass; Electric = $CElectric; Ice = $CIce; Fighting = $CFighting; Poison = $CPoison; Ground = $CGround; Flying = $CFlying; Psychic = $CPsychic; Bug = $CBug; Rock = $CRock; Ghost = $CGhost; Dragon = $CDragon; Dark = $CDark; Steel = $CSteel; Fairy = $CFairy}

$screen = [System.Windows.Forms.Screen]::AllScreens
$ScreenWidth = $screen.workingArea.Width
$ScreenHeight = $screen.workingArea.height

Show-MainScreen