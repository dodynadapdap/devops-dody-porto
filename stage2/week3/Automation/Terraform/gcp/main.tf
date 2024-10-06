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