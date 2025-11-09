#!/bin/bash

SCANNER="./scanner"
# O nome do arquivo que vai guardar os resultados
RESULTS_FILE="test_results.txt"
# O diretório onde estão seus exemplos
EXAMPLES_DIR="program_examples"

# Cores para o terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# -------------------------------------------------

# Limpa o arquivo de resultados antigos
> "$RESULTS_FILE"

echo "Rodando todos os testes..."

# Contadores para o resumo
SUCCESS_COUNT=0
ERROR_COUNT=0

# Para cada arquivo que termina em .c4 dentro do diretório...
for file in "$EXAMPLES_DIR"/*.c4; do
    
    # Imprime um cabeçalho no arquivo de resultados
    echo "========================================" >> "$RESULTS_FILE"
    echo "INPUT: $file" >> "$RESULTS_FILE"
    echo "----------------------------------------" >> "$RESULTS_FILE"
    
    # Executa o scanner, anexando TANTO a saída padrão QUANTO a de erro no arquivo
    "$SCANNER" < "$file" >> "$RESULTS_FILE" 2>&1
    
    if [ $? -eq 0 ]; then
        # Se $? for 0, o comando teve SUCESSO
        echo -e "Teste $file ... ${GREEN}SUCCESS${NC}"
        echo "----------------------------------------" >> "$RESULTS_FILE"
        echo "STATUS: SUCCESS" >> "$RESULTS_FILE"
        echo "" >> "$RESULTS_FILE"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        # Se $? for diferente de 0, o comando deu ERRO
        echo -e "Teste $file ... ${RED}ERROR${NC}"
        echo "----------------------------------------" >> "$RESULTS_FILE"
        echo "STATUS: ERROR" >> "$RESULTS_FILE"
        echo "" >> "$RESULTS_FILE"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
    
done

echo "----------------------------------------"
echo "Pronto! Todos os resultados estão em: $RESULTS_FILE"
echo -e "Resumo: ${GREEN}$SUCCESS_COUNT testes passaram${NC}, ${RED}$ERROR_COUNT testes falharam${NC}."