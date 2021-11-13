<#
    .SYNOPSIS
    Performs a series of asynchronous pings against the target hosts.

    .PARAMETER HostName
    A string array of target hosts to ping.

    .PARAMETER PingCount
    The number of pings to send against each host.
#>
function Invoke-FastPing
{
  [alias('FastPing', 'fping', 'fp')]
  param
  (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [Alias('Computer', 'ComputerName', 'Host')]
    [String[]] $HostName,

    [Int] $PingCount = 4
  )

  process
  {
    # Objects to hold items as we process pings
    $queue = [System.Collections.Queue]::new()
    $pingHash = @{ }

    # Start an asynchronous ping against each computer
    foreach ($hn in $HostName)
    {
      if ($pingHash.Keys -notcontains $hn)
      {
        $pingHash.Add($hn, [System.Collections.ArrayList]::new())
      }

      for ($i = 0; $i -lt $PingCount; $i++)
      {
        $ping = [System.Net.Networkinformation.Ping]::new()
        $object = @{
          Host  = $hn
          Ping  = $ping
          Async = $ping.SendPingAsync($hn)
        }
        $queue.Enqueue($object)
      }
    }

    # Process the asynchronous pings
    while ($queue.Count -gt 0)
    {
      $object = $queue.Dequeue()
      if ($object.Async.IsCompleted -eq $true)
      {
        $null = $pingHash[$object.Host].Add(@{
            Host          = $object.Host
            RoundtripTime = $object.Async.Result.RoundtripTime
            Status        = $object.Async.Status
          })
      }
      else
      {
        $queue.Enqueue($object)
      }
    }

    # Using the ping results in pingHash, calculate the average RoundtripTime
    foreach ($key in $pingHash.Keys)
    {
      if (($pingHash.$key.Status | Select-Object -Unique) -eq 'RanToCompletion')
      {
        $online = $true
      }
      else
      {
        $online = $false
      }

      if ($online -eq $true)
      {
        $latency = [System.Collections.ArrayList]::new()
        foreach ($value in $pingHash.$key)
        {
          if ($value.RoundtripTime)
          {
            $null = $latency.Add($value.RoundtripTime)
          }
        }

        $average = $latency | Measure-Object -Average
        if ($average.Average)
        {
          $roundtripAverage = [Math]::Round($average.Average, 0)
        }
        else
        {
          $roundtripAverage = $null
        }
      }
      else
      {
        $roundtripAverage = $null
      }

      [PSCustomObject]@{
        ComputerName     = $key
        RoundtripAverage = $roundtripAverage
        Online           = $online
      }
    }

  } # End Process
}