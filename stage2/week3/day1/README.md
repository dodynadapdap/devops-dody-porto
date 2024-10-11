![image](https://github.com/user-attachments/assets/79f67f46-62ae-42c0-92ea-b843d9395e41)![image](https://github.com/user-attachments/assets/b8617418-f65b-4511-9a07-1f459bc434aa)Task:
- Dengan mendaftar akun free tier AWS/GCP/Azure, buatlah Infrastructre dengan terraform menggunakan registry yang sudah ada. dengan beberapa aturan berikut :
   - Buatlah 2 buah server dengan OS ubuntu 24 dan debian 11 (Untuk spec menyesuaikan)
   - attach vpc ke dalam server tersebut
   - attach ip static ke vm yang telah kalian buat
   - pasang firewall ke dalam server kalian dengan rule {allow all ip(0.0.0.0/0)}
   - buatlah 2 block storage di dalam terraform kalian, lalu attach block storage tersebut ke dalam server yang ingin kalian buat. (pasang 1 ke server ubuntu dan  1 di server debian)
   - test ssh ke server
- Buat terraform code kalian serapi mungkin
 - simpan script kalian ke dalam github dengan format tree sebagai berikut:
```sh
  Automation  
  |  
  | Terraform
  └─|  └── gcp
          │ └── main.tf
          │ └── providers.tf
          │ └── etc
          ├── aws
          │ └── main.tf
          │ └── providers.tf
          │ └── etc
          ├── azure
          │ └── main.tf
          │ └── providers.tf
          │ └── etc
```


Setelah kita membuat project di GCP langkah selanjutnya adalah kita buat service account agar terraform kita bisa terkoneksi ke GCP dan pastikan tidak boleh terekspose oleh yg tidak berkepentingan karena BERBAHAYA.

![image](https://github.com/user-attachments/assets/bcf5ec0e-99e5-413d-8de5-5f988eba5e8a)

![image](https://github.com/user-attachments/assets/e5b1e941-7738-48a1-86d4-31614d4ecffe)

Jangan lupa menambahkan role nya, bisa spesific untuk satu service (Google Compute Engine) saja atau semua service dengan mengklik pilihan owner.

![image](https://github.com/user-attachments/assets/f25cb807-3841-4e25-907e-d868ae60533c)

Setelah semua dependensy yang di perlukan di google cloud telah berhasil disetting langkah selanjutnya kita bisa langsung ke terraform. dengan melakukan installasi terlebih dahulu.
```
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

setelah terraform terrinstall kita bisa membuat directory structure supaya lebih rapih yang berisikan semua konfigurasi dari terraform kita.

![image](https://github.com/user-attachments/assets/90f4a2f4-ff38-4f4f-99c5-a22183940b64)

### Direktori struktur
Agar semakin rapih jangan simpan semua konfigurasi terraform di main.tf file tapi lebih baik kita pisah pisah sesuai dengan fungsinnya.

### Keys.json
File pertama dan yang sangat wajib disini adalah file API keys yang berformat JSON file yang telah kita download di google cloude, Lokasinya = "I AM admin/Service account"
```
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "",
  "client_email": "",
  "client_id": "",
  "auth_uri": "",
  "token_uri": "",
  "auth_provider_x509_cert_url": "",
  "client_x509_cert_url": "",
  "universe_domain": "googleapis.com"
}
```
### main.tf
File yang sangat wajib kedua adalah main.tf, kita bisa menaruh semua konfigurasi langsung di satu file ini saja, tapi rekomendasinya adalah kita pisah pisah
```
# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
}

# Firewall rule
resource "google_compute_firewall" "allow_all" {
  name    = "allow-all"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-all"]
}

# Static IPs
resource "google_compute_address" "static_ip_ubuntu" {
  name = "static-ip-ubuntu"
  region = var.gcp_region
}

resource "google_compute_address" "static_ip_debian" {
  name = "static-ip-debian"
  region = var.gcp_region
}

# Ubuntu Server
resource "google_compute_instance" "gcp_ubuntu" {
  name         = "ubuntu-server"
  machine_type = "e2-medium"  # 2 vCPUs, 4 GB memory
  zone         = var.gcp_zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.gcp_images["ubuntu"]
      size  = 10  # 10 GB
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      nat_ip = google_compute_address.static_ip_ubuntu.address
    }
  }

  tags = ["allow-all"]
  metadata = {
    ssh-keys = "dody:${file("~/.ssh/dody.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Debian Server
resource "google_compute_instance" "gcp_debian" {
  name         = "debian-server"
  machine_type = "e2-medium"  # 2 vCPUs, 4 GB memory
  zone         = var.gcp_zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.gcp_images["debian"]
      size  = 10  # 10 GB
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      nat_ip = google_compute_address.static_ip_debian.address
    }
  }

  tags = ["allow-all"]
  metadata = {
    ssh-keys = "dody:${file("~/.ssh/dody.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Block Storage for Ubuntu
resource "google_compute_disk" "ubuntu_block_storage" {
  name = "ubuntu-block-storage"
  type = "pd-ssd"
  zone = var.gcp_zone
  size = 10  # 10 GB
}

# Attach Block Storage to Ubuntu
resource "google_compute_attached_disk" "ubuntu_attached_disk" {
  disk     = google_compute_disk.ubuntu_block_storage.id
  instance = google_compute_instance.gcp_ubuntu.id
}

# Block Storage for Debian
resource "google_compute_disk" "debian_block_storage" {
  name = "debian-block-storage"
  type = "pd-ssd"
  zone = var.gcp_zone
  size = 10  # 10 GB
}

# Attach Block Storage to Debian
resource "google_compute_attached_disk" "debian_attached_disk" {
  disk     = google_compute_disk.debian_block_storage.id
  instance = google_compute_instance.gcp_debian.id
}
```

### provider.tf
```
provider "google" {
    project     = var.gcp_project
    credentials = file(var.gcp_svc_key)
    region      = var.gcp_region
    zone        = var.gcp_zone
}
```

### terraform.tfvars
```
gcp_svc_key = "./keys.json"
gcp_project = "booming-coast-437215-r5"
gcp_region = "us-west1"
gcp_zone = "us-west1-a"
gcp_images = {
    ubuntu = "ubuntu-os-cloud/ubuntu-2204-lts" 
    debian = "debian-cloud/debian-11"
}
```


### variables.tf
```
variable "gcp_svc_key" {
  type        = string
  description = "Path to the GCP service account key file"
}

variable "gcp_project" {
  type        = string
  description = "GCP project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP region"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone"
}

variable "gcp_images" {
  type = map(string)
  description = "Map of OS images to use for instances"
}
```

## Runs Terraform command
Setelah semua konfigurasi kita setup kita langsung aja tampa basa basi jalankan perintah terraform nya. wajib dimual dari terraform init, supaya kita menginisialisasi provider nya terlebih dahulu dalam case ini google cloud
```
# inisialisasi terraform
terraform init

# memvalidasi script terraform
terraform validate

# check planning untuk memastikan
terraform plan

# apply atau jalankan semua planning state
terraform apply

# mematikan semua service jika sudah selesai dan tidak terpakai
terraform destroy
```

![image](https://github.com/user-attachments/assets/bed9b4a4-1b66-4211-8515-311616c24b0d)

validasi jika ada kesalahan kode

![image](https://github.com/user-attachments/assets/dd401834-3210-4e47-a662-aa7dde3217f6)


cek terlebih dahulu planning yang akan dibuat

![image](https://github.com/user-attachments/assets/601cb9ec-1407-47a2-8b0b-3b8d09e0c02c)

jalankan terraform apply untuk mulai membuat instance secara IAC (infrastructure as code)

![image](https://github.com/user-attachments/assets/5ae80d60-3651-4207-9146-d96cd3c46b1f)
![image](https://github.com/user-attachments/assets/13a4f65e-3f74-4c7a-988f-7bf575919cd0)
![image](https://github.com/user-attachments/assets/340e840d-ac67-48fb-b9a3-49071a723e99)


