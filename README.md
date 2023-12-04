This script will installl VSCode, Wireshark, Evolution mail and a few extra utilities needed to work.

Download the script and make it executable:

chmod a+x fedora_csb_deploy_rh.sh

Once completed, run it as Super User

sudo ./fedora_csb_deploy_rh.sh

To enable both Wayland and Fractional scaling, after running the script follow these steps:

1) Edit GDM configuration to enable Wayland

  a. sudo nano /etc/gdm/custom.conf

  b. Comment the options shown below  

    [daemon]
      # Uncomment the line below to force the login screen to use Xorg
      #WaylandEnable=false
      #DefaultSession=gnome-xorg.desktop
      
2) Enable Fractional scaling

  a. gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

3) Restart the computer
