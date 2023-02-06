function Convert-UnixTime
{
  <#
  .SYNOPSIS
  Convert UnixTime to PowerShell DateTime

  .DESCRIPTION
  Convert UnixTime to PowerShell DateTime

  .PARAMETER UnixDate
  (required) The unix time integer

  .PARAMETER UTC
  (optional) Return datetime relative to localtime based off system timezone

  .EXAMPLE
  Convert-UnixTime 1592001868

  .EXAMPLE
  Convert-UnixTime 1592001868 -UTC

  .LINK
  http://darrenjrobinson.com/convert-windows-and-unix-epoch-times-with-powershell
  #>

  [cmdletbinding()]
  Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [int32]
    $UnixDate,

    [switch]
    $UTC
  )
  Begin
  {
  }
  Process
  {

    Try
    {
      $unixEpoch = (Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
      if ($UTC)
      {
        $dateTime = $unixEpoch.AddSeconds($UnixDate)
      }
      else
      {
        $timeZone = Get-TimeZone
        $utcTime = $unixEpoch.AddSeconds($UnixDate)
        $dateTime = $utcTime.AddMinutes($timeZone.BaseUtcOffset.TotalMinutes)
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
