FROM phusion/baseimage:focal-1.2.0

# Set the locale
ENV LANG=C.UTF-8
RUN update-locale LANG=C.UTF-8

# Set up environment variables for HTTP proxy
ARG HTTP_PROXY
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTP_PROXY}
#ENV no_proxy=127.0.0.1,localhost

RUN apt-get update -y && \
    apt-get install -y libapache2-mod-wsgi-py3 python3-pip python3-pyproj supervisor apache2 python3-dev libgeos-dev libjpeg-dev zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install Shapely Pillow MapProxy uwsgi webcolors

# Create a `mapproxy` service
RUN mkdir /usr/local/mapproxy
# No need to create cache_data directory here, as it will be mounted from the host
#RUN mkdir /usr/local/mapproxy/cache_data
#RUN chmod a+rwx /usr/local/mapproxy/cache_data
ADD mapproxy-mapnik.yaml /usr/local/mapproxy/mapproxy-mapnik.yaml
#ADD log.ini /usr/local/mapproxy/log.ini
ADD config.py /usr/local/mapproxy/config.py
RUN a2enmod wsgi
RUN a2enmod rewrite
RUN a2dissite 000*
ADD tileserver.conf /etc/apache2/sites-available/tileserver.conf
RUN a2ensite tileserver.conf
RUN a2enmod rewrite

# Configure supervisord
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the webserver
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord"]
