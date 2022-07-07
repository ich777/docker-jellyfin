#!/bin/bash
echo "---Ensuring UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Ensuring GID: ${GID} matches user---"
groupmod -g ${GID} ${USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Checking for optional scripts---"
cp -f /opt/custom/user.sh /opt/scripts/start-user.sh > /dev/null 2>&1 ||:
cp -f /opt/scripts/user.sh /opt/scripts/start-user.sh > /dev/null 2>&1 ||:

if [ -f /opt/scripts/start-user.sh ]; then
    echo "---Found optional script, executing---"
    chmod -f +x /opt/scripts/start-user.sh.sh ||:
    /opt/scripts/start-user.sh || echo "---Optional Script has thrown an Error---"
else
    echo "---No optional script found, continuing---"
fi

if [ -d /dev/dri ]; then
	chmod -R 777 /dev/dri
fi

echo "---Taking ownership of data...---"
chown -R root:${GID} /opt/scripts
chmod -R 750 /opt/scripts
chown -R ${UID}:${GID} /config

echo "---Starting...---"
term_handler() {
	kill -SIGTERM "$killpid"
	wait "$killpid" -f 2>/dev/null
	exit 143;
}

echo "+---------------------------------------------------"
echo "| This container is now depricated!"
echo "| Please use the official Jellyfin container!"
echo "|"
echo "| This container is fully compatible to the official"
echo "| one, please use the official container!"
echo "|"
echo "| To do that just change the repository"
echo "| from 'ich777/jellyfin' to 'jellyfin/jellyfin'"
echo "+---------------------------------------------------"
echo
echo "---Container will start in 5 minutes!---"
sleep 5m

trap 'kill ${!}; term_handler' SIGTERM
su ${USER} -c "/usr/bin/jellyfin --datadir /config --cachedir /cache --ffmpeg /usr/lib/jellyfin-ffmpeg/ffmpeg --webdir=/usr/share/jellyfin/web" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done