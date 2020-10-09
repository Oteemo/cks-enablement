 checksums, PGP, and SHA 

#Mac
openssl [hash type] [/path/to/file]

Hash type should be md5, SHA1, or SHA256. 

#Linux
openssl sha1 -sha256 /usr/bin/kubectl
sha256sum kubernetes.tar.gz
sha1sum kubernetes.tar 
md5sum kubernetes.tar 


root@cks-control-plane:/# openssl sha1 -sha256 /usr/bin/kubectl
SHA256(/usr/bin/kubectl)= ea41d1af270d41a5b4da5079f96c17ce88c2d9bbfc8c7516e104692a5fbfea6c
root@cks-control-plane:/# openssl sha1 -sha256 /usr/bin/kubeadm                              
SHA256(/usr/bin/kubeadm)= 7bbd7904629f928cfa021805d179b16a825bda1dfb5da6fdc2e5fbefdb12306a
root@cks-control-plane:/# openssl sha1 -sha256 /usr/bin/kubelet
SHA256(/usr/bin/kubelet)= 8c2ecdaedee57d20d4a69607bea39628f011ea95d2dce1730ad2e52a7fa6d8e8

#verify download upstream kubernetes.tar.gz file
openssl sha1 -sha256 kubernetes.tar.gz 
sha256sum kubernetes.tar.gz


#links :
https://github.com/kubernetes/kubernetes/releases