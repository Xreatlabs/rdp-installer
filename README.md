---

Xreatlabs Remote Desktop Installer

This script installs and configures a remote desktop server using TigerVNC. It offers flexibility to configure the server for:

IPv4

IPv6

Localhost-only mode (no IPv4/IPv6, connects via SSH tunneling).



---

Features

1. Lightweight Installation: Uses TigerVNC, a fast and efficient remote desktop solution.


2. Customizable Configuration:

IPv4 support.

IPv6 support.

Localhost-only for secure SSH tunneling.



3. Automatic Setup:

Installs and configures TigerVNC and XFCE desktop environment.

Custom xstartup configuration for smooth desktop experience.



4. SSH Tunneling Support:

Secure, local-only option for environments without IPv4/IPv6.





---

Requirements

Supported OS: Ubuntu/Debian-based systems.

Root Access: Run the script with sudo.

Network Configuration:

Ensure SSH is enabled for the localhost-only option.

Open VNC ports (5901) in the firewall for IPv4/IPv6 modes.




---

Usage

Step 1: Clone the Repository

Clone the Xreatlabs RDP Installer repository:

git clone https://github.com/xreatlabs/Rdp-installer.git
cd Rdp-installer

Step 2: Make the Script Executable

chmod +x rdp.sh

Step 3: Run the Script

Run the script with root privileges:

bash ./rdp.sh


---

Options in the Script

After running the script, you’ll be prompted to choose from the following options:

1. Install RDP with IPv4
Configures TigerVNC to bind to all IPv4 addresses.
Command to connect: Use your VNC client and connect to server-ip:5901.


2. Install RDP with IPv6
Configures TigerVNC to bind to all IPv6 addresses.
Command to connect: Use your VNC client and connect to [server-ip]:5901.


3. Install RDP without IPv4 and IPv6
Configures TigerVNC to listen on localhost only. Use SSH tunneling for secure access.
Command to set up SSH tunnel:

ssh -L 5901:localhost:5901 user@your-server-ip

Then, connect to localhost:5901 with your VNC client.


4. Exit
Exits the script.




---

Firewall Configuration

For IPv4/IPv6 modes, ensure the VNC port (default 5901) is open:

sudo ufw allow 5901

For the localhost-only mode, no additional firewall rules are needed.


---

How to Connect

1. Install a VNC client like TigerVNC Viewer, RealVNC, or TightVNC on your computer.


2. Use the following connection strings based on your setup:

IPv4: server-ip:5901

IPv6: [server-ip]:5901

Localhost (via SSH tunnel): localhost:5901





---

Uninstallation

To remove TigerVNC and related configurations:

sudo apt-get remove --purge tigervnc-standalone-server tigervnc-common -y
sudo apt-get autoremove -y
rm -rf ~/.vnc


---

Troubleshooting

1. TigerVNC Service Issues:

Check the service status:

systemctl status vncserver@:1.service

Restart the service:

systemctl restart vncserver@:1.service



2. Connection Refused:

Ensure the port (5901) is open if using IPv4/IPv6.

For localhost mode, confirm the SSH tunnel is active.



3. VNC Client Black Screen:

Ensure the ~/.vnc/xstartup file is correctly configured:

# Content of ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &

Make it executable:

chmod +x ~/.vnc/xstartup





---

License

This project is licensed under the MIT License. See the LICENSE file for details.


---

Credits

Developed by Xreatlabs
Providing robust and flexible remote desktop solutions for modern infrastructure.


---

Repository

GitHub - Xreatlabs RDP Installer


---
