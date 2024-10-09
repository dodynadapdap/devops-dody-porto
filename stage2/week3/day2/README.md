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
