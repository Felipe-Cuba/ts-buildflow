$command = $args[0].ToLower()
$type    = $args[1].ToLower()
$name    = $args[2]
$context = $args[3]

# Conversões explícitas de alias
if ($command -eq "generate") { $command = "g" }
if ($type -eq "use-case")    { $type = "uc" }

Import-Module "$PSScriptRoot/modules/UseCaseModule.psm1"

switch ($command) {
    "g" {
        switch ($type) {
            "uc" {
                if (-not $name) {
                    Write-Host "[!] Exemplo: dev g uc create-order [contexto]" -ForegroundColor Yellow
                    break
                }

                New-UseCase -rawName $name -context $context
            }
            default {
                Write-Host "[X] Tipo invalido. Use: use-case ou uc." -ForegroundColor Red
            }
        }
    }
    default {
        Write-Host "[X] Comando invalido. Use: generate ou g." -ForegroundColor Red
    }
}
