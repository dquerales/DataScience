#required lib
#from crypt import methods
import numpy as np
from flask import Flask, request, jsonify
import pickle

#flask app
app = Flask(__name__)

#load model
model = pickle.load(open('model.pkl', 'rb'))

#app route
@app.route('/api', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    prediction = model.predict(data["X"])
    output_text = "Text:" + str(data["X"])
    output = "Class: " + str(prediction)
    return jsonify(output_text, output)

if __name__ == '__main__':
    app.run(port=8080, debug=True)