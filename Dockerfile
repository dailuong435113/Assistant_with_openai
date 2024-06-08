# Sử dụng image chính thức của Python
FROM python:3.9-slim

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép file requirements.txt vào container
COPY requirements.txt requirements.txt

# Cài đặt các dependencies từ requirements.txt
RUN pip install -r requirements.txt

# Sao chép toàn bộ nội dung của thư mục hiện tại vào container
COPY . .

# Chạy ứng dụng với Streamlit
CMD ["streamlit", "run", "openai-assistant-api/app.py", "--server.port=8501", "--server.address=0.0.0.0"]
