FROM python:3.6-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         nginx \
         ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/
RUN pip3 install --requirement /tmp/requirements.txt

# Install Python 3 packages
RUN pip3 install \
    'flask>=1.1.1' \
    'werkzeug>=0.16.0' \
    'gevent>=1.4.0' \
    'gunicorn>=19.9.0' \
    'Jinja2>=2.10.1'

ENV AWS_DEFAULT_REGION=us-gov-west-1
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

COPY model /opt/program
WORKDIR /opt/program
