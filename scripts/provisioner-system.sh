#!/usr/bin/env bash

set -euo pipefail

# ホスト名を追加
echo "127.0.1.1 $(hostname)" >> /etc/hosts

# ネームサーバーの設定
mv /etc/resolv.conf /etc/resolv.conf.bk
cat <<'EOF' > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# cgroupの有効化
sed -i -e "1 s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/g" /boot/firmware/cmdline.txt

# GPUメモリの割り当てサイズを変更
echo "gpu_mem=16" >> /boot/firmware/config.txt

# apt upgradeを行うたびに、Pending kernel upgrade と表示されてしまうのでその対処
apt purge -y needrestart

# snapパッケーの削除
snap remove lxd && snap remove core22 && snap remove snapd
apt purge -y snapd
apt autoremove -y

# タイムゾーンの変更
timedatectl set-timezone Asia/Tokyo
