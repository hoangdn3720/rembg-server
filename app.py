import io
import os

import requests
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from rembg import remove, new_session

# Create rembg session with a small model (u2netp) to reduce memory usage
MODEL_NAME = os.getenv("REMBG_MODEL", "u2net")
session = new_session(MODEL_NAME)
app = FastAPI()

# Enable CORS for all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/remove")
async def remove_bg(file: UploadFile = File(...)):
    contents = await file.read()
    result = remove(contents, session=session)
    return StreamingResponse(io.BytesIO(result), media_type="image/png")

@app.get("/api/remove")
async def remove_bg_from_url(url: str):
    response = requests.get(url)
    response.raise_for_status()
    result = remove(response.content, session=session)
    return StreamingResponse(io.BytesIO(result), media_type="image/png")

@app.get("/")
def read_root():
    return {"message": "Rembg API wrapper is running. Visit /api/remove for endpoints."}
