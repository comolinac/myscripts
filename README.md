Fedora post-deployment script here

To enable both Wayland and Fractional scaling, after running the script follow these steps:

1) Edit GDM configuration to enble Wayland

  a. sudo nano /etc/gdm/custom.conf

  b. Comment the options shown below  

    [daemon]
      # Uncomment the line below to force the login screen to use Xorg
      #WaylandEnable=false
      #DefaultSession=gnome-xorg.desktop
      
2) Enable Fractional scaling

  a. gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

3) Restart the computer
