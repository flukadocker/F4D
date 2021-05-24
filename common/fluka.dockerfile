FROM f4d_flair

ARG fluka_package
ARG fluka_version
ARG fluka_data

COPY $fluka_package /tmp
COPY $fluka_data /tmp
COPY ./common/motd /etc
COPY ./common/disclaimer /etc/profile.d/
COPY ./common/version_installed.sh /etc/profile.d/
COPY ./common/rfluka /tmp

ENV FLUFOR=gfortran
ENV FLUPRO=/usr/local/fluka
ENV FLUVER=$fluka_version

ARG UID=1000

RUN useradd -u $UID -c 'Fluka User' -m -d /home/fluka -s /bin/bash fluka && \
    echo "root:fluka" | chpasswd && \
    mkdir -p /usr/local/fluka && \
    tar -zxf /tmp/$fluka_package -C /usr/local/fluka && \
    tar -zxf /tmp/$fluka_data -C /usr/local/fluka && \
    cd /usr/local/fluka; make && \
    cp /tmp/rfluka /usr/local/fluka/flutil/ && \
    chmod 700 /usr/local/fluka/flutil/rfluka && \
    chown -R fluka:fluka /usr/local/fluka && \
    mkdir /docker_work && \
    chown -R fluka:fluka /docker_work && \
    chmod 755 /etc/profile.d/version_installed.sh  && \
    chmod 755 /etc/profile.d/disclaimer  && \
    chmod 755 /etc/motd  

USER fluka

ENV LOGNAME=fluka
ENV USER=fluka
ENV HOME /home/fluka
WORKDIR /docker_work
