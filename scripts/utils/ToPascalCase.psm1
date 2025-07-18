function Convert-ToPascalCase {
    param([string]$value)
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $value
    }
    return -join ($value -split '[-_ ]+' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() })
}

Export-ModuleMember -Function Convert-ToPascalCase