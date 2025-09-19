# Stage 1: build the application
FROM node:20-alpine AS builder

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de definição de pacotes da subpasta 'linkedin-post'
COPY linkedin-post/package*.json ./

# Instala as dependências
RUN npm install

# Copia todo o código-fonte da aplicação da subpasta 'linkedin-post'
COPY linkedin-post/ .

# Executa o build da aplicação
RUN npm run build

# Stage 2: serve os arquivos estáticos em um contêiner leve
FROM node:20-alpine AS runner

WORKDIR /app
# Instala um servidor de arquivos estáticos simples
RUN npm install -g serve

# Copia os arquivos compilados do estágio anterior
COPY --from=builder /app/dist ./dist

# Copia o entrypoint script e concede permissão de execução
COPY --from=builder /app/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Expõe a porta (o Coolify fará o mapeamento automaticamente)
EXPOSE 3000

# Define o comando de entrada para iniciar o servidor
ENTRYPOINT ["./entrypoint.sh"]