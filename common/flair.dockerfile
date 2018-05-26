FROM horvathd84/f4d_baseimage

ARG flair_version

RUN rpm -ivh http://www.fluka.org/flair/flair-$flair_version.noarch.rpm \
             http://www.fluka.org/flair/flair-geoviewer-$flair_version.x86_64.rpm
