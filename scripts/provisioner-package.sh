#!/usr/bin/env bash

set -euo pipefail

# パッケージの最新化
apt update && apt -y upgrade

# iptables-persistentをインストール時に手動で入力する項目を自動で入力するようにするための事前設定
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

# 必要なライブラリ群を一括インストール
apt install -y \
    git \
    dnsutils \
    curl \
    ca-certificates \
    gnupg \
    netfilter-persistent \
    iptables-persistent \
    nftables \
    lsof \
    net-tools \
    jq
