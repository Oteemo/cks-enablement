# create CKS cluster with Kind
kind create cluster --name cks --image kindest/node:v1.19.0 --config cks-cluster.yaml 
#_--------------------------------------------------------------------------------------------------------------------------------------
#setup network policy with calico or cillium
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml 
#_--------------------------------------------------------------------------------------------------------------------------------------
#or
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.8/install/kubernetes/quick-install.yaml
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.8/examples/kubernetes/connectivity-check/connectivity-check.yaml

#_--------------------------------------------------------------------------------------------------------------------------------------
#you can also install cillium using helm
helm repo add cilium https://helm.cilium.io/
docker pull cilium/cilium:v1.8.4
kind load docker-image cilium/cilium:v1.8.4
helm install cilium cilium/cilium --version 1.8.4 \
   --namespace kube-system \
   --set global.nodeinit.enabled=true \
   --set global.kubeProxyReplacement=partial \
   --set global.hostServices.enabled=false \
   --set global.externalIPs.enabled=true \
   --set global.nodePort.enabled=true \
   --set global.hostPort.enabled=true \
   --set config.bpfMasquerade=false \
   --set global.pullPolicy=IfNotPresent \
   --set config.ipam=kubernetes


kubectl -n kube-system get pods --watch
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.8/examples/kubernetes/connectivity-check/connectivity-check.yaml
kubectl get pods -n cilium-test
#_--------------------------------------------------------------------------------------------------------------------------------------
export CILIUM_NAMESPACE=kube-system
helm upgrade cilium cilium/cilium --version 1.8.4 \
   --namespace $CILIUM_NAMESPACE \
   --reuse-values \
   --set global.hubble.enabled=true \
   --set global.hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}"

kubectl rollout restart -n $CILIUM_NAMESPACE ds/cilium

kubectl exec -n $CILIUM_NAMESPACE -t ds/cilium -- hubble observe

export HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
curl -LO "https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-darwin-amd64.tar.gz"
curl -LO "https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-darwin-amd64.tar.gz.sha256sum"
shasum -a 256 -c hubble-darwin-amd64.tar.gz.sha256sum
tar zxf hubble-darwin-amd64.tar.gz

sudo mv hubble /usr/local/bin
kubectl port-forward -n $CILIUM_NAMESPACE svc/hubble-relay 4245:80
hubble observe --server localhost:4245


export HUBBLE_DEFAULT_SOCKET_PATH=localhost:4245



#_--------------------------------------------------------------------------------------------------------------------------------------
#Cluster setup 10%
#_--------------------------------------------------------------------------------------------------------------------------------------

# Use Network security policies to restrict cluster level access

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80
kubectl get svc,pod

#_--------------------------------------------------------------------------------------------------------------------------------------
kubectl run busybox --rm -ti --image=busybox -- /bin/sh
wget --spider --timeout=1 nginx

#_--------------------------------------------------------------------------------------------------------------------------------------

#apply network policy
kubectl apply -f https://k8s.io/examples/service/networking/nginx-policy.yaml
kubectl run busybox --rm -ti --image=busybox -- /bin/sh
wget --spider --timeout=1 nginx

#_--------------------------------------------------------------------------------------------------------------------------------------

kubectl run busybox --rm -ti --labels="access=true" --image=busybox -- /bin/sh
wget --spider --timeout=1 nginx

#_--------------------------------------------------------------------------------------------------------------------------------------
#more examples here :
https://github.com/ahmetb/kubernetes-network-policy-recipes/blob/master/07-allow-traffic-from-some-pods-in-another-namespace.md


#_--------------------------------------------------------------------------------------------------------------------------------------

#Use CIS benchmark to review the security configuration of Kubernetes components (etcd, kubelet, kubedns, kubeapi)
#_--------------------------------------------------------------------------------------------------------------------------------------

