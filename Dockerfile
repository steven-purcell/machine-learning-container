FROM python:3.7-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         python3.5 \
         nginx \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip install numpy scipy pandas sklearn flask gevent gunicorn && \
    pyod kmodes tensorflow torch

ENV AWS_DEFAULT_REGION=us-gov-west-1
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/ml:${PATH}"

COPY model /opt/ml
WORKDIR /opt/ml