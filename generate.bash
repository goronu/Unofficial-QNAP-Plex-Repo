#!/bin/bash

# Configuration
api="https://plex.tv/pms/downloads/5.json"
fileversion="./lastversion.txt"
repo_xml="./repo/repo.xml"
repo_dir="/opt/Unofficial-QNAP-Plex-Repo"
branch="main"
github_token="YOUR_GITHUB_TOKEN"
github_repo="https://$github_token@github.com/your_user/your_repo.git"

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
    echo "    <description>Plex organizes all of your personal media so you can easily access and enjoy it. Notice: If you upgrade the QNAP firmware and the app stops working, please reinstall the app.</description>"
    echo "    <fwVersion>4.3.0</fwVersion>"
    echo "    <version>$shortversion</version>"
    echo "    <platform>"
    echo "      <platformID>TS-NASX86</platformID>"
    echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-x86_64.qpkg</location>"
    echo "    </platform>"
    echo "    <platform>"
    echo "      <platformID>TS-NASARM_64</platformID>"
    echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-aarch64.qpkg</location>"
    echo "    </platform>"
    echo "    <publishedDate>$published</publishedDate>"
    echo "    <maintainer>Plex</maintainer>"
    echo "    <forumLink>https://plex.tv</forumLink>"
    echo "    <snapshot>https://download.qnap.com/QPKG/img/PlexQNAPScreenshot.png</snapshot>"
    echo "    <tutorialLink>https://support.plex.tv/articles/200264746-quick-start-step-by-step-guides/#setting-up-and-installing-the-plex-media-server</tutorialLink>"
    echo "    <forumLink>https://forums.plex.tv/</forumLink>"
    echo "  </item>"
    echo "</plugins>"
} > $repo_xml

# Save the new version
echo $version > $fileversion

# Add, commit, and push changes to GitHub
echo "Pushing changes to GitHub..."
git add *
git commit -m "Update to version $shortversion"
if git push origin $branch; then
    echo "Changes successfully pushed to GitHub."
else
    echo "Error pushing to GitHub. Check your token or permissions."
    exit 1
fi
