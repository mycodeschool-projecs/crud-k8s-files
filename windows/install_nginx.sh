helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.hostNetwork=true \
  --set controller.kind=DaemonSet \
  --set controller.admissionWebhooks.enabled=false