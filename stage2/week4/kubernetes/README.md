Buatlah sebuah kubernetes cluster, yang di dalamnya terdapat 3 buah node as a master and worker.
Install ingress nginx using helm or manifest
Deploy aplikasi yang kalian gunakan di docker swarm, ke dalam kubernetes cluster yang terlah kalian buat di point nomer 1.
Setup persistent volume untuk database kalian
Deploy database mysql with statefullset and use secrets
Install cert-manager ke kubernetes cluster kalian, lalu buat lah wildcard ssl certificate.
Ingress
fe : name.kubernetes.studentdumbways.my.id
be : api.name.kubernetes.studentdumbways.my.id


### buat kubernetes cluster
Untuk membuat cluster K3s kita wajib lihat dokumentasi resmi dari k3s nya untuk instalasi master node terlebih dahulu, setelah master node dibuat tinggal kita lakukan join saja untuk para worker node nya dengan menggunakan ip address dari master dan juga token khusus dari master node.
```
# command install K3S master
curl -sfL https://get.k3s.io | sh -

# Get token
sudo cat /var/lib/rancher/k3s/server/node-token

# command Join K3S worker node to master node
curl -sfL https://get.k3s.io | K3S_URL=https://<ip_addr>:6443 K3S_TOKEN=mynodetoken sh -
```
![image](https://github.com/user-attachments/assets/4ae84e41-9b11-49bc-9924-b085a9af17c6)

![image](https://github.com/user-attachments/assets/22133947-22e0-4686-a0c8-48db8b8390cf)


### Install Nginx using helm
untuk menggunakan helm kita wajib install dulu aplikasinya merujuk dokumentasi resminya tentunya.
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

$ chmod 700 get_helm.sh

$ ./get_helm.sh
```

database
![image](https://github.com/user-attachments/assets/ed4c413d-8a60-46cd-b7bb-317aefbf0747)
