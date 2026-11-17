B=/usr/share/calamares/branding
cp -r $B/default $B/anchorage
cp /tmp/logo.png $B/anchorage/logo.png
sed -i 's/Fancy GNU\/Linux/Anchorage/g; s/^componentName:.*/componentName: anchorage/' $B/anchorage/branding.desc
sed -i 's|productLogo:.*|productLogo: "logo.png"|; s|productIcon:.*|productIcon: "logo.png"|' $B/anchorage/branding.desc
mkdir -p /etc/calamares
cp /usr/share/calamares/settings.conf /etc/calamares/settings.conf
sed -i 's/^branding:.*/branding: anchorage/' /etc/calamares/settings.conf
grep -n Fancy $B/anchorage/branding.desc
