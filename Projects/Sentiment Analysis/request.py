#required lib
import requests

#request to api
url = 'http://localhost:8080/api'
r = requests.post(url, json={'X': ['I love Star Wars']})

#result
print(r.json())