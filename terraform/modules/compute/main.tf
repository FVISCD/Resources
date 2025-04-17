resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork   = var.subnet_self_link
    access_config {} # 외부 IP 필요시 유지
  }

  metadata = {
    ssh-keys = "gcp-user:${file("~/.ssh/my-gcp-key.pub")}"
    serial-port-enable = "1"  # 직렬 포트 활성화!
  }

  metadata_startup_script = var.metadata_start_script

  tags = ["ssh-enabled"]
}