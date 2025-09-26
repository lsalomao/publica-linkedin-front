#!/bin/sh
# Entrypoint para VPS/Docker

set -e  # Para em caso de erro

echo "🚀 Iniciando aplicação LinkedIn Post..."
echo "📁 Verificando arquivos de build..."

# Verifica se o diretório dist existe
if [ ! -d "dist" ]; then
    echo "❌ Erro: Diretório 'dist' não encontrado!"
    exit 1
fi

echo "✅ Arquivos encontrados. Iniciando servidor..."

# Inicializa o servidor (serve front-end)
exec serve -s dist -l 3000 --cors
