#FROM flukadocker/f4d_baseimage
FROM f4d_base_ubuntu_focal

ARG flair_version

# Uncomment the following lines to install needed packages (separate package names with SPACE)
#RUN dnf install -y <package_names_here> && \
#    dnf clean all

RUN wget http://www.fluka.org/flair/flair_${flair_version}_all.deb && \
    wget http://www.fluka.org/flair/flair-geoviewer_${flair_version}_amd64.deb && \
    dpkg --install flair_${flair_version}_all.deb && \
    dpkg --install flair-geoviewer_${flair_version}_amd64.deb && \
    rm flair_${flair_version}_all.deb flair-geoviewer_${flair_version}_amd64.deb
