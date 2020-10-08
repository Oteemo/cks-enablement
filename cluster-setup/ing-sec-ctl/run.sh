#generate certs for tls/https

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/nginx.key -out /tmp/nginx.crt -subj "/CN=my-nginx/O=my-nginx"
 kubectl create configmap nginxconfigmap --from-file=examples/staging/https-nginx/default.conf
kubectl create -f nginx-app.yaml
 $ curl https://<your-node-ip>:<your-port> -k