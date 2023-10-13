#!/data/data/com.termux/files/usr/bin/bash

# Function to activate a virtual environment or exit on failure

activate_venv() {

    local venv_path="$1"
    source "$venv_path" || { echo "Failed to activate virtual environment: $venv_path"; exit 1; }

}

# Function to run a Flask application in the background

run_flask_app_background() {
    
    local port="$1"
    nohup flask run --port "$port" &

    if [ $? -ne 0 ]; then

        echo "Failed to start Flask application on port $port"
        exit 1

    fi
}

# Function to expose a server with Serveo

expose_with_serveo() {

    local local_port="$1"
    local serveo_port="$2"

    local serveo_url=$(ssh -R "$serveo_port:localhost:$local_port" serveo.net)

    if [ $? -ne 0 ]; then

        echo "Failed to expose server on port $local_port with Serveo"
        exit 1

    fi

    echo "$serveo_url"
}

# Paths to virtual environment activation scripts

webhook_venv="$HOME/termuxWebhook/termuxenv/bin/activate"
IIOT_venv="$HOME/industrial-IOT/web-ui/iitenv/bin/activate"

# Start the Webhook server locally

activate_venv "$webhook_venv"

cd "$HOME/termuxWebhook"
export FLASK_APP=run.py
export FLASK_DEBUG=True

run_flask_app_background 4962

# Expose the Webhook server with Serveo

webHookurl=$(expose_with_serveo 4962 80)

echo "Webhook: $webHookurl"

# Start the IIOT server locally

activate_venv "$IIOT_venv"

cd "$HOME/industrial-IOT/web-ui"
export FLASK_APP=run.py
export FLASK_DEBUG=True

run_flask_app_background 5000

# Expose the IIOT server with Serveo

IIOTurl=$(expose_with_serveo 5000 4962)

echo "IIOT server: $IIOTurl"

# Pass the URLs to a Python script

source "$webhook_venv"

python ~/termuxWebhook/telegram.py "$webHookurl" "$IIOTurl"
