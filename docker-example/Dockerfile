FROM ubuntu:latest
ARG GID
ARG UID
ARG USER
RUN groupadd -g $GID $USER
RUN useradd -r -u $UID -g $GID $USER
USER mbussonnier
CMD /bin/bash -c 'echo $(id)'
