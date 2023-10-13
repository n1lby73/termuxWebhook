from werkzeug.exceptions import Forbidden
from dotenv import load_dotenv
import requests
import hashlib
import hmac
import os

load_dotenv()

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


def verifyRequestSignature(payload_body, secret_token, signature_header):

    if not signature_header:

        raise Forbidden("x-hub-signature-256 header is missing")

    hash_object = hmac.new(secret_token.encode('utf-8'), msg=payload_body.encode('utf-8'), digestmod=hashlib.sha256)

    expected_signature = "sha256=" + hash_object.hexdigest()

    if not hmac.compare_digest(expected_signature, signature_header):

        raise Forbidden("Request signatures didn't match")
