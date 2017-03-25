foreach ($p in (Get-Item -Path * | ?{ $_.PSIsContainer } | Select Name ) ) {
  $n = $p.Name
  choco pack (Join-Path $n  "$n.nuspec")
}
