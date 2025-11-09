# 💻 Lexer para Linguagem C4

[![Feito com Haskell](https://img.shields.io/badge/Feito%20com-Haskell-blue?style=for-the-badge&logo=haskell)](https://www.haskell.org/)

Este projeto é um **Analisador Léxico (Scanner)** para uma linguagem de programação customizada (`.c4`), desenvolvido com **Alex** e **Haskell**.

É parte do trabalho avaliativo da disciplina de Linguagens de Programação: Conceitos e Paradigmas.

---

## 🚀 Características

* **Scanner completo** feito em Alex, compilado em Haskell.
* **Reconhecimento** de keywords, operadores (`::`, `->`, `&&`), literais (`"string"`), e IDs.
* **Separação** de `Id` (ex: `minhaVar`) e `TypeId` (ex: `MeuStruct`).
* **Script de teste** automatizado (`run_tests.sh`) que valida todos os exemplos.

---

## ⚙️ Como executar

### 1. Compilar o Scanner

Primeiro, você precisa do **Alex** e do compilador **GHC** (Haskell) instalados.

1.  **Gere o parser** (com Alex):
    ```sh
    alex tokens.x
    ```

2.  **Compile o scanner** (com GHC):
    ```sh
    ghc -o scanner tokens.hs
    ```

### 2. Rodar os Testes

Após compilar o executável `scanner`, rode o script de teste:

```sh
./run_tests.sh
```
Isso irá executar o scanner em todos os arquivos da pasta program_examples/ e gerar um test_results.txt com o status (SUCCESS ou ERROR) e a saída de cada teste.

---

### 🧠 Exemplo de Saída

**Entrada (`program_examples/exemplo.c4`)**
```c
fn int main() {
  if (x > 10) {
    return 0;
  }
}
```
**Saída (em `test_results.txt`)**
```text
========================================
INPUT: program_examples/exemplo.c4
----------------------------------------
[Function,Type "int",Id "main",BeginParentheses,EndParentheses,BeginBrace,
If,BeginParentheses,Id "x",Greater,IntLit 10,EndParentheses,BeginBrace,
Return,IntLit 0,SemiColon,EndBrace,EndBrace]
----------------------------------------
STATUS: SUCCESS
```
---

### 📚 Estrutura do Repositório

* **`tokens.x`**: O arquivo-fonte do Alex, onde todos os tokens são definidos.
* **`run_tests.sh`**: O script de teste que automatiza a verificação.
* **`program_examples/`**: Pasta com todos os arquivos de teste `.c4` (bons e ruins).
* **`.gitignore`**: Ignora arquivos gerados (`.o`, `.hi`, `scanner`, `tokens.hs`) e o resultado dos testes.
