#!/usr/bin/env bash
#
# Fixes common local dev issues by installing NGINX Ingress with NodePort,
# removing any leftover resources, and creating a sample Ingress that
# matches the host "react-app.local".
#
# After completion, you'll see how to access the Ingress via NodePort.

set -euo pipefail

echo ">>> Uninstalling any existing 'my-ingress' release..."
helm uninstall my-ingress --namespace default || true

echo ">>> Removing existing IngressClass 'nginx' if present..."
if kubectl get ingressclass nginx --no-headers 2>/dev/null; then
  kubectl delete ingressclass nginx
fi

echo ">>> Adding the ingress-nginx Helm repo (if not already present)..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
echo ">>> Updating Helm repos..."
helm repo update 1>/dev/null

echo ">>> Installing NGINX Ingress Controller via Helm with NodePort..."
helm upgrade --install my-ingress ingress-nginx/ingress-nginx \
  --namespace default \
  --create-namespace \
  --set controller.ingressClass=nginx \
  --set controller.ingressClassResource.name=nginx \
  --set controller.service.type=NodePort

echo ">>> Waiting for the Ingress Controller to become ready..."
kubectl wait --namespace default \
  --for=condition=Available deployment/my-ingress-ingress-nginx-controller \
  --timeout=120s

echo ">>> Creating a sample Ingress resource..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  annotations:
    # The annotation is for older versions of NGINX Ingress; we also specify ingressClassName
    kubernetes.io/ingress.class: "nginx"
spec:
  ingressClassName: "nginx"
  rules:
  - host: react-app.local
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: kube-land
            port:
              number: 8082
      - path: /
        pathType: Prefix
        backend:
          service:
            name: react-app
            port:
              number: 3000
EOF

echo ">>> Ensuring '/etc/hosts' has an entry for react-app.local"
HOST_ENTRY="127.0.0.1 react-app.local"
if ! grep -q "$HOST_ENTRY" /etc/hosts; then
  echo "    Adding '$HOST_ENTRY' to /etc/hosts (sudo required)."
  sudo sh -c "echo '$HOST_ENTRY' >> /etc/hosts"
else
  echo "    '/etc/hosts' already contains 'react-app.local'."
fi

# Grab the NodePort that NGINX Ingress allocated for HTTP (port 80).
NODE_PORT=$(kubectl get svc my-ingress-ingress-nginx-controller \
  --namespace default \
  -o jsonpath='{.spec.ports[?(@.port==80)].nodePort}')

echo ">>> Done!"
echo "Ingress Controller is installed with type=NodePort on port: $NODE_PORT"
echo
echo "You can test it locally by doing either of these:"
echo "1) Curl with a manual Host header:"
echo "   curl -H 'Host: react-app.local' http://127.0.0.1:$NODE_PORT/"
echo
echo "2) Set /etc/hosts to '127.0.0.1 react-app.local' (which we did) and browse to:"
echo "   http://react-app.local:$NODE_PORT/"
