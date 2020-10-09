#protecting endpoints using iptables
# run this on each node
iptables --insert FORWARD 1 --in-interface eth0 --destination {metadata-API-endpoint} --jump DROP 

#protect using network policies
kubectl apply -f deny-instance-metadata.yaml # policy should be applied to each namespace.

#more details here:
https://kubernetes.io/docs/tasks/administer-cluster/securing-a-cluster/#restricting-cloud-metadata-api-access

https://blog.cloud66.com/setting-up-secure-endpoints-in-kubernetes/