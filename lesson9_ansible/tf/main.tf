provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.gcp_project}" 
  region      = "${var.region}"
}

// Create VPC network
resource "google_compute_network" "vpc" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = "false"
}

// Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "${var.subnet_cidr}"
  network       = "${var.name}-vpc"
  depends_on    = ["google_compute_network.vpc"]
  region        = "${var.region}"
}
// VPC firewall configuration
resource "google_compute_firewall" "firewall" {
  name    = "${var.name}-firewall"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

//Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name                   = "centos7-${var.name}"
  machine_type           = "${var.machine}"
  zone                   = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
  }
 }

  network_interface {
    subnetwork = "${var.name}-subnet"
    access_config {}
  }

 metadata_startup_script = <<SCRIPT
    yum -y update
 SCRIPT

 metadata {
    sshKeys = "${var.ssh_username}:${file(var.private_key_path)}"
  }
}