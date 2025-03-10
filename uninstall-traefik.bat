echo Șterge resursele Helm pentru Traefik..
kubectl delete helmrelease traefik -n kube-system

echo Dacă nu ai HelmRelease, șterge direct Deployment-ul:
kubectl delete deployment traefik -n kube-system

echo Sterge serviciile asociate....
kubectl delete svc traefik -n kube-system
kubectl delete svc svclb-traefik-305fd422-zjdwp -n kube-system

echo Sterge toate obiectele traefik....
kubectl delete all -l app.kubernetes.io/name=traefik -n kube-system

echo Verifica daca e dezintalat
kubectl get pods -n kube-system

echo Succes


