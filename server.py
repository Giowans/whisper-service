from flask import Flask, request, jsonify
import subprocess
import os

app = Flask(__name__)

@app.route('/transcribe', methods=['POST'])
def transcribe():
    if 'file' not in request.files:
        return jsonify({'error': 'No file'}), 400

    audio = request.files['file']
    audio.save('audio.mp3')

    result = subprocess.run(
        ['./main', '-m', 'models/ggml-tiny.bin', '-f', 'audio.mp3', '-otxt'],
        capture_output=True,
        text=True
    )

    transcript = ''
    with open('audio.mp3.txt', 'r') as f:
        transcript = f.read()

    return jsonify({'text': transcript})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

