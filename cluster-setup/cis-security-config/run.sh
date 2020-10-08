#run kube-bench and apply the recommendations

kubectl apply -f bench.yaml 
kubectl get pod -l job-name=kube-bench,app=kube-bench | kubectl logs 

#more details here :
https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks#default-values

