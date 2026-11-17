F=/usr/share/calamares/branding/anchorage/branding.desc
for k in productName shortProductName; do
    sed -i "s/^\( *$k:\).*/\1 \"Anchorage\"/" $F
done
for k in version shortVersion; do
    sed -i "s/^\( *$k:\).*/\1 \"1.0\"/" $F
done
for k in versionedName shortVersionedName; do
    sed -i "s/^\( *$k:\).*/\1 \"Anchorage 1.0\"/" $F
done
sed -i "s/^\( *bootloaderEntryName:\).*/\1 \"Anchorage\"/" $F
sed -i 's/^slideshow:.*/slideshow: [ "slide.png" ]/' $F
cat > /etc/calamares/modules/welcome.conf << 'X'
showSupportUrl: false
showKnownIssuesUrl: false
showReleaseNotesUrl: false
showDonateUrl: false
X
sed -i 's/^NAME=.*/NAME="Anchorage"/; s/^PRETTY_NAME=.*/PRETTY_NAME="Anchorage 1.0"/' /etc/os-release
grep -n "Fancy\|Vole\|2023" $F
