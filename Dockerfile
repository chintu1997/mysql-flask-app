FROM python:3.8-slim

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y --no-install-recommends iputils-ping default-mysql-client && \
    pip install --no-cache-dir flask mysql-connector-python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m myuser
USER myuser

EXPOSE 8080

CMD ["python", "app.py"]
