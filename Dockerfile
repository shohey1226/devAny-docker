# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM ubuntu:16.04
MAINTAINER Shohei Kameda<shoheik@cpan.org>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs supervisor 
RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
RUN update-rc.d supervisor defaults

# Add supervisord conf
ADD conf/supervisor/* /etc/supervisor/conf.d/

#------------------------------------------------------------------------------
# ttyd
#------------------------------------------------------------------------------
RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:tsl0922/ttyd-dev -y
RUN apt-get update
RUN apt-get install -y ttyd

#------------------------------------------------------------------------------
# apache/webdav
#------------------------------------------------------------------------------
RUN apt-get install -y apache2 apache2-utils
RUN a2enmod dav dav_fs proxy rewrite proxy_http proxy_wstunnel
RUN a2dissite 000-default
RUN sed -i -e 's_80_8888_g' /etc/apache2/ports.conf
ADD conf/apache2/webdav.conf /etc/apache2/sites-available/webdav.conf
RUN a2ensite webdav
ADD conf/apache2/envvars /etc/apache2/envvars
ADD conf/apache2/proxy.conf /etc/apache2/sites-available/proxy.conf
RUN a2ensite proxy

#------------------------------------------------------------------------------
# devAny
#------------------------------------------------------------------------------
ADD devany /usr/local/bin

#------------------------------------------------------------------------------
# desktop user
#------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    libreadline-dev \
    ca-certificates \
    curl \
    git \
    libssl-dev \
    tmux \
    vim-nox \
    make \
    less \
    iputils-ping net-tools wget dnsutils \
    locales \
    sudo \
    file \
    python-setuptools \
    libsqlite3-dev

# set up locale
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
ADD scripts/run.sh /
CMD ["/run.sh"]




