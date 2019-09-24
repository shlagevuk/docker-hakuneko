FROM lsiobase/guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HAKUNEKO_RELEASE
LABEL build_version="hakuneko with guacamole version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="shlagevuk"
ENV APPNAME="hakuneko"
ENV HAKUNEKO_VERSION="5.0.8"


RUN \
 echo "**** install runtime packages ****" && \
 apt-get update && \
 apt-get install -y \
        dbus \
        jq \
        python \
        wget \
        zenity \
	libxss1 && \
 echo "**** install hakuneko ****" && \
 if [ -z ${HAKUNEKO_RELEASE+x} ]; then \
        HAKUNEKO_RELEASE=$(curl -sX GET "https://api.github.com/repos/manga-download/hakuneko/releases/latest" \
        | jq -r .tag_name); \
 fi && \
 HAKUNEKO_VERSION="$(echo ${HAKUNEKO_RELEASE} | cut -c2-)" && \
 HAKUNEKO_URL="https://github.com/manga-download/hakuneko/releases/download/v${HAKUNEKO_VERSION}/hakuneko-desktop_${HAKUNEKO_VERSION}_linux_amd64.deb" && \
 echo "${HAKUNEKO_VERSION} ;; ${HAKUNEKO_URL}" && \
 curl -o /tmp/hakuneko.deb \
      -L "${HAKUNEKO_URL}" && \
 dpkg -i /tmp/hakuneko.deb && \
 dbus-uuidgen > /etc/machine-id && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*


COPY root/ /
