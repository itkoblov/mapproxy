FROM phusion/baseimage:jammy-1.0.4

# Set the locale
ENV LANG=C.UTF-8
RUN update-locale LANG=C.UTF-8

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}
ENV no_proxy=${NO_PROXY}

RUN apt-get update -y && \
    apt-get install -y libapache2-mod-wsgi-py3 python3-pip python3-pyproj supervisor apache2 python3-dev libgeos-dev libjpeg-dev zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install Shapely Pillow MapProxy uwsgi webcolors

# Create a "mapproxy" folder
RUN mkdir /usr/local/mapproxy

# Configure supervisord
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor

# Expose the webserver
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord"]
