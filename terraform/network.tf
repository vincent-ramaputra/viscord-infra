resource "google_compute_network" "dev_network" {
    name = "dev-network"
    auto_create_subnetworks = false
}

# resource "google_compute_network" "prod_network" {
#     name = "prod-network"
#     auto_create_subnetworks = false
# }

resource "google_compute_subnetwork" "dev_subnet" {
    name = "dev-subnet"
    ip_cidr_range = "10.1.0.0/16"
    network = google_compute_network.dev_network.id
}

# resource "google_compute_subnetwork" "prod_subnet" {
#     name = "prod-subnet"
#     ip_cidr_range = "10.2.0.0/16"
#     network = google_compute_network.prod_network.id
# }

resource "google_compute_global_address" "dev_reserve" {
    name = "dev-reserve"
    purpose = "VPC_PEERING"
    address_type = "INTERNAL"
    address = "10.10.0.0"
    prefix_length = 16
    network = google_compute_network.dev_network.id
}

# resource "google_compute_global_address" "prod_reserve" {
#     name = "prod-reserve"
#     purpose = "VPC_PEERING"
#     address_type = "INTERNAL"
#     address = "10.20.0.0"
#     prefix_length = 16
# }

resource "google_service_networking_connection" "dev_peering" {
    network = google_compute_network.dev_network.id
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.dev_reserve.name]
}