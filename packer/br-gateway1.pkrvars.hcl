hostname = "br-gateway1"

cloud_init_include_files = [
  "/build/cloud-init/br-gateway1/user-data",
  "/build/cloud-init/network-config"
]
