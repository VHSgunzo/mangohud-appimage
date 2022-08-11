FROM debian:bullseye

RUN apt update
RUN apt install -y git wget file curl unzip sudo

COPY ./download-linuxdeploy.sh /download-linuxdeploy.sh
RUN bash /download-linuxdeploy.sh

COPY ./build.sh /build.sh
RUN bash /build.sh

COPY ./create-appimage.sh /create-appimage.sh
ENTRYPOINT /create-appimage.sh

ENTRYPOINT [ "/bin/bash", "/create-appimage.sh" ]

CMD [ "/bin/bash" ]
