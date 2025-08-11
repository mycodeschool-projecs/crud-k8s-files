#!/bin/bash
echo "🚀 Deploying your application..."
kubectl apply -f storage.yaml
kubectl apply -f volumes.yaml
kubectl apply -f secret.yaml
kubectl apply -f configs.yaml
kubectl apply -f mysql.yaml
kubectl apply -f auth-service.yaml
kubectl apply -f command-service.yaml
kubectl apply -f notifications-service.yaml
kubectl apply -f logstash.yaml
kubectl apply -f rabbitMQ.yaml
kubectl apply -f app-client.yaml

kubectl apply -f ingress.yaml
kubectl apply -f ingress-kibana.yaml
kubectl apply -f ingress-rabbitmq.yaml
kubectl apply -f ingress-keycloak.yaml
kubectl apply -f keycloak.yaml
kubectl apply -f zipkin.yaml

kubectl apply -f elasticsearch.yaml


echo "⏳ Aștept Elasticsearch să fie gata..."

MAX_RETRIES=60
RETRY_COUNT=0
until kubectl get pod -l app=elasticsearch -o jsonpath='{.items[0].status.phase}' 2>/dev/null | grep -q "Running"; do
  RETRY_COUNT=$((RETRY_COUNT+1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "❌ Elasticsearch nu a pornit după $MAX_RETRIES încercări."
    exit 1
  fi
  echo "🔁 Aștept ca podul elasticsearch să fie Running... ($RETRY_COUNT/$MAX_RETRIES)"
  sleep 10
done

# Așteaptă ca Elasticsearch să răspundă la HTTP (e important să fie acceptat de kibana-setup)
echo "🌐 Verific răspunsul HTTP al Elasticsearch..."
RETRY_COUNT=0
until kubectl exec -it $(kubectl get pod -l app=elasticsearch -o jsonpath="{.items[0].metadata.name}") \
    -- curl -s http://localhost:9200 | grep -q "missing authentication credentials" || [ $RETRY_COUNT -ge $MAX_RETRIES ]; do
  RETRY_COUNT=$((RETRY_COUNT+1))
  echo "⏳ Elasticsearch nu răspunde încă, reîncercare... ($RETRY_COUNT/$MAX_RETRIES)"
  sleep 5
done

echo "✅ Elasticsearch este UP și răspunde."

kubectl apply -f setup.yaml

kubectl apply -f kibana.yaml
kubectl apply -f prometheus.yaml
kubectl apply -f grafana.yaml
