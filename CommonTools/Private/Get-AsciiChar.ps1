function Get-AsciiChar
<#
  .Example
  Get-AsciiChar -Ascii (48..57)
#>
{
  param
  (
    [Parameter(Mandatory)]$Ascii
  )

  $Ascii |
    Get-Random |
    ForEach-Object -Process {
      [char]$_
    }
}