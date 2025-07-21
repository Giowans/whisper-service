# ===========================
# Builder Stage
# ===========================
FROM ubuntu:22.04 as builder

RUN apt-get update && \
    apt-get install -y build-essential cmake curl ffmpeg

WORKDIR /app

COPY . .

RUN mkdir -p models && \
    curl -L -o models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin

RUN make

# ===========================
# Runtime Stage
# ===========================
FROM python:3.11-slim

# Instala solo ffmpeg, curl y dependencias mínimas
RUN apt-get update && apt-get install -y ffmpeg curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia solo el binario compilado y el modelo
COPY --from=builder /app/main /app/main
COPY --from=builder /app/models /app/models
COPY server.py requirements.txt ./

RUN pip install -r requirements.txt

EXPOSE 8080

CMD ["python3", "server.py"]

