FROM python:alpine

RUN echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Add HDF5 support
RUN apk add --no-cache --allow-untrusted --repository http://dl-3.alpinelinux.org/alpine/edge/testing hdf5 hdf5-dev
RUN apk --no-cache --update-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev openblas-dev
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install numpy scipy pandas sklearn flask gevent gunicorn pyod kmodes

ENV AWS_DEFAULT_REGION=us-gov-west-1
ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/ml:${PATH}"

COPY model /opt/ml
WORKDIR /opt/ml
