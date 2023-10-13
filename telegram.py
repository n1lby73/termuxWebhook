#!/usr/bin/env python3

from server.customModules import sendToTelegram
from dotenv import load_dotenv
import sys
import os


load_dotenv()

chatids = os.getenv('chatID', '').split(',')

if len(sys.argv) != 3:

    print("Usage: telegram.py <Webhook URL> <IIOT Server URL>")

    sys.exit(1)

webhook_url = sys.argv[1]
iiot_url = sys.argv[2]

message = f"Android reboot detected\nServices started. New URLs:\nWebhook - {webhook_url}\nIIOT - {iiot_url}"

for chatid in chatids:

    sendToTelegram(chatid, message)