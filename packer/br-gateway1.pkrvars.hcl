hostname = "br-gateway1"

cloud_init_include_files = [
  "/build/cloud-config/br-gateway1/user-data",
  "/build/cloud-config/br-gateway1/network-config"
]
