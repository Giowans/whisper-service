FROM ubuntu:22.04

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y build-essential cmake curl ffmpeg python3 python3-pip

# Copiar código
WORKDIR /app
COPY . .

# Descargar modelo tiny por defecto
RUN mkdir -p models && \
    curl -L -o models/ggml-tiny.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin

# Construir whisper.cpp
RUN make

# Instalar Flask para el servidor HTTP
RUN pip3 install -r requirements.txt

# Puerto expuesto por el microservicio
EXPOSE 8080

# Comando de inicio
CMD ["python3", "server.py"]

