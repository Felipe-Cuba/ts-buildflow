# Importa módulos de funções
Import-Module "$PSScriptRoot/../utils/ToCamelCase.psm1" -Force
Import-Module "$PSScriptRoot/../utils/ToPascalCase.psm1" -Force

. "$PSScriptRoot/../templates/use-cases/usecase-template.ps1"
. "$PSScriptRoot/../templates/use-cases/validation-template.ps1"
. "$PSScriptRoot/../templates/use-cases/index-template.ps1"

function Find-UseCaseDirectory {
    param([string]$context)

    $variants = @("use-cases", "use-case", "useCases", "useCase")
    $basePath = "."

    if ($context) {
        $basePath = Join-Path -Path "." -ChildPath $context
    }

    foreach ($variant in $variants) {
        $path = Join-Path -Path $basePath -ChildPath $variant
        if (Test-Path $path) {
            return $path
        }
    }

    if ($context) {
        throw "[X] Nenhum diretório 'use-case' encontrado dentro de '$context'"
    }

    Write-Host "`n[X] Nenhum diretório 'use-case(s)' encontrado no diretório atual." -ForegroundColor Red
    Write-Host "`n[DIR] Diretórios disponíveis no caminho atual:" -ForegroundColor Yellow
    Get-ChildItem -Directory | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor Cyan
    }

    throw "`n[i] Forneça um dos diretórios listados como contexto: `nEx: dev g uc create-order contexto"
}

function Convert-TemplatePlaceholders {
    param (
        [string]$template,
        [hashtable]$values
    )

    foreach ($key in $values.Keys) {
        $placeholder = '(' + $key + ')'
        $value = $values[$key]
        $template = $template.Replace($placeholder, $value)
    }

    return $template
}

function New-UseCase {
    param (
        [string]$rawName,
        [string]$context
    )

    if ([string]::IsNullOrWhiteSpace($rawName)) {
        throw "[X] Nome do use case não pode estar vazio"
    }

    $camelCase = Convert-ToCamelCase $rawName
    $pascalCase = Convert-ToPascalCase $rawName
    $folderName = $camelCase

    $dirBase = Find-UseCaseDirectory -context:$context
    if (-not $dirBase) {
        throw "[X] Diretório base não encontrado"
    }

    $targetDir = Join-Path $dirBase $folderName
    if (-not $targetDir) {
        throw "[X] Caminho de destino não pôde ser resolvido"
    }

    if (Test-Path $targetDir) {
        Write-Host "[!] Diretório '$folderName' já existe. Sobrescrevendo arquivos..." -ForegroundColor Yellow
    }

    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    $replacements = @{
        PascalName = $pascalCase
        camelName  = $camelCase
    }

    $useCaseContent    = Convert-TemplatePlaceholders -template $UseCaseTemplate -values $replacements
    $validationContent = Convert-TemplatePlaceholders -template $ValidationTemplate -values $replacements
    $indexContent      = Convert-TemplatePlaceholders -template $IndexTemplate -values $replacements

    Set-Content -Path (Join-Path $targetDir "${camelCase}UseCase.ts") -Value $useCaseContent
    Set-Content -Path (Join-Path $targetDir "${camelCase}Validation.ts") -Value $validationContent
    Set-Content -Path (Join-Path $targetDir "index.ts") -Value $indexContent

    Write-Host "`n[OK] Use-case '$camelCase' gerado em: $targetDir" -ForegroundColor Green
}

Export-ModuleMember -Function New-UseCase, Find-UseCaseDirectory, Convert-TemplatePlaceholders
