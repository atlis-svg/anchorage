D="[Desktop Entry]
Type=Application
Name=Install Anchorage
Exec=pkexec calamares
Icon=calamares"
mkdir -p /home/live/.config/autostart /home/live/Desktop
echo "$D" > /home/live/.config/autostart/anchorage-install.desktop
echo "$D" > /home/live/Desktop/anchorage-install.desktop
chmod +x /home/live/Desktop/anchorage-install.desktop
chown -R live:live /home/live
mkdir -p /etc/polkit-1/rules.d
echo 'polkit.addRule(function(a, s) { if (s.isInGroup("wheel")) return polkit.Result.YES; });' > /etc/polkit-1/rules.d/49-live.rules
