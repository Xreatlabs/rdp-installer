#!/bin/bash

#clear the console
clear

GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

echo -e "${CYAN}"
echo "     _/   _\\     "
echo "    /  Xreatlabs \\"
echo "   /______________\\"
echo -e "${RESET}"
echo -e "${GREEN}Welcome to Xreatlabs Remote Desktop Installer!${RESET}"

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root! Use sudo.${RESET}"
    exit 1
fi

update_system() {
    echo -e "${CYAN}Updating system packages...${RESET}"
    apt-get update -y && apt-get upgrade -y
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed to update system. Check your internet connection.${RESET}"
        exit 1
    fi
}

install_tigervnc() {
    echo -e "${CYAN}Installing TigerVNC server and XFCE desktop environment...${RESET}"
    apt-get install -y tigervnc-standalone-server tigervnc-common xfce4 xfce4-goodies xubuntu-desktop
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed to install TigerVNC or desktop environment. Exiting.${RESET}"
        exit 1
    fi
}

configure_tigervnc() {
    echo -e "${CYAN}Configuring TigerVNC server...${RESET}"
    mkdir -p ~/.vnc
    echo -e "${GREEN}Set a password for the VNC server:${RESET}"
    vncpasswd
    cat <<EOF >~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    chmod +x ~/.vnc/xstartup
}

enable_ipv4() {
    echo -e "${CYAN}Configuring TigerVNC for IPv4...${RESET}"
    systemctl enable vncserver@:1.service
    systemctl start vncserver@:1.service
    echo -e "${GREEN}TigerVNC is now configured with IPv4!${RESET}"
}

enable_ipv6() {
    echo -e "${CYAN}Configuring TigerVNC for IPv6...${RESET}"
    systemctl enable vncserver@:1.service
    systemctl start vncserver@:1.service
    echo -e "${GREEN}TigerVNC is now configured with IPv6!${RESET}"
}

configure_no_ipv4_ipv6() {
    echo -e "${CYAN}Configuring TigerVNC without IPv4 or IPv6...${RESET}"
    echo -e "${CYAN}Setting TigerVNC to listen only on the local socket...${RESET}"
    cat <<EOF > /etc/tigervnc/vncserver-config-mandatory
securitytypes=TLSNone
localhost
EOF
    systemctl enable vncserver@:1.service
    systemctl start vncserver@:1.service
    echo -e "${GREEN}TigerVNC is now configured to operate without IPv4/IPv6. Use SSH tunneling to connect.${RESET}"
}

echo -e "${GREEN}Choose the RDP configuration:${RESET}"
echo "1. Install RDP with IPv4"
echo "2. Install RDP with IPv6"
echo "3. Install RDP without IPv4 and IPv6 (Localhost only, via SSH tunneling)"
echo "4. Exit"

read -p "Enter your choice (1/2/3/4): " choice

case $choice in
1)
    update_system
    install_tigervnc
    configure_tigervnc
    enable_ipv4
    ;;
2)
    update_system
    install_tigervnc
    configure_tigervnc
    enable_ipv6
    ;;
3)
    update_system
    install_tigervnc
    configure_tigervnc
    configure_no_ipv4_ipv6
    echo -e "${CYAN}To connect, set up an SSH tunnel with:${RESET}"
    echo "ssh -L 5901:localhost:5901 user@your-server-ip"
    echo -e "${CYAN}Then, use a VNC viewer to connect to localhost:5901.${RESET}"
    ;;
4)
    echo -e "${CYAN}Exiting the script. Thank you for using Xreatlabs Installer!${RESET}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid choice. Exiting.${RESET}"
    exit 1
    ;;
esac
