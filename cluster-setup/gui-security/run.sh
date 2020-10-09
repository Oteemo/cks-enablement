kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl proxy &
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
127.0.0.1:8001


kubectl create serviceaccount my-dashboard-sa
kubectl create clusterrolebinding my-dashboard-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=default:my-dashboard-sa

kubectl get secrets
kubectl describe secret my-dashboard-sa-token-xxxxx

#More details :
https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca