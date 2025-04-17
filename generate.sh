#!/bin/bash

# Configuration
api="https://plex.tv/pms/downloads/5.json"
fileversion="./lastversion.txt"
repo_xml="./repo/repo.xml"
repo_dir="/opt/Unofficial-QNAP-Plex-Repo"
branch="main"

# Fetch the current version
lastversion=$(cat $fileversion)
version=$(curl -s $api | jq -r '.nas.QNAP.version')
shortversion=${version:0:-10}
date=$(curl -s $api | jq -r '.nas.QNAP.release_date')
published=$(date -d @$date -u +'%Y/%m/%d')
cache=$(date +'%Y%m%d%H%M%S')

cd $repo_dir || { echo "Error: Cannot access directory $repo_dir"; exit 1; }

# Check if the version has changed
if [[ "$lastversion" == "$version" ]]; then
    echo "The version is the same, no update needed."
    exit 0
fi

# Generate the XML file
echo "The version is different, updating..."
{
    echo "<?xml version='1.0' encoding='utf-8'?>"
    echo "<plugins>"
    echo "  <cachechk>$cache</cachechk>"
    echo "  <item>"
    echo "    <name>Plex Media Server</name>"
    echo "    <internalName>Plex Media Server</internalName>"
    echo "    <category>Essentials</category>"
    echo "    <type>Entertainment</type>"
    echo "    <icon80>https://download.qnap.com/QPKG/images/QPKG/plex_80.png</icon80>"
    echo "    <icon100>https://download.qnap.com/QPKG/images/QPKG/plex_80.png</icon100>"
    echo "    <description>Plex organizes all of your personal media so you can easily access and enjoy it.</description>"
    echo "    <fwVersion>4.3.0</fwVersion>"
    echo "    <version>$shortversion</version>"
    
    platforms=(
        "TS-NASX86 x86_64"
	"OLD_X86 x86_64"
	"TS-X70 x86_64"
 	"TS-X79 x86_64"
        "TS-NASARM_64 aarch64"
        "TS-X28 aarch64"
        "TS-X32 aarch64"
        "TS-X32U aarch64"
	"TS-X31XEU armv7neon"
        "TS-XA28A aarch64"
        "TS-X31P2 armv7neon"
        "TS-X31P3 armv7neon"
        "TS-X31X armv7neon"
        "TS-X31XU armv7neon"
        "TS-531P armv7neon"
        "TS-X31 armv7hf"
    )
    
    for platform in "${platforms[@]}"; do
        IFS=' ' read -r platformID arch <<< "$platform"
        echo "    <platform>"
        echo "      <platformID>$platformID</platformID>"
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-$arch.qpkg</location>"
        echo "    </platform>"
    done
    
    echo "    <publishedDate>$published</publishedDate>"
    echo "    <maintainer>Plex</maintainer>"
    echo "    <forumLink>https://plex.tv</forumLink>"
    echo "    <snapshot>https://download.qnap.com/QPKG/img/PlexQNAPScreenshot.png</snapshot>"
    echo "    <tutorialLink>https://support.plex.tv/articles/200264746-quick-start-step-by-step-guides/</tutorialLink>"
    echo "    <forumLink>https://forums.plex.tv/</forumLink>"
    echo "  </item>"
    echo "</plugins>"
} > $repo_xml

# Save the new version
echo $version > $fileversion
exit 0
