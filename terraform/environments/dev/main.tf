provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "network" {
  source      = "../../modules/network"
  vpc_name    = "dev-vpc"
  subnet_name = "dev-subnet"
  subnet_cidr = "10.0.0.0/24"
  region      = var.region
}

module "compute" {
  source            = "../../modules/compute"
  vm_name              = "dev-vm"
  machine_type      = "e2-micro"
  zone              = var.zone
  image             = "debian-cloud/debian-12"
  subnet_self_link  = module.network.subnet_self_link
  tags              = ["ssh-enabled"]
  metadata_start_script = <<-EOT
    #!/bin/bash
    echo 'root:root' | chpasswd
    usermod -aG google-sudoers root
  EOT
}

module "rdb_instance" {
  source          = "../../modules/rdb_instance"
  name            = "dev-postgres"
  region          = var.region
  vpc_id          = module.network.vpc_id
  vpc_self_link   = module.network.vpc_self_link
  user_password   = var.db_password
}