FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-jellyfin"

ARG MEDIA_DRV_VERSION=21.2.3
ARG BUILD_TAG="default"

RUN apt-get update && \
  apt-get -y install --no-install-recommends ca-certificates gnupg wget xz-utils apt-transport-https curl nvidia-opencl-icd intel-opencl-icd mesa-opencl-icd

RUN curl -s https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add - && \
  echo 'deb [arch=amd64] https://repo.jellyfin.org/debian bullseye main unstable' > /etc/apt/sources.list.d/jellyfin.list && \
  apt-get update  &&\
  apt-get -y install --no-install-recommends jellyfin-server=*-unstable jellyfin-web=*-unstable jellyfin-ffmpeg mesa-va-drivers jellyfin-ffmpeg openssl locales && \
  wget -O /tmp/intel-media.tar.gz https://github.com/ich777/media-driver/releases/download/intel-media-${MEDIA_DRV_VERSION}/intel-media-${MEDIA_DRV_VERSION}.tar.gz && \
  cd /tmp && \
  tar -C / -xvf /tmp/intel-media.tar.gz && \
  rm -rf /tmp/intel-media.tar.gz && \
  apt-get remove gnupg apt-transport-https curl -y && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p /cache /config /media && \
  chmod 777 /cache /config /media && \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV DATA_DIR=/config
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="jellyfin"

RUN userdel $USER && \
  useradd -s /bin/bash $USER && \
  ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R ${UID}:${GID} /mnt && \
	chmod -R 770 /mnt

EXPOSE 8096

VOLUME /cache /config /media

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]