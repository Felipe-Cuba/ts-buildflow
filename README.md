# Dev CLI - Gerador de Use Cases em PowerShell

Este script (`dev.ps1`) permite gerar boilerplate de use-cases em projetos Node.js com estrutura padrão. Ele pode ser executado de qualquer lugar do terminal com um comando curto, como `dev`.

---

## ✅ Requisitos

- PowerShell instalado (incluso no Windows)
- Git Bash, PowerShell ou Terminal com suporte a `.cmd`
- Permissão para editar variáveis de ambiente do usuário

---

## 🚀 Instalação

### 1. Criar a pasta de scripts

Crie uma pasta pessoal para armazenar scripts globais (se ainda não existir):

```powershell
New-Item -ItemType Directory -Path "$HOME\scripts" -Force
```

### 2. Copiar os arquivos do repositório

Baixe ou clone este repositório, e **cole os arquivos `dev.ps1` e `dev.cmd`** na pasta:

```
C:\Users\SeuUsuario\scripts
```

> Essa pasta será usada para tornar o comando acessível globalmente no terminal.

### 3. Adicionar a pasta ao PATH

Execute no PowerShell:

```powershell
[Environment]::SetEnvironmentVariable(
  "Path",
  $Env:Path + ";$HOME\scripts",
  [EnvironmentVariableTarget]::User
)
```

Feche e reabra o terminal para que o sistema reconheça o novo comando.

---

## 🧪 Verificar instalação

Execute:

```powershell
Get-Command dev
```

Se o comando retornar o caminho para `dev.cmd`, o CLI está instalado corretamente.

---

## 🛠️ Uso

### 📌 Sintaxe

```bash
dev g uc <nome-do-use-case> [contexto]
```

### 📍 Parâmetros

| Parâmetro         | Descrição                                                                 |
|------------------|---------------------------------------------------------------------------|
| `g` / `generate` | Comando principal                                                         |
| `uc`             | Tipo de geração: use-case                                                 |
| `nome`           | Nome do use-case (`create-order`, `CreateOrder`, etc.)                    |
| `[contexto]`     | (Opcional) Nome do subdiretório onde está o diretório `use-cases`         |

---

## 🧾 Exemplo

### Estrutura do projeto:

```
panel/
└── users/
    └── use-cases/
```

### Gerar use-case no contexto `users`:

```bash
dev g uc create-user users
```

### Gerar use-case no diretório atual:

```bash
cd users
dev g uc create-user
```

---

## 📂 O que é gerado

Para `create-users`, serão criados os arquivos abaixo:

```
createUsers/
├── createUsersUseCase.ts
├── createUsersValidation.ts
└── index.ts
```

Com conteúdo boilerplate incluindo classe, validação com Zod e handler Express.

---

## ❗ Possíveis erros

- **[ERRO] Nenhum diretório 'use-cases' encontrado...**
  - Solução: Verifique se está no caminho correto ou informe o `[contexto]`.

- **[ERRO] Tipo inválido ou comando inválido**
  - Solução: Use `dev g uc nome` corretamente.

