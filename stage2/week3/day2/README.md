# Task
Buat konfigurasi Ansible & sebisa mungkin maksimalkan penggunaan ansbile untuk melakukan semua setup dan se freestyle kalian

[ansible]
Buatlah ansible untuk :

Membuat user baru, gunakan login ssh key & password
Instalasi Docker
Deploy application frontend yang sudah kalian gunakan sebelumnya menggunakan ansible.
Instalasi Monitoring Server (node exporter, prometheus, grafana)
Setup reverse-proxy
Generated SSL certificate
simpan script kalian ke dalam github dengan format tree sebagai berikut:
Ansible
    ├── ansible.cfg
    ├── lolrandom1.yaml
    ├── group_vars
    │ └── all
    ├── Inventory
    ├── lolrandom2.yaml
    └── lolrandom3.yaml


#### 1. Buat File Inventory dan ansible.cfg
1. Buat file Inventory dan ansible.cfg dan isilah script sebagai berikut
Inventory
```
[appserver]
35.240.202.154

[gateway]
34.19.55.66

[all:vars]
ansible_user="dody"
```

ansible.cfg
```
[defaults]

inventory = Inventory
private_key_file = /home/dody/.ssh/dody
host_key_checking = False
interpreter_python = auto_silent
```

2. Salin id_rsa.pub local ke authorized_keys appserver dan gateway
buka file id_rsa.pub dan salin
```
cat ~/.ssh/id_rsa.pub
```
setelah disalin paste ke file authorized_keys appserver dan gateway
```
cd ~/.ssh
```
paste ke file athorized_keys masing masing app server dan gateway
```
vim athorized_keys
```

test ping
```
ansible all -m ping
```

![image](https://github.com/user-attachments/assets/cf19ca57-d3b0-4ba0-9051-e417c2ab10fa)



#### Membuat User baru

![image](https://github.com/user-attachments/assets/4b6bf13e-7647-4b25-89c8-fdcf92697d59)

#### Instalasi Docker

![image](https://github.com/user-attachments/assets/c18dd58e-94c8-4ddf-a57c-367d3ef5ee45)

![image](https://github.com/user-attachments/assets/57ddcb35-b16b-4b19-ad81-02ec8efcfb76)

![image](https://github.com/user-attachments/assets/3830fc35-1e6a-4805-bf81-cd4f419c1da6)


### Deployee aplikasi frontend

![image](https://github.com/user-attachments/assets/26d623cb-f430-4786-acdd-c148161b5bab)

### Instalasi Monitoring

![image](https://github.com/user-attachments/assets/d29ca446-bd67-48b5-808c-d0003db4731d)
![image](https://github.com/user-attachments/assets/0447ee45-672f-423b-9f99-134271e4fd80)
![image](https://github.com/user-attachments/assets/d31ca110-da3a-45ea-8cba-f23d54474fd4)

### Setup reverse-proxy

![image](https://github.com/user-attachments/assets/692f1028-1e90-4ab6-9e62-dd613a1af634)


