FROM python:3.10-slim

RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY whisper-service/ /app
WORKDIR /app

EXPOSE 8000

CMD ["python", "server.py"]
