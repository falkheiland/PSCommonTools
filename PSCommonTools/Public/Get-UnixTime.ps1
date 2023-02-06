function Get-UnixTime
{
  <#
  .SYNOPSIS
  Convert PowerShell DateTime to Unix timestamp

  .DESCRIPTION
  Convert PowerShell DateTime to Unix timestamp

  .PARAMETER Datetime
  (required) A PowerShell DateTime object

  .EXAMPLE
  $now = Get-Date
  Get-UnixTime $now

  .EXAMPLE
  Get-Date | Get-UnixTime

  .EXAMPLE
  Get-Unixtime -Datetime 'Sunday, 9 October 2022 2:47:48 PM'

  .LINK
  http://darrenjrobinson.com/convert-windows-and-unix-epoch-times-with-powershell
  #>

  [cmdletbinding()]
  Param(
    [Parameter(ValueFromPipeline)]
    [DateTime]
    $Datetime
  )
  Begin
  {
  }
  Process
  {
    try
    {
      $unixEpoch = if ($Datetime)
      {
        [int][double]::Parse((Get-Date $Datetime -UFormat %s))
      }
      else
      {
        [int][double]::Parse((Get-Date -UFormat %s))
      }
      $unixEpoch
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