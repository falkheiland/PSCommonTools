#requires -Version 3.0
function Write-Log
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Message,

    [Parameter(Position = 2)]
    [ValidateSet('Debug', 'Info', 'Warn', 'Error')]
    [String]
    $Severity = 'Info',

    [Parameter(Position = 3)]
    [ValidateSet('Debug', 'Info', 'Warn', 'Error')]
    [String]
    $Loglevel = 'Info',

    [ValidateNotNull()]
    [String]
    $Path = '{0}' -f ($MyInvocation.ScriptName.Replace('.ps1', '.log')),

    [ValidateSet('SilentlyContinue', 'Continue')]
    [String]
    $VerbosePreference = 'Continue',

    [ValidateSet('True', 'False')]
    [String]
    $Append = 'True'
  )

  Begin
  {
    # Set VerbosePreference to Continue so that verbose messages are displayed.
    # $VerbosePreference = 'Continue'
    $WhatIfPreference = 0
    $Source = ([regex]'(\w|\d|-)*\.ps1$').Matches($Scriptname) | ForEach-Object { $_.value }
    $Level = @{
      Debug = 0
      Info  = 1
      Warn  = 2
      Error = 3
    }
  }

  Process
  {
    $LoglevelInt = ($Level.GetEnumerator() | Where-Object { $_.Name -eq $Loglevel }).Value
    $SeverityInt = ($Level.GetEnumerator() | Where-Object { $_.Name -eq $Severity }).Value
    if ($SeverityInt -ge $LoglevelInt)
    {
      $Output = ('{0}[TAB]{1}[TAB]{2}[TAB]{3}' -f ((Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')), $Severity, $Source, $Message).Replace('[TAB]', "`t")

      if ($Append -eq 'True')
      {
        Write-Verbose $Output
        $OutputParams = @{
          FilePath = $Path
          Append   = $true
        }
      }
      else
      {
        $OutputParams = @{
          FilePath = $Path
          Append   = $false
        }
      }
      $Output | Out-File @OutputParams
    }
  }

  End
  {
  }
}