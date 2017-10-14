FROM ubuntu:16.04
MAINTAINER shoheik@cpan.org

#------------------------------------------------------------------------------
# webdav
#------------------------------------------------------------------------------
RUN apt-get update
RUN apt-get install -y apache2 apache2-utils

RUN a2enmod dav dav_fs
RUN a2dissite 000-default

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

RUN mkdir -p /var/lock/apache2; chown www-data /var/lock/apache2
RUN mkdir -p /var/webdav; chown www-data /var/webdav

ADD webdav.conf /etc/apache2/sites-available/webdav.conf
RUN a2ensite webdav

ADD run.sh /

EXPOSE 80

#VOLUME /var/webdav

#------------------------------------------------------------------------------
# ttyd
#------------------------------------------------------------------------------
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:tsl0922/ttyd-dev
RUN apt-get update
RUN apt-get install ttyd -y

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

#------------------------------------------------------------------------------
# devAny
#------------------------------------------------------------------------------

ADD devany /usr/local/bin

CMD ["/run.sh"]
