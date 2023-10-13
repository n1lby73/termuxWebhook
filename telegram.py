#!/usr/bin/env python3

from server.customModules import sendToTelegram
from dotenv import load_dotenv
import sys
import os


load_dotenv()

chatids = os.getenv('chatID', '').split(',')

# def sendToTelegram(chatid, message):

#     try:

#         apiToken = os.getenv('botToken')

#         chatID = chatid

#         payload = {'chat_id': chatID, 'text': message}
        
#         apiURL = f'https://api.telegram.org/bot{apiToken}/sendMessage'

#         response = requests.post(apiURL, data=payload)

#         if response.status_code == 200:

#             print("Message sent successfully!")

#         else:

#             print(f"Failed to send message: {response.text}")
            
#     except Exception as e:

#         print(e)

if len(sys.argv) != 3:

    print("Usage: telegram.py <Webhook URL> <IIOT Server URL>")

    sys.exit(1)

webhook_url = sys.argv[1]
iiot_url = sys.argv[2]

message = f"Android reboot detected/nServices started. New URLs:\nWebhook - {webhook_url}\nIIOT - {iiot_url}"

for chatid in chatids:

    sendToTelegram(chatid, message)