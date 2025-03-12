#!/usr/bin/env bash
set -e

# -----------------------------
# Variables
# -----------------------------
PUBLIC_IP="3.77.31.35"   # Replace with your EC2 public IP if needed
K3S_CONFIG_DIR="/etc/rancher/k3s"
K3S_CONFIG_FILE="${K3S_CONFIG_DIR}/config.yaml"

# -----------------------------
# 1) Update K3s config with TLS SAN
# -----------------------------
echo "Configuring K3s to include public IP (${PUBLIC_IP}) as a TLS SAN..."

# Create the config directory if it doesn't exist
sudo mkdir -p "${K3S_CONFIG_DIR}"

# Create/update the config file to include our public IP as a TLS SAN
cat <<EOF | sudo tee "${K3S_CONFIG_FILE}"
# K3s configuration file
# See: https://docs.k3s.io/reference/configuration
tls-san:
  - ${PUBLIC_IP}

# Disable Traefik if you haven't already
disable:
  - traefik
EOF

# -----------------------------
# 2) Restart K3s
# -----------------------------
echo "Restarting k3s service to apply changes..."
sudo systemctl restart k3s

echo "Waiting a few seconds to ensure k3s restarts fully..."
sleep 5

# Optional check:
sudo systemctl status k3s --no-pager || true

# -----------------------------
# 3) Generate a kubeconfig pointing to the public IP
# -----------------------------
echo "Generating a new kubeconfig that uses ${PUBLIC_IP} instead of 127.0.0.1..."

# Copy the default admin kubeconfig
sudo cp /etc/rancher/k3s/k3s.yaml /tmp/kubeconfig
sudo chown $USER:$USER /tmp/kubeconfig

# Replace '127.0.0.1' or 'localhost' with the public IP in the kubeconfig
sed -i "s/127.0.0.1/${PUBLIC_IP}/g" /tmp/kubeconfig
sed -i "s/localhost/${PUBLIC_IP}/g" /tmp/kubeconfig

echo "A new /tmp/kubeconfig has been generated with server: https://${PUBLIC_IP}:6443"

# Test it locally on the server (optional)
echo "Testing connectivity with the new kubeconfig (on this server)..."
kubectl --kubeconfig /tmp/kubeconfig get nodes

# -----------------------------
# 4) Instructions for local Lens
# -----------------------------
echo "--------------------------------------------------------------------"
echo "Remote Access Configured!"
echo ""
echo "1) Ensure your EC2 Security Group or firewall allows inbound traffic"
echo "   on port 6443 from your local IP address."
echo ""
echo "2) Secure-copy (/tmp/kubeconfig) to your local machine:"
echo "   scp -i <your-key.pem> ubuntu@${PUBLIC_IP}:/tmp/kubeconfig ./kubeconfig"
echo ""
echo "3) In Lens, click 'Add Cluster' and import the kubeconfig file you"
echo "   just downloaded."
echo ""
echo "4) Alternatively, you can place it in your local ~/.kube/config"
echo "   (merge or replace as needed) and then run:"
echo "   kubectl get nodes"
echo ""
echo "Done!"
echo "--------------------------------------------------------------------"
