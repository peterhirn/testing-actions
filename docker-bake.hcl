target "docker-metadata-action" {}

group "default" {
    targets = ["alpine-runtime"]
}

target "base" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64",
    "linux/arm/v7",
    "linux/arm64",
  ]
}

target "alpine" {
  inherits = ["base"]
  target = "alpine"
}

target "bullseye" {
  inherits = ["base"]
  target = "bullseye"
}

target "alpine-runtime" {
  inherits = ["base"]
  target = "alpine-runtime"
}

target "bullseye-runtime" {
  inherits = ["base"]
  target = "bullseye-runtime"
}
