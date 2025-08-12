FROM n8nio/n8n:latest

USER root

# Instalar dependências essenciais
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    git \
    curl \
    build-base \
    && rm -rf /var/cache/apk/*

# Instalar Whisper com configurações robustas
RUN pip3 install --no-cache-dir \
    --timeout=1000 \
    --break-system-packages \
    openai-whisper \
    torch \
    torchaudio

# Criar diretórios com permissões corretas
RUN mkdir -p /tmp/audio /tmp/whisper /home/node/.n8n/custom
RUN chmod 777 /tmp/audio /tmp/whisper
RUN chown -R node:node /home/node/.n8n /tmp/audio /tmp/whisper

# Limpeza para otimizar tamanho
RUN apk del build-base
RUN pip3 cache purge

USER node

# Environment variables
ENV N8N_DISABLE_PRODUCTION_MAIN_PROCESS=false
ENV WHISPER_CACHE_DIR=/tmp/whisper
ENV N8N_RUNNERS_ENABLED=true

CMD ["n8n", "start"]
