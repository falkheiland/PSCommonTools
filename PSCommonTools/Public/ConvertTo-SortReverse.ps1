
function ConvertTo-SortReverse
{
  <#
  .Example
  ConvertTo-SortReverse -Array 'hhh', 'eeee', 'tttt'

  .Example
  ConvertTo-SortReverse -Array 5,6,9,2

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
