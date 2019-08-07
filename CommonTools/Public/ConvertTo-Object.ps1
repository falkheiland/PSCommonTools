function ConvertTo-Object
{
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [AllowEmptyString()]
    [string[]]$InputString,

    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$Pattern
  )

  process
  {
    foreach ($string in $InputString | Where-Object { $_ })
    {
      foreach ($p in $Pattern)
      {
        if ($string -match $p)
        {
          if ($PropertyNames = $Matches.Keys | Where-Object { $_ -is [string] })
          {
            $Properties = $PropertyNames | ForEach-Object -Begin { $t = @{ } } -Process { $t[$_] = $Matches[$_] } -End { $t }
            [PSCustomObject]$Properties
          }
          break
        }
      }
    }
  }
}