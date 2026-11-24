# 1. Commencer par configurer un VPC (google_compute_network).

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}



# 2. Ajouter ensuite une instance de Compute Engine dans ce VPC (google_compute_instance).

resource "google_compute_instance" "default" {
    name         = "my-instance"
    machine_type = "n2-standard-2"
    zone         = "us-central1-a"

    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-11"
        }
    }

    network_interface {
        network = "google_compute_network.vpc_network.id"       #Changer le network avec le VPC
    }
}



# 3. Également dans ce VPC, ajouter une base de donnée. (google_sql_database_instance)

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {                  #Ajouter ce parametre pour le relier avec le VPC
        private_network = google_compute_network.vpc_network.id
    }
  }
}



# 4. Ajouter une entrer DNS (google_dns_record_set)

resource "google_dns_record_set" "exemple" {
    managed_zone = "kiowy.com"
    name         = "www.kiowy.com."
    type         = "A"
    rrdatas      = ["192.0.2.1"]
}