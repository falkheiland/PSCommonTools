function New-Password
{
  <#
      .SYNOPSIS
      Generates Passwords

      .EXAMPLE
      New-Password -Diceware

      .EXAMPLE
      New-Password -Diceware -Words 5

      .EXAMPLE
      New-Password -Complex

      .EXAMPLE
      New-Password -Complex -Upper 1 -Lower 5 -Digit 1 -Special 2

      .EXAMPLE
      New-Password -Random -Length 12
  #>

  param
  (
    [Parameter(ParameterSetName = 'Diceware')]
    [switch]
    $Diceware,

    [Parameter(ParameterSetName = 'Diceware')]
    [int]
    $Words = 4,

    [Parameter(ParameterSetName = 'Complex')]
    [switch]
    $Complex,

    [Parameter(ParameterSetName = 'Complex')]
    [int]
    $Upper = 1,

    [Parameter(ParameterSetName = 'Complex')]
    [int]
    $Lower = 5,

    [Parameter(ParameterSetName = 'Complex')]
    [int]
    $Digit = 1,

    [Parameter(ParameterSetName = 'Complex')]
    [int]
    $Special = 1,

    [Parameter(ParameterSetName = 'Random')]
    [switch]
    $Random,

    [Parameter(ParameterSetName = 'Random')]
    [int]
    $Length = 12

  )

  $AsciiDigit = (48..57)
  $AsciiUpper = (65..90)
  $AsciiLower = (97..122)
  $AsciiSpecial = (33..43)

  switch ($PSCmdlet.ParameterSetName)
  {
    Diceware
    {
      $SpecialRandom = (Get-Random -Minimum 1 -Maximum $Words) - 1
      $Hash = Get-HashFromList
      for ($i = 0; $i -lt $Words; $i++)
      {
        $HashName = ''
        for ($k = 0; $k -lt 5; $k++)
        {
          $HashName = '{0}{1}' -f (Get-Random -Minimum 1 -Maximum 6), $HashName
        }
        $HashValue = $Hash.Item($HashName)
        if ($i -eq $SpecialRandom)
        {
          $Password = '{0}{1}{2}{3}' -f (Get-AsciiChar -Ascii $AsciiSpecial), $HashValue.Substring(0, 1).ToUpper(), $HashValue.Substring(1), $Password
        }
        else
        {
          $Password = '{0}{1}{2}' -f $HashValue.Substring(0, 1).ToUpper(), $HashValue.Substring(1), $Password
        }
      }
      $Password
    }
    Complex
    {
      [int]$Run = 0
      $CharColl = while ($Run -eq 0)
      {
        if ($Lower -gt 0)
        {
          for ($x = 0; $x -lt $Lower; $x += 1)
          {
            Get-AsciiChar -Ascii $AsciiLower
          }
        }
        if ($Upper -gt 0)
        {
          for ($x = 0; $x -lt $Upper; $x += 1)
          {
            Get-AsciiChar -Ascii $AsciiUpper
          }
        }
        if ($Digit -gt 0)
        {
          for ($x = 0; $x -lt $Digit; $x += 1)
          {
            Get-AsciiChar -Ascii $AsciiDigit
          }
        }
        if ($Special -gt 0)
        {
          for ($x = 0; $x -lt $Special; $x += 1)
          {
            Get-AsciiChar -Ascii $AsciiSpecial
          }
        }
        $Run = 1
      }

      [string]$Char = -join $CharColl
      ($Char.ToCharArray() | Sort-Object -Property {
          Get-Random
        }) -join ''
    }
    Random
    {
      [int]$Run = 0
      $CharColl = while ($Run -lt $Length)
      {
        Get-AsciiChar -Ascii (( -join '', $AsciiDigit, $AsciiUpper, $AsciiLower, $AsciiSpecial) | Select-Object -Skip 1)
        $Run++
      }
      [string]$Char = -join $CharColl
      ($Char.ToCharArray() | Sort-Object -Property {
          Get-Random
        }) -join ''
    }
  }
}

