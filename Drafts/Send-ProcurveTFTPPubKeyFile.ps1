#Requires -Module Posh-SSH
function Send-ProcurveTFTPPubKeyFile
{
  <#
      .SYNOPSIS
      Enables SSH Public Key Auhentication on ProCurve Switches

      .DESCRIPTION
      Sends public-key to Switches via TFTP and enables authentication via public-key.

      .PARAMETER Switche
      Array of switches

      .PARAMETER Credential
      SSH Credential for Posh-SSH to use to connect to switches

      .PARAMETER TFTPServer
      TFTP Server

      .PARAMETER TFTPFile
      public-key on TFTP Server

      .PARAMETER User
      public-key user on switch (Default manager)

      .PARAMETER Sleep
      Pause in seconds between each executed command on switch (Default 3)

      .EXAMPLE
      switch1, switch2, switch3 | Send-ProcurveTFTPPubKeyFile -Credential (Get-Credential) -TFTPServer 'TFTPServer' -TFTPFile 'id_rsa.pub'
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory, ValueFromPipeline)]
    [String[]]
    $Switch,

    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credential = (Get-Credential -Message 'Enter your credentials'),

    [Parameter(Mandatory)]
    [String]
    $TFTPServer,

    [Parameter(Mandatory)]
    [String]
    $TFTPFile,

    [String]
    $User = 'manager',

    [Int]
    $Sleep = 3
  )

  Begin
  {
  }
  Process
  {
    $Result = foreach ($item in $Switch)
    {
      $Session = New-SSHSession -ComputerName $item -Credential $Credential -AcceptKey:$true
      $stream = $Session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
      $stream.Write("`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("conf`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("no ip ssh filetransfer`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("tftp server`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("aaa authentication ssh login public-key`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("tftp`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("copy tftp pub-key-file $TFTPServer $TFTPFile $User`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("ip ssh filetransfer`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("wr m`n")
      Start-Sleep -Seconds $Sleep
      $stream.Write("logout`n")
      $Session | Remove-SSHSession
    }
    $Result
  }
  End
  {
  }
}