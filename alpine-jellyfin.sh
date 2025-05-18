#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

APP="Jellyfin"
var_tags="${var_tags:-media}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-0.5}"
var_os="${var_os:-alpine}"
var_version="${var_version:-3.21}"
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
     $STD apt-get -y --with-new-pkgs upgrade jellyfin jellyfin-server
     msg_ok "Updated ${APP} LXC"
     exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8096${CL}"
