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
