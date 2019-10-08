#!/usr/bin/env bash
docker build -t mlc .
docker run --rm -d -v $(pwd)/local_test:/opt/ml mlc train
docker run --rm -d -p 127.0.0.1:8080:8080 -v $(pwd)/local_test:/opt/ml mlc serve
