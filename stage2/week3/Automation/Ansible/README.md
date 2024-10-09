Local]
Buat konfigurasi Ansible & sebisa mungkin maksimalkan penggunaan ansbile untuk melakukan semua setup dan se freestyle kalian 

[ansible]
Buatlah ansible untuk :
 - Membuat user baru, gunakan login ssh key & password
 - Instalasi Docker
 - Deploy application frontend yang sudah kalian gunakan sebelumnya menggunakan ansible.
 - Instalasi Monitoring Server (node exporter, prometheus, grafana)
 - Setup reverse-proxy
 - Generated SSL certificate
 - simpan script kalian ke dalam github dengan format tree sebagai berikut:
```sh
  Automation  
  |  
  | Terraform
  └─|   └── gcp
       │   └── main.tf
       │    └── providers.tf
       │    └── etc
       │   ├── aws
       │    └── main.tf
       │    └── providers.tf
       │    └── etc
       │  ├── azure
       │    └── main.tf
       │    └── providers.tf
       │    └── etc
    Ansible
    ├── ansible.cfg
    ├── lolrandom1.yaml
    ├── group_vars
    │ └── all
    ├── Inventory
    ├── lolrandom2.yaml
    └── lolrandom3.yaml
```
