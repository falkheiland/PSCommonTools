function Get-RandomMAC
{
  param (
    [ValidateSet(':', '-', '')]
    [String]
    $Seperator = ''
  )
  begin
  {
  }
  process
  {
    (0..5 | ForEach-Object {
        '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15), (Get-Random -Minimum 0 -Maximum 15)
      }) -join $Seperator
  }
  end
  {
  }
}