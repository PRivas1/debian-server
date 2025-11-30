#!/bin/bash

SESSION_NAME="minecraft"
SERVER_DIR="/home/user/BMC3_Server_Pack_v22"
START_SCRIPT="./start.sh"

# check if tmux session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Tmux session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t $SESSION_NAME
    exit 0
fi

# configure
tmux new-session -d -s $SESSION_NAME
tmux split-window -v -p 32 -t $SESSION_NAME  # split vertically
tmux send-keys -t $SESSION_NAME:0.0 "btop" C-m  # run btop in the top pane
tmux send-keys -t $SESSION_NAME:0.1 "cd $SERVER_DIR && $START_SCRIPT" C-m  # run console in bottom pane

tmux attach-session -t $SESSION_NAME
