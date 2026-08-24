#!/usr/bin/env bash
set -e

# Configuration for downloading your file
SERVER_IP="20.189.113.214:8000" # e.g., 192.168.1.50 or domain.com
FILENAME="a.py"                 # e.g., input.txt

echo "Cleaning broken GNOME PPAs if exist..."

sudo rm -f /etc/apt/sources.list.d/gnome3-team-ubuntu-gnome3-noble.list
sudo rm -f /etc/apt/sources.list.d/gnome3-team-ubuntu-gnome3-staging-noble.list

echo "Updating package list..."
sudo apt update

echo "Installing curl..."
sudo apt install -y curl

echo "Downloading file from server..."
# Using curl to download the file (assumes HTTP/HTTPS)
curl -o "$FILENAME" "http://$SERVER_IP/$FILENAME"

echo "removing old venv if exist..."
rm -rf myenv
rm -rf venv

echo "Installing Python3 & venv..."
sudo apt install -y python3 python3-venv

python3 -m venv myenv
source myenv/bin/activate

echo "Installing glow..."
sudo snap install glow

echo "Deleting history.."
sudo rm -f ~/.bash_history

echo "Setup complete!"
