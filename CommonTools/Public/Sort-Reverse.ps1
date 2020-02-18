
function Sort-Reverse
{
  <#
  .Example
  Sort-Reverse -Array 'hhh', 'eeee', 'tttt'

  .Example
  Sort-Reverse -Array 5,6,9,2

  .Notes
  https://gist.github.com/IISResetMe/bcacc1dedabad997b7be18da82c90b98
  #>

  param (
    [array]
    $Array

  )
  # sorting rank = max
  $rank = [int]::MaxValue
  $Array | Sort-Object {
    # decrement $rank in parent scope, reversing the input order
    (--(Get-Variable rank -Scope 1).Value)
  }
}
