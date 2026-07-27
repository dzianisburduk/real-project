data "google_compute_image" "debian_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

locals {
  name_prefix = "${var.project_name}-${var.env}"
}

resource "google_compute_instance" "my_first_project" {
  name         = "${local.name_prefix}-vm"
  machine_type = var.instance_type
  zone         = "europe-north1-a"

  labels = {
    owner = "denis_burduk"
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}