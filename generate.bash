#!/bin/bash

api="https://plex.tv/pms/downloads/5.json"
fileversion="./lastversion.txt"
lastversion=$(cat $fileversion)
version=$(curl -s $api | jq -r '.nas.QNAP.version')
shortversion=${version:0:-10}
date=$(curl -s $api | jq -r '.nas.QNAP.release_date')
published=$(date -d @$date -u +'%Y/%m/%d')
cache=$(date +'%Y%m%d%H%M%S')
repo_xml="./repo/repo.xml"


if [[ "$lastversion" == "$version" ]]
then
        echo "The version is the same"
else
        echo "La version is different"
        echo "<?xml version="1.0" encoding="utf-8"?>" > $repo_xml
        echo "<plugins>" >> $repo_xml
        echo "  <cachechk>$cache</cachechk>" >> $repo_xml
        echo "  <item>" >> $repo_xml
        echo "    <name>Plex Media Server</name>" >> $repo_xml
        echo "    <internalName>Plex Media Server</internalName>" >> $repo_xml
        echo "    <category>Essentials</category>" >> $repo_xml
        echo "    <type>Entertainment</type>" >> $repo_xml
        echo "    <icon80>https://download.qnap.com/QPKG/images/QPKG/plex_80.png</icon80>" >> $repo_xml
        echo "    <icon100>https://download.qnap.com/QPKG/images/QPKG/plex_80.png</icon100>" >> $repo_xml
        echo "    <description>Plex organizes all of your personal media so you can easily access and enjoy it. Notice: If you upgrade the QNAP firmware and the app stops working, please reinstall the app.</description>" >> $repo_xml
        echo "    <fwVersion>4.3.0</fwVersion>" >> $repo_xml
        echo "    <version>$shortversion</version>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-NASX86</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-x86_64.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-NASARM_64</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-aarch64.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31+</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7neon.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31P</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7neon.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31P2</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7neon.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31X</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7neon.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31XU</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7neon.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7hf.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X31U</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-armv7hf.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X28</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-aarch64.qpkg</location>" >> $repo_xml
        echo "    </platform>" >> $repo_xml
        echo "    <platform>" >> $repo_xml
        echo "      <platformID>TS-X32</platformID>" >> $repo_xml
        echo "      <location>https://downloads.plex.tv/plex-media-server-new/$version/qnap/PlexMediaServer-$version-aarch64.qpkg</location>" >> $repo_xml
        echo "     </platform>" >> $repo_xml
        echo "    <publishedDate>$published</publishedDate>" >> $repo_xml
        echo "    <maintainer>Plex</maintainer>" >> $repo_xml
        echo "    <forumLink>https://plex.tv</forumLink>" >> $repo_xml
        echo "    <snapshot>https://download.qnap.com/QPKG/img/PlexQNAPScreenshot.png</snapshot>" >> $repo_xml
        echo "    <tutorialLink>https://support.plex.tv/articles/200264746-quick-start-step-by-step-guides/#setting-up-and-installing-the-plex-media-server</tutorialLink>" >> $repo_xml
        echo "	<forumLink>https://forums.plex.tv/</forumLink>" >> $repo_xml
        echo "  </item>" >> $repo_xml
        echo "</plugins>" >> $repo_xml
        echo $version > $fileversion
        cp $repo_xml /var/www/html/repo.xml
fi