FROM f4d_flair

ARG fluka_package

COPY $fluka_package /tmp
COPY ./common/motd /etc
COPY ./common/disclaimer /etc/profile.d/
COPY ./common/version_installed.sh /etc/profile.d/
COPY ./common/rfluka /tmp

ENV FLUFOR=gfortran
ENV FLUPRO=/usr/local/fluka
ENV FLDCKR=1

ARG UID=1000

RUN useradd -u $UID -c 'Fluka User' -m -d /home/fluka -s /bin/bash fluka && \
    mkdir -p /usr/local/fluka && \
    tar -zxf /tmp/fluka*.tar.gz -C /usr/local/fluka && \
    cd /usr/local/fluka; make && \
    cp /tmp/rfluka /usr/local/fluka/flutil/ && \
    chmod 700 /usr/local/fluka/flutil/rfluka && \
    chown -R fluka:fluka /usr/local/fluka && \
    rm -rf /tmp/fluka*.tar.gz /tmp/rfluka && \
    mkdir /docker_work && \
    chown -R fluka:fluka /docker_work && \
    chmod 755 /etc/profile.d/version_installed.sh

USER fluka

ENV LOGNAME=fluka
ENV USER=fluka
ENV HOME /home/fluka
WORKDIR /home/fluka
