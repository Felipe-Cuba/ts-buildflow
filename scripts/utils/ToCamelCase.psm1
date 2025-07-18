function Convert-ToCamelCase {
    param([string]$value)

    if ([string]::IsNullOrWhiteSpace($value)) {
        return $value
    }

    $parts = $value -split '[-_ ]+'
    $camel = $parts[0].ToLower()

    if ($parts.Length -gt 1) {
        $rest = $parts[1..($parts.Length - 1)] | ForEach-Object {
            $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower()
        }
        $camel += ($rest -join '')
    }

    return $camel
}

Export-ModuleMember -Function Convert-ToCamelCase
