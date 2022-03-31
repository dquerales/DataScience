#required lib
from flask import Flask, request, url_for, redirect, render_template, jsonify
import pandas as pd
import pickle
import numpy as np

#flask app
app = Flask(__name__)

#load model
model = pickle.load(open('model.pkl', 'rb'))

#app_route
@app.route('/')
def home():
    return render_template("home.html")

@app.route('/api', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    prediction = model.predict(data["X"])
    output_text = "Text:" + str(data["X"])
    output = "Class: " + str(prediction)
    return jsonify(output_text, output)

if __name__ == '__main__':
    app.run(port=8080, debug=True)