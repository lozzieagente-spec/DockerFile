FROM n8nio/n8n:latest

USER root

# Instalar dependências essenciais
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    git \
    curl \
    build-base

# Instalar Whisper
RUN pip3 install --no-cache-dir \
    openai-whisper \
    torch \
    torchaudio \
    --timeout=1000

# Configurar diretórios
RUN mkdir -p /tmp/audio /home/node/.n8n/custom
RUN chmod 777 /tmp/audio
RUN chown -R node:node /home/node/.n8n

# Otimizações
RUN apk del build-base
RUN pip3 cache purge

USER node

# Variáveis de ambiente
ENV N8N_DISABLE_PRODUCTION_MAIN_PROCESS=false
ENV WHISPER_CACHE_DIR=/tmp/whisper

CMD ["n8n", "start"]
