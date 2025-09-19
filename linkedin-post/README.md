# LinkedIn Post - Projeto Vue.js

## Problema de CORS Identificado

O erro que você está vendo é um problema comum de CORS (Cross-Origin Resource Sharing). Aqui estão as soluções:

## Soluções para o Erro de CORS

### 1. **Solução Recomendada: Configurar CORS no Backend**
O backend em `https://localhost:32769` precisa permitir requisições do frontend. Adicione os headers CORS:

```
Access-Control-Allow-Origin: http://localhost:5173
Access-Control-Allow-Methods: POST, GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, Accept
```

### 2. **Solução Temporária: Usar Proxy do Vite**
Já configurei um proxy no `vite.config.js`. Para usar:

1. No arquivo `src/App.vue`, altere a linha 37:
```javascript
// De:
const apiUrl = API_TEST_URL

// Para:
const apiUrl = API_PROXY_URL
```

2. Reinicie o servidor de desenvolvimento:
```bash
npm run dev
```

### 3. **Solução para Desenvolvimento: Desabilitar CORS no Chrome**
⚠️ **Apenas para desenvolvimento!**

Feche o Chrome completamente e abra com:
```bash
# Windows
chrome.exe --user-data-dir=/tmp/foo --disable-web-security

# Mac
open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security

# Linux
google-chrome --disable-web-security --user-data-dir="/tmp/chrome_dev_test"
```

## Como Rodar o Projeto

1. Instalar dependências:
```bash
npm install
npm install axios
```

2. Iniciar o servidor de desenvolvimento:
```bash
npm run dev
```

3. Acessar: `http://localhost:5173`

## Estrutura do Projeto

- `src/App.vue` - Componente principal com formulário
- `vite.config.js` - Configuração do Vite com proxy para CORS
- URLs configuradas:
  - Teste: `https://localhost:32769/Postagem`
  - Proxy: `/api/Postagem` (recomendado para desenvolvimento)
  - Produção: placeholder para URL real

## Testando a API

Para testar se a API está funcionando, você pode usar curl:

```bash
curl -X POST https://localhost:32769/Postagem \
  -H "Content-Type: application/json" \
  -d '{"tema": "Teste"}' \
  -k
```

Se retornar erro de CORS, o problema está no backend que precisa configurar os headers CORS.