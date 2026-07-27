variable "region" {
  type    = string
  default = "europe-north1"
}

variable "project_name" {
  type    = string
  default = "trainee-project"
}

variable "env" {
  type = string
}

variable "instance_configs" {
  type = map (string)
  default = {
    "backend": "t3.nano"
    "frontend": "t3.nano"
  }
}