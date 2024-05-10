hostname = "br-gateway2"

cloud_init_include_files = [
  "/build/cloud-init/br-gateway2/user-data",
  "/build/cloud-init/network-config"
]
