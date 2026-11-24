# 1. Commencer par configurer un VPC (google_compute_network).
resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

# 2. Ajouter ensuite une instance de Compute Engine dans ce VPC (google_compute_instance).
resource "google_compute_instance" "default" {
    name         = "my-instance"
    machine_type = "n2-standard-2"
    zone         = "us-central1-a"

    tags = ["foo", "bar"]

    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-11"
            labels = {
                my_label = "value"
            }
        }
    }

    network_interface {
        network = "default"

        access_config {
            // Ephemeral public IP
        }
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
  }
}

# 4. Ajouter une entrer DNS (google_dns_record_set)

resource "google_dns_record_set" "frontend" {
    name = "frontend.${google_dns_managed_zone.prod.dns_name}"
    type = "A"
    ttl  = 300

    managed_zone = google_dns_managed_zone.prod.name

    rrdatas = [google_compute_instance.frontend.network_interface[0].access_config[0].nat_ip]
}

resource "google_compute_instance" "frontend" {
    name         = "frontend"
    machine_type = "g1-small"
    zone         = "us-central1-b"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }
}

resource "google_dns_managed_zone" "prod" {
    name     = "prod-zone"
    dns_name = "prod.mydomain.com."
}