#!/usr/bin/env bash

docker build --tag=rf .
docker tag rf 770171891064.dkr.ecr.us-east-1.amazonaws.com/random-forest
docker push 770171891064.dkr.ecr.us-east-1.amazonaws.com/random-forest
