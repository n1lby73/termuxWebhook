# #!/data/data/com.termux/files/usr/bin/bash

# # Function to activate a virtual environment or exit on failure

# activate_venv() {

#     local venv_path="$1"
#     source "$venv_path" || { echo "Failed to activate virtual environment: $venv_path"; exit 1; }

# }

# # Function to run a Flask application in the background

# run_flask_app_background() {
    
#     local port="$1"
#     nohup flask run --port "$port" &

#     if [ $? -ne 0 ]; then

#         echo "Failed to start Flask application on port $port"
#         exit 1

#     fi
# }

# # Function to expose a server with Serveo

# expose_with_serveo() {

#     local local_port="$1"
#     local serveo_port="$2"

#     local serveo_url=$(ssh -R "$serveo_port:localhost:$local_port" serveo.net)

#     if [ $? -ne 0 ]; then

#         echo "Failed to expose server on port $local_port with Serveo"
#         exit 1

#     else

#         forwarded_url=$(echo "$serveo_url" | grep -o 'from [^ ]*' | awk '{print $2}')
#         echo "$forwarded_url"

#     fi
# }

# # Function to kill processes running on specified port

# kill_port_processes() {

#     local port="$1"
#     local pids=$(lsof -ti :$port)

#     if [ -n "$pids" ]; then

#         echo "Killing processes on port $port: $pids"
#         kill -9 $pids

#     fi

# }

# # Paths to virtual environment activation scripts

# webhook_venv="$HOME/termuxWebhook/termuxenv/bin/activate"
# IIOT_venv="$HOME/industrial-IOT/web-ui/iitenv/bin/activate"

# # Start the Webhook server locally

# activate_venv "$webhook_venv"

# cd "$HOME/termuxWebhook"
# export FLASK_APP=run.py
# export FLASK_DEBUG=True

# kill_port_processes 4962
# run_flask_app_background 4962

# # Expose the Webhook server with Serveo

# webHookurl=$(expose_with_serveo 4962 80)

# echo "Webhook: $webHookurl"

# # Start the IIOT server locally

# activate_venv "$IIOT_venv"

# cd "$HOME/industrial-IOT/web-ui"
# export FLASK_APP=run.py
# export FLASK_DEBUG=True

# kill_port_processes 5000
# run_flask_app_background 5000

# # Expose the IIOT server with Serveo

# IIOTurl=$(expose_with_serveo 5000 4962)

# echo "IIOT server: $IIOTurl"

# # Pass the URLs to a Python script

# source "$webhook_venv"

# python ~/termuxWebhook/telegram.py "$webHookurl" "$IIOTurl"


#!/data/data/com.termux/files/usr/bin/bash

# Function to activate a virtual environment or exit on failure
# activate_venv() {
#     local venv_path="$1"
#     source "$venv_path" || { echo "Failed to activate virtual environment: $venv_path"; exit 1; }
# }

# # Function to run a Flask application in the background using tmux
# run_flask_app_tmux() {
#     local session_name="$1"
#     local port="$2"

#     tmux new-session -d -s "$session_name" "flask run --port $port"
#     if [ $? -ne 0 ]; then
#         echo "Failed to start Flask application on port $port"
#         exit 1
#     fi
# }

# # Function to expose a server with Serveo
# expose_with_serveo() {
#     local local_port="$1"
#     local serveo_port="$2"

#     local serveo_url=$(ssh -R "$serveo_port:localhost:$local_port" serveo.net)

#     if [ $? -ne 0 ]; then
#         echo "Failed to expose server on port $local_port with Serveo"
#         exit 1
#     else
#         forwarded_url=$(echo "$serveo_url" | grep -o 'from [^ ]*' | awk '{print $2}')
#         echo "$forwarded_url"
#     fi
# }

# # Function to kill processes running on a specified port
# kill_port_processes() {
#     local port="$1"
#     local pids=$(lsof -ti :$port)

#     if [ -n "$pids" ]; then
#         echo "Killing processes on port $port: $pids"
#         kill -9 $pids
#     fi
# }

# # Paths to virtual environment activation scripts
# webhook_venv="$HOME/termuxWebhook/termuxenv/bin/activate"
# IIOT_venv="$HOME/industrial-IOT/web-ui/iitenv/bin/activate"

# # Start the Webhook server in the background using tmux
# activate_venv "$webhook_venv"
# cd "$HOME/termuxWebhook"
# export FLASK_APP=run.py
# export FLASK_DEBUG=True

# kill_port_processes 4962
# run_flask_app_tmux "webhook_server" 4962

# # Expose the Webhook server with Serveo
# webHookurl=$(expose_with_serveo 4962 80)
# echo "Webhook: $webHookurl"

# # Start the IIOT server in the background using tmux
# activate_venv "$IIOT_venv"
# cd "$HOME/industrial-IOT/web-ui"
# export FLASK_APP=run.py
# export FLASK_DEBUG=True

# kill_port_processes 5000
# run_flask_app_tmux "IIOT_server" 5000

# # Expose the IIOT server with Serveo
# IIOTurl=$(expose_with_serveo 5000 4962)
# echo "IIOT server: $IIOTurl"

# # Pass the URLs to a Python script
# source "$webhook_venv"
# python ~/termuxWebhook/telegram.py "$webHookurl" "$IIOTurl"

#!/data/data/com.termux/files/usr/bin/bash

# Function to activate a virtual environment or exit on failure

activate_venv() {

    local venv_path="$1"
    source "$venv_path" || { echo "Failed to activate virtual environment: $venv_path"; exit 1; }

}

# Function to run a Flask application in the background

run_flask_app_background() {
    
    local port="$1"
    nohup flask run --port "$port" > /dev/null 2>&1 &

    if [ $? -ne 0 ]; then

        echo "Failed to start Flask application on port $port"
        exit 1

    fi
}

# Function to expose a server with Serveo

expose_with_serveo() {

    local local_port="$1"
    local serveo_port="$2"

    local serveo_url=$(ssh -R "$serveo_port:localhost:$local_port" serveo.net) > /dev/null 2>&1 &

    if [ $? -ne 0 ]; then

        echo "Failed to expose server on port $local_port with Serveo"
        exit 1

    else

        forwarded_url=$(echo "$serveo_url" | grep -o 'from [^ ]*' | awk '{print $2}')
        echo "$forwarded_url"

    fi
}

# Function to kill processes running on specified port

kill_port_processes() {

    local port="$1"
    local pids=$(lsof -ti :$port)

    if [ -n "$pids" ]; then

        echo "Killing processes on port $port: $pids"
        kill -9 $pids

    fi

}

# Paths to virtual environment activation scripts

webhook_venv="$HOME/termuxWebhook/termuxenv/bin/activate"
IIOT_venv="$HOME/industrial-IOT/web-ui/iitenv/bin/activate"

# Start the Webhook server locally

activate_venv "$webhook_venv"

cd "$HOME/termuxWebhook"
export FLASK_APP=run.py
export FLASK_DEBUG=True

kill_port_processes 4962
echo "starting webhook"
run_flask_app_background 4962

# Expose the Webhook server with Serveo
echo "starting pf webhook"
webHookurl=$(expose_with_serveo 4962 80)

echo "Webhook: $webHookurl"

# Start the IIOT server locally

activate_venv "$IIOT_venv"

cd "$HOME/industrial-IOT/web-ui"
export FLASK_APP=run.py
export FLASK_DEBUG=True

kill_port_processes 5000
echo "starting app"
run_flask_app_background 5000

# Expose the IIOT server with Serveo
echo "starting pf app"
IIOTurl=$(expose_with_serveo 5000 4962)

echo "IIOT server: $IIOTurl"

# Pass the URLs to a Python script

source "$webhook_venv"

python ~/termuxWebhook/telegram.py "$webHookurl" "$IIOTurl"
