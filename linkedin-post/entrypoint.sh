#!/bin/sh
# Entrypoint para Coolify (Docker)

# Aplique migrações ou outras rotinas se precisar aqui

# Inicializa o servidor (serve front-end)
exec serve -s dist -l 3000
