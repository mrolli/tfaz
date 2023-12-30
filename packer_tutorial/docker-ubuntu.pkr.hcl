# https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-build-image
packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.8"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "docker_image" {
  type = string
  default = "ubuntu:jammy"
}

source "docker" "ubuntu" {
  image  = var.docker_image
  commit = true
}

source "docker" "ubuntu-focal" {
  image  = "ubuntu:focal"
  commit = true
}

build {
  name    = "learn-packer"
  sources = [
    "source.docker.ubuntu",
    "source.docker.ubuntu-focal"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo Running $(cat /etc/os-release | grep VERSION= | sed 's/\"//g' | sed 's/VERSION=//g') Docker image."]
  }
}
