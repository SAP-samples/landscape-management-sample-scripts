import os
import json
import requests
from flask import Flask, request

app = Flask(__name__)
port = int(os.environ.get('PORT', 3000))

stored_payload = None
teams_webhook_url = '<URL for MS Teams Webhook>'

@app.route('/', methods=['GET', 'POST'])
def receive_post():
    global stored_payload

    if request.method == 'POST':
        try:
            stored_payload = request.get_json()  # Store the JSON payload from LaMa Cloud
            send_to_teams(stored_payload)  # Send the payload to Microsoft Teams
            return 'Success'  # Send a response indicating successful processing
        except Exception as e:
            return 'Error: {}'.format(str(e)), 400  # Send an error response if there was an issue
    else:
        if stored_payload:
            response = json.dumps(stored_payload, indent=2, separators=(',', ': '))
            return response.replace('\n', '<br>')  # Replace newlines with HTML line breaks for browser display
        else:
            return 'No JSON payload to show', 404  # Send a not found response if no payload is available

def send_to_teams(payload):
    headers = {'Content-Type': 'application/json'}
    data = {
        'text': 'LaMa Cloud JSON Payload:\n\n' + json.dumps(payload, indent=2)
    }
    response = requests.post(teams_webhook_url, headers=headers, json=data, verify=False)

    if response.status_code != 200:
        raise Exception('Failed to send payload to Teams. Status Code: {}'.format(response.status_code))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)