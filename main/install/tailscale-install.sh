#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://jellyfin.org/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y gpg
msg_ok "Installed Dependencies"

msg_info "Installing Tailscale"
ID=$(grep "^ID=" /etc/os-release | cut -d"=" -f2)
VER=$(grep "^VERSION_CODENAME=" /etc/os-release | cut -d"=" -f2)
curl -fsSL https://pkgs.tailscale.com/stable/$ID/$VER.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/$ID $VER main" >/etc/apt/sources.list.d/tailscale.list
$STD apt-get update &>/dev/null
$STD apt-get install -y tailscale &>/dev/null

msg_ok "Installed Tailscale"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"