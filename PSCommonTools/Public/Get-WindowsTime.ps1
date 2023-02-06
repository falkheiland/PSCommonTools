function Get-WindowsTime
{
  <#
  .SYNOPSIS
  Convert PowerShell DateTime to Windows timestamp

  .DESCRIPTION
  Convert PowerShell DateTime to Windows timestamp

  .PARAMETER Datetime
  (required) A PowerShell DateTime object

  .EXAMPLE
  $now = Get-Date
  Get-WindowsTime $now

  .EXAMPLE
  Get-Date | Get-WindowsTime

  .EXAMPLE
  Get-WindowsTime -Datetime 'Sunday, 9 October 2022 2:47:48 PM'

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
      if ($Datetime)
      {
        $windowsEpoch = (Get-Date $Datetime).ToFileTime()
      }
      else
      {
        $windowsEpoch = (Get-Date).ToFileTime()
      }
      return $windowsEpoch
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