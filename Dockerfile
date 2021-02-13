FROM ich777/debian-baseimage:bullseye

LABEL maintainer="admin@minenet.at"

ARG GMMLIB_VERSION=20.3.2
ARG IGC_VERSION=1.0.6083
ARG NEO_VERSION=21.05.18936
ARG LEVEL_ZERO_VERSION=1.0.18936

RUN apt-get update && \
  apt-get -y install --no-install-recommends ca-certificates gnupg wget xz-utils apt-transport-https curl

RUN curl -s https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add - && \
  echo 'deb [arch=amd64] https://repo.jellyfin.org/debian bullseye main' > /etc/apt/sources.list.d/jellyfin.list && \
  apt-get update  &&\
  apt-get -y install --no-install-recommends jellyfin mesa-va-drivers jellyfin-ffmpeg openssl locales && \
  mkdir intel-compute-runtime && \
  cd intel-compute-runtime && \
  wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-gmmlib_${GMMLIB_VERSION}_amd64.deb && \
  wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-core_${IGC_VERSION}_amd64.deb && \
  wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-opencl_${IGC_VERSION}_amd64.deb && \
  wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-opencl_${NEO_VERSION}_amd64.deb && \
  wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-ocloc_${NEO_VERSION}_amd64.deb && \
  wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-level-zero-gpu_${LEVEL_ZERO_VERSION}_amd64.deb && \
  dpkg -i *.deb && \
  cd .. && \
  rm -rf intel-compute-runtime && \
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