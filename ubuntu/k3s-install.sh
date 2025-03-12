#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Updating system packages..."
sudo apt-get update -y

echo "Installing necessary packages (curl, git, etc.)..."
sudo apt-get install -y curl git

echo "Installing K3s (disabling Traefik)..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -

echo "K3s installation complete."

# Optional: If you want to use 'kubectl' or 'helm' directly from your shell,
# you can also link /usr/local/bin/kubectl to /usr/bin/kubectl or set up your PATH:
sudo ln -s /usr/local/bin/kubectl /usr/bin/kubectl || true

# Install Helm
echo "Installing Helm..."
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
echo "Helm installation complete."

echo "Installation of K3s and Helm is done."
