#!/data/data/com.termux/files/usr/bin/bash

# Paths to virtual environment activation scripts

webhook_venv="$HOME/termuxWebhook/termuxenv/bin/activate"
IIOT_venv="$HOME/industrial-IOT/web-ui/iitenv/bin/activate"

# Start the Webhook server locally

source $webhook_venv
cd $HOME/termuxWebhook

export FLASK_APP=run.py
export FLASK_DEBUG=True

flask run --port 4962

# Expose the server with Serveo for Webhook

portForwarding=$(ssh -R 80:localhost:4962 serveo.net)
webHookurl=$(echo "$portForwarding" | grep -o 'from [^ ]*' | awk '{print $2}')

echo "Webhook: $webHookurl"

# Start the IIOT server locally

source $IIOT_venv
cd $HOME/industrial-IOT/web-ui

export FLASK_APP=run.py
export FLASK_DEBUG=True

flask run --port 5000

# Expose the server with Serveo for IIOT

portForwarding=$(ssh -R 4962:localhost:5000 serveo.net)
IIOTurl=$(echo "$portForwarding" | grep -o 'from [^ ]*' | awk '{print $2}')

echo "IIOT server: $IIOTurl"

# Pass the URLs to a Python script

source $webhook_venv

pyhton ~/termuxWebhook/telegram.py "$webHookurl" "$IIOTurl"