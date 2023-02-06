function Convert-WindowsTime
{
  <#
  .SYNOPSIS
  Convert Convert-WindowsTime to PowerShell DateTime

  .DESCRIPTION
  Convert Convert-WindowsTime to PowerShell DateTime

  .PARAMETER winDate
  (required) The Windows time integer

  .PARAMETER UTC
  (optional) Return datetime relative to localtime based off system timezone

  .EXAMPLE
  Convert-WindowsTime 132947402891099830

  .EXAMPLE
  Convert-WindowsTime 132947402891099830 -UTC

  .LINK
  http://darrenjrobinson.com/convert-windows-and-unix-epoch-times-with-powershell
  #>

  [cmdletbinding()]
  Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [int64]
    $winDate,

    [Parameter(ValueFromPipeline)]
    [switch]
    $UTC
  )

  Begin
  {
  }
  Process
  {
    try
    {
      $winEpoch = (Get-Date -Year 1601 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
      if ($UTC)
      {
        $dateTime = $winEpoch.AddDays($winDate / 864000000000)
      }
      else
      {
        $convertedDate = $winEpoch.AddDays($winDate / 864000000000)
        $timeZone = Get-TimeZone
        $dateTime = $convertedDate.AddMinutes($timeZone.BaseUtcOffset.TotalMinutes)
      }
      return $dateTime
    }
    catch
    {
      $_
    }
  }
  End
  {
  }
}