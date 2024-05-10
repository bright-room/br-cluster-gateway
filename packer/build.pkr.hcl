build {
  sources = ["source.arm.ubuntu_rpi"]

  provisioner "file" {
    sources = var.cloud_init_include_files
    destination = "/boot/firmware/"
  }
}
