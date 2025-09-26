# Stage 1: Build da aplicação
FROM node:20-alpine AS builder

# Allow passing the VITE_API_URL build argument so Vite can pick it up at build time
ARG VITE_API_URL=""

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de definição de pacotes da subpasta 'linkedin-post'
COPY linkedin-post/package*.json ./

# Instala as dependências
RUN npm install

# Copia todo o código-fonte da aplicação da subpasta 'linkedin-post'
COPY linkedin-post/ .

# Cria um arquivo .env.production que o Vite lê durante o build.
RUN if [ -n "$VITE_API_URL" ]; then \
      echo "VITE_API_URL=$VITE_API_URL" > .env.production; \
    else \
      echo "VITE_API_URL=http://localhost:3001" > .env.production; \
    fi

# Build da aplicação
RUN npm run build

# Stage 2: Servidor de produção
FROM node:20-alpine AS runner

# Cria usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

WORKDIR /app

# Instala um servidor de arquivos estáticos simples
RUN npm install -g serve@14

# Copia os arquivos compilados do estágio anterior
COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist

# Copia o entrypoint script e concede permissão de execução
COPY --from=builder --chown=nextjs:nodejs /app/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Muda para usuário não-root
USER nextjs

# Expõe a porta
EXPOSE 3000

# Health check para monitoramento
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Define o comando de entrada para iniciar o servidor
ENTRYPOINT ["./entrypoint.sh"]