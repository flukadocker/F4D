FROM flukadocker/f4d_baseimage

ARG flair_version

# Uncomment the following lines to install needed packages (separate package names with SPACE)
#RUN dnf install -y <package_names_here> && \
#    dnf clean all

RUN rpm -ivh http://www.fluka.org/flair/flair-$flair_version.noarch.rpm \
             http://www.fluka.org/flair/flair-geoviewer-$flair_version.x86_64.rpm
