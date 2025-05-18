#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/vtorres-t/Proxmox/refs/heads/main/main/misc/build.func)

APP="Tailscale"
var_tags="${var_tags:-vpn}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-1024}"
var_disk="${var_disk:-8}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
     header_info
     check_container_storage
     check_container_resources
     if [[ ! -d /usr/lib/jellyfin ]]; then
          msg_error "No ${APP} Installation Found!"
          exit
     fi
     msg_info "Updating ${APP} LXC"
     $STD apt-get update
     $STD apt-get -y upgrade
     $STD apt-get -y --with-new-pkgs upgrade tailscale
     msg_ok "Updated ${APP} LXC"
     exit
}

start
build_container

CTID_CONFIG_PATH=/etc/pve/lxc/${CTID}.conf
cat <<EOF >>$CTID_CONFIG_PATH
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
EOF

description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
