FROM python:3.12-slim

WORKDIR /mlflow

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    mlflow[extras] \
    mlserver \
    mlserver-mlflow \
    gunicorn

# Create necessary directories and set permissions
RUN mkdir -p /mlflow/artifacts && \
    mkdir -p /mlflow/mlruns && \
    touch /mlflow/mlflow.db && \
    chmod -R 777 /mlflow

EXPOSE 5000

CMD ["mlflow", "server", \
    "--app-name", "basic-auth" \
     "--host", "0.0.0.0", \
     "--port", "5000", \
     "--backend-store-uri", "sqlite:///mlflow.db", \
     "--default-artifact-root", "/mlflow/artifacts", \
     "--workers", "4"]

