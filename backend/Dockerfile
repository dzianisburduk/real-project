FROM python:3.11-slim

WORKDIR /app

# Нам больше не нужны gcc и libpq-dev, так как psycopg2-binary ставится сам!
RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 \
    nmap \
    tcpdump \
    traceroute \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]