from werkzeug.exceptions import Forbidden
from flask_restful import Resource
from dotenv import load_dotenv
from server import api, app
from flask import request
import subprocess
import requests
import hashlib
import hmac
import os


load_dotenv()

chatids = os.getenv('chatID', '').split(',')
# webhook_secret = os.getenv('GITHUB_WEBHOOK_SECRET')
webhook_secret = "mehniambroke"
def verify_signature(payload_body, secret_token, signature_header):

    if not signature_header:

        raise Forbidden("x-hub-signature-256 header is missing")

    hash_object = hmac.new(secret_token.encode('utf-8'), msg=payload_body.encode('utf-8'), digestmod=hashlib.sha256)

    expected_signature = "sha256=" + hash_object.hexdigest()

    if not hmac.compare_digest(expected_signature, signature_header):

        raise Forbidden("Request signatures didn't match")

def sendToTelegram(chatid, message):

    try:

        apiToken = os.getenv('botToken')

        chatID = chatid

        payload = {'chat_id': chatID, 'text': message}
        
        apiURL = f'https://api.telegram.org/bot{apiToken}/sendMessage'

        response = requests.post(apiURL, data=payload)

        if response.status_code == 200:

            print("Message sent successfully!")

        else:

            print(f"Failed to send message: {response.text}")
            
    except Exception as e:

        print(e)

class push(Resource):

    def post(self):
        
        try:

            # Get the GitHub Webhook signature header
            signature_header = request.headers.get('X-Hub-Signature-256')
            
            # Read the raw request data
            payload_body = request.data.decode('utf-8')
            
            # Verify the GitHub Webhook payload
            verify_signature(payload_body, webhook_secret, signature_header)
            
            command = "cd ~/industrial-IOT && git pull"
            result = subprocess.run(command, shell=True, capture_output=True, text=True)
            
            if not result.returncode:

                return 200
            
            errorMsg = f"Git pull encountered an error:\n{result.stderr}"
            
            for chatid in chatids:

                sendToTelegram(chatid, errorMsg)

            return result.stderr
        
        except Exception as e :

            errorMsg = "An unauthorized client made a request to your termux webhook"
            
            for chatid in chatids:

                sendToTelegram(chatid, errorMsg)
                
            return str(e), 403

api.add_resource(push, '/api/push')