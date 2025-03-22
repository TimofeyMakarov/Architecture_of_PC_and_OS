FROM python:latest
COPY app.py /app/
COPY requirements.txt /app/
WORKDIR /app/
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "-u", "app.py"]
