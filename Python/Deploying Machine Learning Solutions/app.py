#required lib
from flask import Flask

#flask app
app = Flask(__name__)

#app route
@app.route("/")
def home():
    return "Hello, Flask!"

if __name__ == '__main__':
    app.run(port=8080, debug=True)