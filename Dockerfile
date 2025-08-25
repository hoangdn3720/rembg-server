FROM python:3.11-slim




# Thư viện hệ thống cần cho onnx/pillow
RUN apt-get update && apt-get install -y libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*

# Cài rembg (có CLI/server)
RUN pip install --no-cache-dir rembg

# Railway gán biến PORT tự động, dùng lại biến này
ENV PORT=7000
EXPOSE 7000


# Chạy HTTP server của rembg
CMD ["sh","-c","rembg s --host 0.0.0.0 --port ${PORT} --log_level info"]
RUN pip install --no-cache-dir onnxruntime
CMD ["sh","-cpmbg s --host 0.0.0.0 --port ${PORT} --log_level info"]

RUN pip install --no-cache-dir click
CMD ["sh","-c","rembg s --host 0.0.0.0 --port ${PORT} --log_level info"]

RUN pip install --no-cache-dir filetype
RUN pip install --no-cache-dir "rembg[cli]"
CMD ["sh","-c","rembg s --host 0.0.0.0 --port ${PORT} --log_level info"]
CMD ["sh","-c","rembg s --host 0.0.0.0 --port $PORT --log_level info"]

CMD 
["sh","-c","rembg s --host 0.0.0.0 --port 7000 --log_level info"]

# Install dependencies for FastAPI wrapper and requests
RUN pip install --no-cache-dir fastapi "uvicorn[standard]" python-multipart requests
# Copy the FastAPI app into the container
COPY app.py /app.py
# Start the FastAPI server with uvicorn, using PORT env var or default to 7000
CMD ["sh","-c","uvicorn app:app --host 0.0.0.0 --port ${PORT:-7000}"]

# Overwrite rembg CLI to start FastAPI wrapper
RUN printf '#!/bin/sh\nuvicorn app:app --host 0.0.0.0 --port ${PORT:-7000}\n' > /usr/local/bin/rembg && chmod +x /usr/local/bin/rembg
