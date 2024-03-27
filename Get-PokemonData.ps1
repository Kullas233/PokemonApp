$HTML = Invoke-WebRequest -Uri https://pokemondb.net/pokedex/all

$allPokemon = ($HTML.ParsedHtml.body.getElementsByClassName('ent-name'))
$allNames = [System.Collections.ArrayList]::new()

foreach($poke in $allPokemon)
{
    $allNames.Add($poke.nameProp)
}

$allNames = $allNames | select -Unique
for($x=0; $x -lt $allNames.Count; $x++)
{
    $allNames[$x] = (Get-Culture).TextInfo.ToTitleCase($allNames[$x])
}

$BDSPNames = [System.Collections.ArrayList]::new()
$BDSPWebPage = [System.Collections.ArrayList]::new()
$Database = [System.Collections.ArrayList]::new()

if($(Test-Path "$PSScriptRoot\Images"))
{
    $images = Get-Content -Path "$PSScriptRoot\Images" -ErrorAction SilentlyContinue
    foreach($image in $images)
    {
        Remove-Item -Path $image
    }
}
else
{
    New-Item -Path "$PSScriptRoot" -Name "Images" -ItemType Directory | Out-Null
}

foreach($name in $allNames)
{
    $tempPoke = Invoke-WebRequest -Uri "https://pokemondb.net/pokedex/$name"

    $img = $tempPoke.ParsedHtml.body.getElementsByTagName('img')[0].src
    Invoke-WebRequest -Uri $img -OutFile "$PSScriptRoot\Images\$name.jpg"

    $games = $tempPoke.ParsedHtml.body.getElementsByClassName('igame')
    $SP = $null

    foreach($game in $games)
    {
        if($game.textContent -eq "Shining Pearl")
        {
            $SP = $game
        }
    }

    $dexDesc = $SP.parentNode.parentNode.innerText

    if($SP -ne $null -and $dexDesc.Substring($dexDesc.IndexOf("Shining Pearl")+13) -ne "Not available in this game")
    {
        $Database.Add([PSCustomObject]@{"Name"=$name; "Type"=@(); "CatchRate" = ""; "EggGroup"=@(); "Location"=@()})
        
        #get Type
        $allTypes = $($tempPoke.ParsedHtml.body.getElementsByClassName('type-icon')).textContent
        $allTypes = $allTypes | Select -Unique
        for($x = 0; $x -lt $allTypes.Count-2; $x++)
        {
            if($allTypes[$x] -eq "Nor" -and $allTypes[$x+1] -eq "Fir" -and $allTypes[$x+2] -eq "Wat")
            {
                break
            } 
            $Database[$Database.Count-1].Type += $allTypes[$x]
        }

        #get CatchRate
        $Database[$Database.Count-1].CatchRate = $($($($tempPoke.ParsedHtml.body.getElementsByTagName('th') | where {$_.innerText -like "*Catch Rate*"}).nextSibling).innerText) | Select -Unique

        #get EggGroup
        $Database[$Database.Count-1].EggGroup += $($($($tempPoke.ParsedHtml.body.getElementsByTagName('th') | where {$_.innerText -like "*Egg Group*"}).nextSibling).innerText) | Select -Unique

        #get Location
        $allLocations = $($($($tempPoke.ParsedHtml.body.getElementsByClassName('igame') | where {$_.textContent -like "*Shining Pearl*"})[1].parentnode).nextSibling).innerText
        $allLocations = $allLocations.split(",") | Select -Unique

        foreach($loc in $allLocations)
        {
            if($loc[0] -eq " ")
            {
                $Database[$Database.Count-1].Location += $loc.subString(1)
            }
            else
            {
                $Database[$Database.Count-1].Location += $loc
            }
        }
    }
}

$str = ""
foreach($data in $Database)
{
    $str += "Name      : "
    $str += $data.Name 
    $str += "`n"

    $str += "Type      : "
    foreach($type in $data.Type)
    {   
        $str += $type

        if($data.Type.Count -gt 1 -and $type -ne $data.Type[$data.Type.Count-1])
        {
            $str += ","    
        }
    }
    $str += "`n"

    $str += "CatchRate : "
    $str += $data.CatchRate 
    $str += "`n"

    $str += "EggGroup  : "
    foreach($group in $data.EggGroup)
    {   
        $str += $group.Replace(" ","")

        if($data.EggGroup.Count -gt 1 -and $group -ne $data.EggGroup[$data.EggGroup.Count-1])
        {
            $str += ","    
        }
    }
    $str += "`n"

    $str += "Location  : "
    foreach($loc in $data.Location)
    {   
        $str += $loc

        if($data.Location.Count -gt 1 -and $loc -ne $data.Location[$data.Location.Count-1])
        {
            $str += ","    
        }
    }
    $str += "`n`n"
}

$str = $str.Substring(0, $str.Length-2)
$str | Set-Content -Path "C:\Users\kulla\OneDrive\Documents\Powershell Scripts\Pokemon.txt"