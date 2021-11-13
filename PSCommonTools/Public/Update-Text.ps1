function Update-Text
{
  <#
      .SYNOPSIS
      ###

      .DESCRIPTION
      ###

      .PARAMETER Test
      ###

      .PARAMETER Replacements
      ###

      .EXAMPLE
      Update-Text "This is a test" 'T,t,i,I,te,TE'
      #thIs Is a TEst

      $Replacements = " der ;; im ;; in ;; und ;; des ;; der ;;ä;ae;ö;oe;ü;ue;Ä;Ae;Ö;Oe;Ü;Ue;ß;ss;+;p;(;;);;,;; ;;-Berufe;;Berufe;;berufe;;.;;/;-;|;-"
      Update-Text "Gewerbliche Berufe (Metall und Service)" $Replacements
      #GewerblicheMetallService

      .NOTES
      Place additional notes here.

      .LINK
      http://powershell.com/cs/blogs/tobias/archive/2011/04/28/multiple-text-replacement-challenge.aspx 

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>

  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]
    $Text,

    [Parameter(Mandatory)]
    [string]
    $Replacements
  )

  Invoke-Expression ('$Text' + -join $(
      foreach ($Replacement in $Replacements.Split(';'))
      { 
        '-Replace("{0}","{1}")' -f $Replacement, 
        $([void]$foreach.MoveNext()
          $foreach.Current) 
      } 
    )
  )
}
