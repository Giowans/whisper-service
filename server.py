from fastapi import FastAPI, File, UploadFile
import whisper

app = FastAPI()
model = whisper.load_model("base")  # Usa tiny/base/medium/large
port = int(os.environ.get("PORT", 8000))

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    contents = await file.read()
    with open("temp_audio.wav", "wb") as f:
        f.write(contents)

    result = model.transcribe("temp_audio.wav")
    return {"text": result["text"]}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=port)
