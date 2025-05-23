output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}