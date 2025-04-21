variable "name" {}
variable "region" {}
variable "vpc_id" {}
variable "vpc_self_link" {}
variable "database_version" {
  default = "POSTGRES_16"
}
variable "tier" {
  default = "db-f1-micro"
}
variable "availability_type" {
  default = "ZONAL"
}
variable "user_name" {
  default = "postgres"
}
variable "user_password" {}