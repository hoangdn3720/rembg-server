FROM python:3.11-slim

# Install system dependencies for onnx and pillow
RUN apt-get update && apt-get install -y libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*

# Install rembg with CLI extras and necessary dependencies
RUN pip install --no-cache-dir "rembg[cli]" onnxruntime click filetype

# Install FastAPI server dependencies
RUN pip install --no-cache-dir fastapi "uvicorn[standard]" python-multipart requests

# Set default port
ENV PORT=7000
EXPOSE 7000

# Copy the FastAPI application
COPY app.py /app.py

# Start the FastAPI server with uvicorn, using PORT env var if set
CMD ["sh","-c","uvicorn app:app --host 0.0.0.0 --port ${PORT:-7000}"]
