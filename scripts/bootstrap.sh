#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"

bash ./provisioner-system.sh
bash ./provisioner-package.sh
bash ./provisoner-docker.sh
bash ./provisioner-forward.sh
bash ./provisioner-firewall.sh

reboot -h
