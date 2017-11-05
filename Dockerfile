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

# Tweak standlone.js conf
# RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

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
# webdav
#------------------------------------------------------------------------------
RUN apt-get install -y apache2 apache2-utils

RUN a2enmod dav dav_fs proxy rewrite proxy_http proxy_wstunnel
RUN a2dissite 000-default

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/tmp/log/apache2
ENV APACHE_PID_FILE /var/tmp/run/apache2.pid
ENV APACHE_LOCK_DIR /var/tmp/lock/apache2
ENV APACHE_RUN_DIR /var/tmp/run/apache2

#RUN mkdir -p /var/lock/apache2; chown www-data /var/lock/apache2
#RUN mkdir -p /var/webdav; chown www-data /var/webdav
RUN sed -i -e 's_80_8888_g' /etc/apache2/ports.conf

ADD conf/apache2/webdav.conf /etc/apache2/sites-available/webdav.conf
RUN a2ensite webdav
ADD conf/apache2/envvars /etc/apache2/envvars

ADD conf/apache2/proxy.conf /etc/apache2/mods-enabled/proxy.conf

#------------------------------------------------------------------------------
# devAny
#------------------------------------------------------------------------------
ADD devany /usr/local/bin

#------------------------------------------------------------------------------
# desktop user
#------------------------------------------------------------------------------
RUN apt-get install -y --no-install-recommends build-essential \
    ca-certificates \
    curl \
    git \
    libssl-dev \
    tmux \
    vim-nox \
    make \
    less \
    sudo

# ------------------------------------------------------------------------------
# Add volumes
#RUN mkdir /workspace
#VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
#EXPOSE 8080 # using reserve proxy
EXPOSE 3000

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
ADD scripts/run.sh /
CMD ["/run.sh"]

#CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]



