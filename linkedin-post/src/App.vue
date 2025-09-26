<!-- src/App.vue -->
<template>
  <div class="container">
    <h1>Publicar Post Linkedin</h1>

    <!-- Campo de texto para o tema -->
    <div class="form-group">
      <label for="tema">Tema:</label>
      <input type="text" id="tema" v-model="tema" />
    </div>

    <!-- Botão que aciona o método savePost -->
    <button class="primary" @click="savePost">Salvar</button>
  </div>
</template>

<script setup>
/* ------------------------------------------------------------------
  Importações e variáveis reativas
------------------------------------------------------------------ */
import { ref } from 'vue'
import axios from 'axios' // Usado para chamar a API Postagem

 // Armazena o valor do campo "Tema"
const tema = ref('')

// Recebe diretamente a URL da API do .env
const apiUrl = `${import.meta.env.VITE_API_URL}/Postagem`

/* ------------------------------------------------------------------
  Função savePost:
  1. Valida se o campo tema foi preenchido
  2. Envia requisição POST para apiUrl
  3. Exibe mensagens de sucesso ou erro
------------------------------------------------------------------ */
const savePost = async () => {
  // Validação simples
  if (tema.value.trim() === '') {
    alert('O campo Tema é obrigatório.')
    return
  }

  console.log('Tema do post:', tema.value)

  try {
    // Chamada à API (método POST) usando a URL configurada
    const response = await axios.post(apiUrl, { tema: tema.value }, {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      // Configurações para lidar com HTTPS local
      httpsAgent: false,
      timeout: 10000
    })

    console.log('Resposta da API:', response.data)
    alert('Post salvo com sucesso! Tema: ' + tema.value)

    // Limpa o campo após sucesso
    tema.value = ''

  } catch (err) {
    console.error('Erro ao salvar o post:', err)

    // Tratamento específico para diferentes tipos de erro
    if (err.code === 'ERR_NETWORK' || (err.message && err.message.includes('CORS'))) {
      alert('Erro de CORS: A API precisa permitir requisições do frontend.\n\nSoluções:\n1. Configure CORS no backend\n2. Use um proxy\n3. Desabilite CORS no navegador (apenas para desenvolvimento)')
    } else if (err.response) {
      // Erro da API (4xx, 5xx)
      const status = err.response.status
      const statusText = err.response.statusText || ''
      const dataMessage = err.response.data && err.response.data.message ? ` - ${err.response.data.message}` : ''
      alert(`Erro da API: ${status} - ${statusText}${dataMessage}`)
    } else {
      // Outros erros
      alert('Erro ao salvar o post. Verifique o console para mais detalhes.')
    }
  }
}
</script>

<style scoped>
/* ------------------------------------------------------------------
  Estilos:
  - Centraliza verticalmente o conteúdo
  - Espaçamento de 8 px entre elementos
  - Largura máxima de 400 px
------------------------------------------------------------------ */
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 20px;
  max-width: 400px;
  margin: 0 auto;
}

.form-group {
  margin-bottom: 8px;
  width: 100%;
}

label {
  display: block;
  margin-bottom: 4px;
}

input[type='text'] {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

button.primary {
  background-color: #007bff;
  color: #fff;
  padding: 10px 16px;
  border: none;
  cursor: pointer;
}

button.primary:hover {
  background-color: #0056b3;
}
</style>
