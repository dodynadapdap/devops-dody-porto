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

#### database
- Buat Storage Class untuk mengelola penyimpanan persisten volume
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-mysql
  namespace: literature
provisioner: rancher.io/local-path
allowVolumeExpansion: false
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```
![image](https://github.com/user-attachments/assets/502ea9b6-26f9-41b7-8ba5-a65dc847a935)

- buat secret untuk menampung environment
```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: literature
type: Opaque
data:
  mysql-database: ZG9keQ==
  mysql-root-password: bmFkYXBkYXAxMjMh # base64 encoded 'password'
  mysql-user: ZG9keQ== # base64 encoded 'user'
  mysql-password: bmFkYXBkYXAxMjMh # base64 encoded 'password'
```
![image](https://github.com/user-attachments/assets/8fa89839-de12-47f3-af9b-5f790b11af60)

- Buat konfigurasi dengan resources statefulset dan service
```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  namespace: literature
spec:
  serviceName: "mysql"
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-root-password
            - name: MYSQL_USER
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-user
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-password
            - name: MYSQL_DATABASE
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-database
          volumeMounts:
            - name: data
              mountPath: /var/lib/mysql
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: local-mysql
        resources:
          requests:
            storage: 2Gi

---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: literature
spec:
  selector:
    app: mysql
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
  type: ClusterIP
```

- Verifikasi apakah database sudah terdeploy dengan environment yang kita masukan tadi

![image](https://github.com/user-attachments/assets/a675264d-cb78-4986-877a-c3485e560fde)
![image](https://github.com/user-attachments/assets/ae9b155a-27ee-46cc-97f0-fb1363c6169e)

- Masuk ke pod mysql yang sudah terbuat dan check username dan database
```
kubectl exec -it mysql-0 -n literature -- /bin/sh

#masuk ke database
mysql -u dody -p
```
![image](https://github.com/user-attachments/assets/e451a728-8857-4cc1-9829-0e588bfe455a)

#### beckend
- Buat konfigurasi backend dengan image yang sudah dikonfigurasi dan di push ke docker registry
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: literature
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: dody99/team2-literature-beckend:production
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: literature
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
  type: ClusterIP
```

- Verifikasi apakah backend sudah terdeploy

![image](https://github.com/user-attachments/assets/44836d09-bcab-4d3d-aced-11a046f08a84)
![image](https://github.com/user-attachments/assets/8f998573-c7bb-415a-b637-65f830a32822)


#### frontend
- Buat konfigurasi frontend dengan image yang sudah dikonfigurasi dan di push ke docker registry
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: literature
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: dody99/team2-literature-frontend:latest
          ports:
            - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: literature
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 3000
  type: ClusterIP
```

### wildcard certificate ssl dengan bantuan cert-manager
#### Install Cert-manager Dengan Helm
```
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true
```
- Buat secret untuk menampung dns cloudflare api token kita
```
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: literature
type: Opaque
stringData:
  api-token:
```
![image](https://github.com/user-attachments/assets/90440d13-f0d4-4cdb-b9d1-a3d81c65fb75)

- buat issuer menentukan bagaimana sertifikat diterbitkan. Itu bisa dikonfigurasi untuk bekerja dengan berbagai Certificate Authority (CA) seperti Let's Encrypt, CA internal, atau Vault, dan mengelola proses validasi serta penerbitan sertifikat sesuai dengan kebutuhan.
```
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-production
  namespace: literature
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: dodynadapdap2@gmail.com
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cloudflare-api-token
            key: api-token
```

- Buat konfigurasi untuk resource Certificate untuk mendapatkan wildcard certificate dari Issuer yang sudah kita buat tadi yaitu letsecnrypt-production.
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-cert
  namespace: literature
spec:
  secretName: wildcard-tls-secret
  issuerRef:
    name: letsencrypt-production
    kind: Issuer
  commonName: "*.dody.kubernetes.studentdumbways.my.id"
  dnsNames:
    - "*.dody.kubernetes.studentdumbways.my.id"
    - "dody.kubernetes.studentdumbways.my.id"
```
![image](https://github.com/user-attachments/assets/9be1b5f4-38d0-42ae-b5e0-58e43cafcbc3)

#### Config Ingress untuk Frontend dan Backend
- Tambahkan TLS certificate dari resource certificate yang sudah kita buat tadi dengan memasukan secret yang menampung certificate tersebut
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-ingress
  namespace: literature
spec:
  tls:
    - hosts:
        - dody.kubernetes.studentdumbways.my.id
      secretName: wildcard-tls-secret
  rules:
    - host: dody.kubernetes.studentdumbways.my.id
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-svc
                port:
                  number: 80
  ingressClassName: nginx
```

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backend-ingress
  namespace: literature
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
    - hosts:
        - api.dody.kubernetes.studentdumbways.my.id
      secretName: wildcard-tls-secret
  rules:
    - host: api.dody.kubernetes.studentdumbways.my.id
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: backend
                port:
                  number: 5000
  ingressClassName: nginx
```
- cek aplikasi sudah berjalan on top kubernetes
![image](https://github.com/user-attachments/assets/6c8134ff-d75e-4e42-b874-97c5e7d46ab2)


