#!/bin/bash

# Find all running ssh-agents
agents=$(pgrep ssh-agent)

# Check if any agents are running
if [ -z "$agents" ]; then
  echo "No ssh-agents running"
else
  echo "Running ssh-agents:"
  for agent in $agents; do
    echo "Agent PID: $agent"
    echo "Agent Environment Variables:"
    cat /proc/$agent/environ | tr '\0' '\n'
    echo "-----------------------------"
  done
fi
