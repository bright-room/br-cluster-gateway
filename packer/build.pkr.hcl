build {
  sources = ["source.arm.ubuntu_rpi"]

  provisioner "file" {
    sources = var.cloud_init_include_files
    destination = "/boot/firmware/"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /provisioner/scripts",
    ]
  }

  provisioner "file" {
    sources = [
      "/build/scripts/bootstrap.sh",
      "/build/scripts/provisioner-system.sh",
      "/build/scripts/provisioner-package.sh",
      "/build/scripts/provisoner-docker.sh",
      "/build/scripts/provisioner-forward.sh",
      "/build/scripts/provisioner-firewall.sh",
    ]
    destination = "/provisioner/scripts/"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /provisioner/scripts/*",
    ]
  }
}
