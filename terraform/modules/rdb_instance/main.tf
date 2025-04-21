# Subnet for RDS
resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.name}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_id
}
# V
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

resource "random_id" "suffix" {
  byte_length = 4
}


resource "google_sql_database_instance" "postgres_instance" {
  name             = "${var.name}-${random_id.suffix.hex}"
  region           = var.region
  database_version = var.database_version

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.tier
    edition = "ENTERPRISE"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.vpc_self_link
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled = true
    }

    availability_type = var.availability_type
  }
}

resource "google_sql_user" "default" {
  name     = var.user_name
  instance = google_sql_database_instance.postgres_instance.name
  password = var.user_password
}