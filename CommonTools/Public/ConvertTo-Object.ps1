function ConvertTo-Object
{
  <#
  .SYNOPSIS
  Quick and dirty regex-based text-to-object parsing using named expressions groups and $Matches

  .DESCRIPTION
  Quick and dirty regex-based text-to-object parsing using named expressions groups and $Matches

  .PARAMETER InputString
  InputString

  .PARAMETER Pattern
  Pattern

  .EXAMPLE
  ConvertTo-Object -InputString '1abc2' -Pattern '^(?<First>\d).*(?<Second>\d)$'

  Second First
  ------ -----
  2      1

  .NOTES
  https://gist.github.com/IISResetMe/654b302383a687bd92faa8c8c3ab28fa
  #>
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [AllowEmptyString()]
    [string[]]$InputString,

    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$Pattern
  )

  process
  {
    foreach ($string in $InputString |
      Where-Object { $_ })
    {
      foreach ($p in $Pattern)
      {
        if ($string -match $p)
        {
          if ($PropertyNames = $Matches.Keys |
            Where-Object { $_ -is [string] })
          {
            $Properties = $PropertyNames |
            ForEach-Object -Begin {
              $t = @{ }
            } -Process {
              $t[$_] = $Matches[$_]
            } -End {
              $t
            }
            [PSCustomObject]$Properties
          }
          break
        }
      }
    }
  }
}