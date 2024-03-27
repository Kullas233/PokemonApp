"$PSScriptRoot\Images"
$tempPoke = Invoke-WebRequest -Uri "https://img.pokemondb.net/artwork/bulbasaur.jpg" -OutFile "C:\Users\kulla\OneDrive\Documents\Powershell Scripts\img.jpg"

$tempPoke.ParsedHtml.body.getElementsByTagName('img')[0] | Set-Content -Path ""