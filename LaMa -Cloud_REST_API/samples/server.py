import os
import requests
from flask import Flask, jsonify, request, render_template
import json
from tabulate import tabulate

app = Flask(__name__)
port = int(os.environ.get('PORT', 3000))

# OAuth 2 client configuration
client_id = "xx"
client_secret = "xx"
token_url = 'xx'
api_url = 'https://api.lama.cloud.sap/v1/systems'

# Get access token using client credentials
def get_access_token():
    payload = {
        'grant_type': 'client_credentials',
        'client_id': client_id,
        'client_secret': client_secret
    }
    response = requests.post(token_url, data=payload)
    access_token = response.json()['access_token']
    return access_token

# Recursive function to extract "name" entries from JSON data
def extract_names(data):
    names = []

    if isinstance(data, dict):
        if "group" in data:
            del data["group"]  # Exclude the "group" section

        for key, value in data.items():
            if key == "name":
                names.append(value)
            elif isinstance(value, (dict, list)):
                names.extend(extract_names(value))

    elif isinstance(data, list):
        for item in data:
            names.extend(extract_names(item))

    return names

@app.route("/")
def hello_world():
    return "Hello, World!"

@app.route('/api/v1/systems', methods=['GET'])
def get_data():
    access_token = get_access_token()
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json'
    }
    response = requests.get(api_url, headers=headers)
    data = response.json()
 
    names = extract_names(data)

    # Create a list of lists containing the names
    table_data = [[name] for name in names]

    # Generate the HTML table with borders
    table_html = tabulate(table_data, headers=["SYSTEMS"], tablefmt="html")

    # Render the template with the table
    return render_template('table.html', table_html=table_html)
        
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)