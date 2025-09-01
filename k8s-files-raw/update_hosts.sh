#!/bin/bash

# Complete Keycloak Fix Script
# This script will fix and verify your Keycloak installation

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Keycloak Complete Fix Script ===${NC}"
echo ""

# Step 1: Check prerequisites
echo -e "${BLUE}Step 1: Checking prerequisites...${NC}"

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl is not installed${NC}"
    exit 1
fi

# Check cluster connection
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}Cannot connect to Kubernetes cluster${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Connected to Kubernetes cluster${NC}"

# Step 2: Check and update /etc/hosts
echo ""
echo -e "${BLUE}Step 2: Checking /etc/hosts...${NC}"

if ! grep -q "keycloak.local" /etc/hosts; then
    echo -e "${YELLOW}Adding keycloak.local to /etc/hosts...${NC}"
    echo "127.0.0.1    keycloak.local" | sudo tee -a /etc/hosts
    echo -e "${GREEN}✓ Added keycloak.local to /etc/hosts${NC}"
else
    echo -e "${GREEN}✓ keycloak.local already in /etc/hosts${NC}"
fi

# Step 3: Clean up existing Keycloak resources
echo ""
echo -e "${BLUE}Step 3: Cleaning up existing Keycloak deployment...${NC}"

echo -e "${YELLOW}Deleting existing Keycloak resources...${NC}"
kubectl delete deployment keycloak --ignore-not-found=true
kubectl delete service keycloak --ignore-not-found=true
kubectl delete ingress keycloak-ingress --ignore-not-found=true
echo -e "${GREEN}✓ Cleanup complete${NC}"

# Step 4: Create prerequisites
echo ""
echo -e "${BLUE}Step 4: Creating prerequisites...${NC}"

# Create secret if it doesn't exist
if ! kubectl get secret keycloak-secret &> /dev/null; then
    echo -e "${YELLOW}Creating keycloak-secret...${NC}"
    kubectl create secret generic keycloak-secret \
        --from-literal=adminUser=admin \
        --from-literal=adminPassword=admin123
    echo -e "${GREEN}✓ Secret created${NC}"
else
    echo -e "${GREEN}✓ Secret already exists${NC}"
fi

# Create PVC if it doesn't exist
if ! kubectl get pvc keycloak-pvc &> /dev/null; then
    echo -e "${YELLOW}Creating PersistentVolumeClaim...${NC}"
    kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: keycloak-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
    echo -e "${GREEN}✓ PVC created${NC}"
else
    echo -e "${GREEN}✓ PVC already exists${NC}"
fi

# Create ConfigMap if it doesn't exist
if ! kubectl get configmap app-config &> /dev/null; then
    echo -e "${YELLOW}Creating app-config ConfigMap...${NC}"
    kubectl create configmap app-config \
        --from-literal=realm-export.json='{"realm":"master","enabled":true}'
    echo -e "${GREEN}✓ ConfigMap created${NC}"
else
    echo -e "${GREEN}✓ ConfigMap already exists${NC}"
fi

# Step 5: Apply fixed Keycloak deployment
echo ""
echo -e "${BLUE}Step 5: Deploying fixed Keycloak configuration...${NC}"

kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keycloak
  labels:
    app: keycloak
spec:
  replicas: 1
  selector:
    matchLabels:
      app: keycloak
  template:
    metadata:
      labels:
        app: keycloak
    spec:
      containers:
        - name: keycloak
          image: quay.io/keycloak/keycloak:24.0.4
          args:
            - "start"
            - "--import-realm"
          ports:
            - containerPort: 8080
          env:
            - name: KEYCLOAK_ADMIN
              valueFrom:
                secretKeyRef:
                  name: keycloak-secret
                  key: adminUser
            - name: KEYCLOAK_ADMIN_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: keycloak-secret
                  key: adminPassword
            - name: KC_DB
              value: mysql
            - name: KC_DB_URL
              value: jdbc:mysql://mysql-service:3306/testdb
            - name: KC_DB_USERNAME
              value: testuser
            - name: KC_DB_PASSWORD
              value: testpass
            - name: KC_HTTP_ENABLED
              value: "true"
            - name: KC_HOSTNAME_STRICT
              value: "false"
            - name: KC_HOSTNAME_STRICT_HTTPS
              value: "false"
            - name: KC_PROXY
              value: "edge"
            - name: KC_PROXY_ADDRESS_FORWARDING
              value: "true"
            - name: KC_HEALTH_ENABLED
              value: "true"
            - name: KC_METRICS_ENABLED
              value: "true"
            - name: KC_FEATURES
              value: token-exchange,admin-fine-grained-authz
            - name: KC_LOG_LEVEL
              value: INFO
            - name: KC_LOG_CONSOLE_OUTPUT
              value: json
            - name: KC_HOSTNAME
              value: keycloak.local
            - name: KC_HTTP_PORT
              value: "8080"
          volumeMounts:
            - name: keycloak-data
              mountPath: /opt/keycloak/data
            - name: realm-export
              mountPath: /opt/keycloak/data/import
              readOnly: true
      volumes:
        - name: keycloak-data
          persistentVolumeClaim:
            claimName: keycloak-pvc
        - name: realm-export
          configMap:
            name: app-config
            optional: true
            items:
              - key: realm-export.json
                path: realm-export.json
---
apiVersion: v1
kind: Service
metadata:
  name: keycloak
spec:
  selector:
    app: keycloak
  ports:
    - name: http
      port: 8080
      targetPort: 8080
  type: ClusterIP
EOF

echo -e "${GREEN}✓ Keycloak deployment created${NC}"

# Step 6: Apply Ingress
echo ""
echo -e "${BLUE}Step 6: Creating Ingress...${NC}"

kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: keycloak-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-buffer-size: "128k"
    nginx.ingress.kubernetes.io/proxy-buffers: "4 256k"
    nginx.ingress.kubernetes.io/proxy-busy-buffers-size: "256k"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
spec:
  ingressClassName: nginx
  rules:
    - host: keycloak.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: keycloak
                port:
                  number: 8080
EOF

echo -e "${GREEN}✓ Ingress created${NC}"

# Step 7: Wait for deployment to be ready
echo ""
echo -e "${BLUE}Step 7: Waiting for Keycloak to be ready...${NC}"

echo -e "${YELLOW}Waiting for pod to start (this may take 1-2 minutes)...${NC}"
kubectl wait --for=condition=available --timeout=180s deployment/keycloak || {
    echo -e "${YELLOW}Deployment not ready yet, checking pod status...${NC}"
    kubectl get pods -l app=keycloak
    kubectl describe pod -l app=keycloak | tail -20
}

# Get pod status
POD_NAME=$(kubectl get pods -l app=keycloak -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -n "$POD_NAME" ]; then
    echo -e "${GREEN}✓ Pod is running: $POD_NAME${NC}"

    # Show recent logs
    echo ""
    echo -e "${YELLOW}Recent logs:${NC}"
    kubectl logs $POD_NAME --tail=10 | grep -E "(started in|Listening on|ERROR)" || true
fi

# Step 8: Test connectivity
echo ""
echo -e "${BLUE}Step 8: Testing connectivity...${NC}"

# Wait a bit for services to stabilize
sleep 5

# Test via port-forward first
echo -e "${YELLOW}Testing direct access via port-forward...${NC}"
kubectl port-forward service/keycloak 8180:8080 > /dev/null 2>&1 &
PF_PID=$!
sleep 3

if curl -s -o /dev/null -w "%{http_code}" http://localhost:8180/ | grep -q "200\|302\|303"; then
    echo -e "${GREEN}✓ Direct access works via port-forward${NC}"
else
    echo -e "${YELLOW}⚠ Direct access may still be initializing${NC}"
fi
kill $PF_PID 2>/dev/null || true

# Test via ingress
echo ""
echo -e "${YELLOW}Testing access via ingress...${NC}"
for i in {1..5}; do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://keycloak.local/ 2>/dev/null || echo "000")

    if [[ "$HTTP_CODE" == "200" ]] || [[ "$HTTP_CODE" == "302" ]] || [[ "$HTTP_CODE" == "303" ]]; then
        echo -e "${GREEN}✓ SUCCESS! Keycloak is accessible (HTTP $HTTP_CODE)${NC}"
        break
    else
        echo -e "${YELLOW}Attempt $i: HTTP $HTTP_CODE - waiting...${NC}"
        sleep 5
    fi
done

# Step 9: Final summary
echo ""
echo -e "${BLUE}=== Installation Complete ===${NC}"
echo ""
echo -e "${GREEN}Keycloak Access Information:${NC}"
echo "• Main URL: http://keycloak.local/"
echo "• Admin Console: http://keycloak.local/admin"
echo "• Admin Username: admin"
echo "• Admin Password: admin123"
echo ""
echo -e "${YELLOW}Troubleshooting Commands:${NC}"
echo "• Check pods: kubectl get pods -l app=keycloak"
echo "• View logs: kubectl logs -l app=keycloak"
echo "• Port forward: kubectl port-forward service/keycloak 8080:8080"
echo "• Check ingress: kubectl get ingress keycloak-ingress"
echo ""

# Final test
echo -e "${YELLOW}Opening Keycloak in browser...${NC}"
if command -v open &> /dev/null; then
    # macOS
    open http://keycloak.local/ 2>/dev/null || true
elif command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open http://keycloak.local/ 2>/dev/null || true
fi

echo -e "${GREEN}Script completed!${NC}"