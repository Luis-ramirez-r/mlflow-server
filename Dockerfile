FROM python:3.9-slim

WORKDIR /mlflow

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    mlflow==2.10.0 \
    gunicorn

RUN mkdir -p /mlflow/artifacts && \
    mkdir -p /mlflow/mlruns && \
    touch /mlflow/mlflow.db && \
    chmod -R 777 /mlflow

EXPOSE 5000

CMD ["mlflow", "server", \
     "--host", "0.0.0.0", \
     "--port", "5000", \
     "--backend-store-uri", "sqlite:///mlflow.db", \
     "--default-artifact-root", "/mlflow/artifacts", \
     "--workers", "4"]
