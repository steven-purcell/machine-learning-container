# machine-learning-container
A multi-purpose machine learning and artificial intelligence Docker container set up to run with AWS sagemaker.

## Install Dependencies
1. Install and start docker

## To Test Locally
1. Add Training data by replacing `./local_test/input/data/train/training_data.csv` with your training data CSV(s)
2. Replace `./local_test/payload.csv` with data to test your model with. (Could be test data or data to score)
3. Run
    ```shell script
    sh local_build_train_serve.sh
    ```
4. Open up a new terminal and run (You can run your model against any csv you specify in this call)
    ```shell script
    sh local_test/predict.sh localhost:8080 local_test/payload.csv text/csv
    ```
5. You should now have your model results returned to you.

#### Note
Any errors when scoring should be sent to `./local_test/output/failure`

## A Deeper Look

#### Build Container
```shell script
docker build -t mlc .
```

#### Train
```shell script
docker run --rm -v $(pwd)/local_test:/opt/ml mlc train
```

#### Serve
```shell script
docker run --rm -p 127.0.0.1:8080:8080 -v $(pwd)/local_test:/opt/ml mlc serve
```

#### Check if container is serving
```shell script
curl http://localhost:8080/ping
```

#### Build and run (All of the above commands)
```shell script
sh local_build_train_serve.sh
```

#### Score
```shell script
sh local_test/predict.sh localhost:8080 local_test/payload.csv text/csv
```
