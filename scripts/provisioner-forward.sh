#!/usr/bin/env bash

set -euo pipefail

# IPフォワード有効化
sysctl -w net.ipv4.ip_forward=1 >> /etc/sysctl.conf
