from server.customModules import sendToTelegram, verifyRequestSignature
from flask_restful import Resource
from dotenv import load_dotenv
from server import api, app
from flask import request
import subprocess
import requests
import os


load_dotenv()

chatids = os.getenv('chatID', '').split(',')
webhook_secret = os.getenv('GITHUB_WEBHOOK_SECRET')

class pull(Resource):

    def post(self):
        
        try:

            # Get the GitHub Webhook signature header
            signature_header = request.headers.get('X-Hub-Signature-256')
            
            # Read the raw request data
            payload_body = request.data.decode('utf-8')

            # Verify the GitHub Webhook payload
            verifyRequestSignature(payload_body, webhook_secret, signature_header)
            
            command = "cd ~/industrial-IOT && git pull"
            result = subprocess.run(command, shell=True, capture_output=True, text=True)
            
            if not result.returncode:

                return 200
            
            errorMsg = f"Git pull encountered an error:\n{result.stderr}"
            
            for chatid in chatids:

                sendToTelegram(chatid, errorMsg)

            return result.stderr
        
        except Exception as e :

            errorMsg = f"An unauthorized client made a request to your termux webhook and error is:\n{e}"
            
            for chatid in chatids:

                sendToTelegram(chatid, errorMsg)
                
            return str(e), 403

api.add_resource(pull, '/api/pull')
