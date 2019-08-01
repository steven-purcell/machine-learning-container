# This is the predictor for outputting batch inferences. This does not need to be changed unless there is custom
#   inference code that needs to be implemented.

from __future__ import print_function

import os
import pickle
from io import StringIO
import logging
import flask
import pandas as pd

prefix = '/opt/ml/'
model_path = os.path.join(prefix, 'model')

# A singleton for holding the model. This simply loads the model and holds it.
# It has a predict function that does a prediction based on the model and the input data.

class ScoringService(object):
    model = None                # Where we keep the model when it's loaded

    @classmethod
    def get_model(cls):
        # Get the model object for this instance, loading it if it's not already loaded.
        if cls.model == None:
            with open(os.path.join(model_path, 'model.pkl'), 'rb') as inp:
                cls.model = pickle.load(inp)
        return cls.model

    @classmethod
    def predict(cls, input):
        """For the input, do the predictions and return them.

        Args:
            input (a pandas dataframe): The data on which to do the predictions. There will be
                one prediction per row in the dataframe"""
        clf = cls.get_model()
        return clf.predict(input)

# The flask app for serving predictions
app = flask.Flask(__name__)

@app.route('/ping', methods=['GET'])
def ping():
    # Check if model exists as health check. Continue if 200.
    health = ScoringService.get_model() is not None

    status = 200 if health else 404
    return flask.Response(response='\n', status=status, mimetype='application/json')

@app.route('/invocations', methods=['POST'])
def transformation():
    # Do an inference on a single batch of data.
    data = None

    # Convert from CSV to pandas
    try:
        request = flask.request.data
        data = str(request, 'utf-8')
        s = StringIO(data)
        data = pd.read_csv(s, header=None)
    except Exception as e:
        logging.exception(e)

    print('Invoked with {} records'.format(data.shape[0]))

    # Do the prediction
    predictions = ScoringService.predict(data)

    # Convert from numpy back to CSV
    out = StringIO()
    pd.DataFrame({'results':predictions}).to_csv(out, header=False, index=False)
    result = out.getvalue()

    return flask.Response(response=result, status=200, mimetype='text/csv')
