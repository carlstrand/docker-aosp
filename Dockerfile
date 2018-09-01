#
# Minimum Docker image to build Android AOSP
#
FROM ubuntu:16.04

MAINTAINER Alexander Diewald <diewi@diewald-net.com>


#===============================================#
# CONFIG SECTION                                #
#===============================================#

# User that will be created within the docker container.
# Defaults to the user running the script, but can be overridden.
# UID must be aligned with the owner of the aosp tree.
ARG UID=1000
ARG UNAME=aospuser

#===============================================#

# /bin/sh points to Dash by default, reconfigure to use bash until Android
# build becomes POSIX compliant
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

# Keep the dependency list as short as reasonable
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential ccache curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2-utils lzop sudo \
        openjdk-8-jdk \
        pngcrush schedtool xsltproc zip zlib1g-dev graphviz && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# See http://source.android.com/source/initializing.html#setting-up-a-linux-build-environment
ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod +x /usr/local/bin/repo

# Copies the actual build script inside the container.
COPY buildaosp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/buildaosp.sh

# All builds will be done the following user. UID and username have to be provided
# in the config section
RUN id ${UNAME} 2>/dev/null || useradd --uid ${UID} --create-home --shell /bin/bash ${UNAME}


# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/mnt/android"]

# Work in the build directory, repo is expected to be init'd here
WORKDIR /mnt/android
USER ${UNAME}
CMD "/bin/bash"
