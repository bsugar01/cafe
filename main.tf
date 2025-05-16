provider "docker" {}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "web" {
  name  = "demo-nginx"
  image = docker_image.nginx.latest

  ports {
    internal = 80
    external = 8080
  }
}
