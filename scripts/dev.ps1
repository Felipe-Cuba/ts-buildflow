param(
    [string]$command,
    [string]$type,
    [string]$name,
    [string]$context
)

function To-CamelCase {
    param([string]$value)
    if ([string]::IsNullOrWhiteSpace($value)) {
        return $value
    }
    return -join ($value -split '[-_ ]+' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() })
}

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

    # Se contexto foi fornecido e ainda assim nao achou
    if ($context) {
        throw "[X] Nenhum diretorio 'use-case' encontrado dentro de '$context'"
    }

    # Se nao foi fornecido, lista os diretorios para sugestao
    Write-Host "`n[X] Nenhum diretorio 'use-case(s)' encontrado no diretorio atual." -ForegroundColor Red
    Write-Host "`n[DIR] Diretorios disponiveis no caminho atual:" -ForegroundColor Yellow
    Get-ChildItem -Directory | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Cyan }

    throw "`n[i] Por favor, forneca o nome de um dos diretorios listados como contexto na proxima execucao: `nEx: dev g uc create-order nome-do-contexto"
}

function Generate-UseCase {
    param(
        [string]$rawName,
        [string]$context
    )

    if ([string]::IsNullOrWhiteSpace($rawName)) {
        throw "Nome do use case nao pode estar vazio"
    }

    $camelName = if ($rawName -match '[-_]') { To-CamelCase $rawName } else { $rawName }
    $folderName = ($camelName.Substring(0,1).ToLower()) + $camelName.Substring(1)
    $useCaseName = $folderName
    $dirBase = Find-UseCaseDirectory -context:$context

    $targetDir = Join-Path $dirBase $folderName
    
    if (Test-Path $targetDir) {
        Write-Host "[!] Diretorio '$folderName' ja existe. Sobrescrevendo arquivos..." -ForegroundColor Yellow
    }
    
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

    $useCaseClass = @"
import { singleton } from 'tsyringe';
import { ${camelName}Params } from './${camelName}Validation.js';

@singleton()
export class ${camelName}UseCase {
  public async execute(params: ${camelName}Params): Promise<unknown> {
    console.info(params);

    await new Promise(resolve => setTimeout(resolve, 1000));

    return;
  }
}
"@
    $validationFile = @"
import { z } from 'zod';

export const ${camelName}Validation = z.object({});

export type ${camelName}Params = z.infer<typeof ${camelName}Validation>;
"@
    $indexFile = @"
import { Request, Response } from 'express';
import { container } from 'tsyringe';
import { ${camelName}UseCase } from './${camelName}UseCase.js'; 
import { ${camelName}Validation } from './${camelName}Validation.js';

export async function handle${camelName}( 
  request: Request,
  response: Response
): Promise<void> {
  const params = ${camelName}Validation.parse(request.body);

  const ${useCaseName} = container.resolve(${camelName}UseCase);

  await ${useCaseName}.execute(params);

  response.status(200).json({ message: '${camelName} executed successfully' });
}
"@

    Set-Content -Path (Join-Path $targetDir "${camelName}UseCase.ts") -Value $useCaseClass
    Set-Content -Path (Join-Path $targetDir "${camelName}Validation.ts") -Value $validationFile
    Set-Content -Path (Join-Path $targetDir "index.ts") -Value $indexFile

    Write-Host "`n[OK] Use-case '$camelName' gerado em: $targetDir" -ForegroundColor Green
}

if ($command -eq "generate") { $command = "g" }
if ($type -eq "use-case") { $type = "uc" }

switch ($command) {
    "g" {
        switch ($type) {
            "uc" {
                if (-not $name) {
                    Write-Host "[!] Exemplo: dev g uc create-order [contexto]" -ForegroundColor Yellow
                    break
                }
                Generate-UseCase -rawName $name -context $context
            }
            default { Write-Host "[X] Tipo invalido. Use: use-case ou uc." -ForegroundColor Red }
        }
    }
    default { Write-Host "[X] Comando invalido. Use: generate ou g." -ForegroundColor Red }
}
