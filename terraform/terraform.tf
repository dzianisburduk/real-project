terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = "project-bae25790-e2b6-4f2f-a8b"
  region  = var.region
  zone    = "${var.region}-a"

  default_labels = {
    owner = "denis_burduk"
  }
}