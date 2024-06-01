#! /bin/bash

set -euo pipefail

CREDENTIAL_FILE="/cloud-config-generator/credentials/${SERVER_NAME}.yaml"

# users
ROOT_PASSWORD=".users.root.password"

OPERATION_USER_NAME=".users.operation_user.user_name"
OPERATION_USER_PASSWORD=".users.operation_user.password"
OPERATION_USER_PUBLIC_KEY=".users.operation_user.public_key"

# networks
INTERNAL_IP_ADDRESS=".networks.internal.ip_address"

EXTERNAL_IP_ADDRESS=".networks.external.ip_address"
EXTERNAL_GATEWAY_IP_ADDRESS=".networks.external.gateway_ip"

WIFI_SSID=".networks.external.wifi.ssid"
WIFI_PASSPHRASE=".networks.external.wifi.passphrase"

function create_directory() {
    rm -fr /cloud-config-generator/generated/${SERVER_NAME}
    mkdir /cloud-config-generator/generated/${SERVER_NAME}
}

function generate_network_config() {
    internal_ip_address=$(yq "${INTERNAL_IP_ADDRESS}" "${CREDENTIAL_FILE}")

    external_ip_address=$(yq "${EXTERNAL_IP_ADDRESS}" "${CREDENTIAL_FILE}")
    external_gateway_ip_address=$(yq "${EXTERNAL_GATEWAY_IP_ADDRESS}" "${CREDENTIAL_FILE}")

    ssid=$(yq "${WIFI_SSID}" "${CREDENTIAL_FILE}")
    passphrase=$(yq "${WIFI_PASSPHRASE}" "${CREDENTIAL_FILE}")

    wpa_passphrase "${ssid}" "${passphrase}" > /tmp/wpa_config.txt
    hashed_passphrase=$(cat /tmp/wpa_config.txt | sed -E 's/^[ \t]+//' | grep -E '^psk=' | cut -d'=' -f 2)

    jinja2 /cloud-config-generator/templates/network-config.j2 \
      -D "internal_ip_address=${internal_ip_address}" \
      -D "external_ip_address=${external_ip_address}" \
      -D "external_gateway_ip=${external_gateway_ip_address}" \
      -D "ssid=${ssid}" \
      -D "hashed_password=${hashed_passphrase}" \
      > /cloud-config-generator/generated/${SERVER_NAME}/network-config
}

function generate_user_data() {
    root_password=$(openssl passwd -6 -salt=salt $(yq "${ROOT_PASSWORD}" "${CREDENTIAL_FILE}"))

    operation_user_name=$(yq "${OPERATION_USER_NAME}" "${CREDENTIAL_FILE}")
    operation_user_password=$(openssl passwd -6 -salt=salt $(yq "${OPERATION_USER_PASSWORD}" "${CREDENTIAL_FILE}"))
    operation_user_public_key=$(yq "${OPERATION_USER_PUBLIC_KEY}" "${CREDENTIAL_FILE}")

    jinja2 /cloud-config-generator/templates/user-data.j2 \
          -D "hostname=${SERVER_NAME}" \
          -D "root_password=${root_password}" \
          -D "operation_user_name=${operation_user_name}" \
          -D "operation_user_password=${operation_user_password}" \
          -D "operation_user_public_key=${operation_user_public_key}" \
          > /cloud-config-generator/generated/${SERVER_NAME}/user-data
}

create_directory
generate_network_config
generate_user_data
