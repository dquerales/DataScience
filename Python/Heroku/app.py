#required lib
from flask import Flask, request, render_template, jsonify
import pickle
import numpy as np

#flask app
app = Flask(__name__)

#load model
model = pickle.load(open('model.pkl', 'rb'))

#render template
@app.route('/')
def home():
    return render_template("home.html")

#api route
@app.route('/api',methods=['POST'])
def predict():
    data = request.form.values()
    print(data)
    #data = request.get_json(force=True)
    prediction = model.predict(data)
    output_text = "Text:" + str(request.values['Review'])
    output = "Class: " + str(prediction)
    return jsonify(output_text, output)

if __name__ == '__main__':
    app.run(debug=True)