# WSGI module for use with Apache mod_wsgi or gunicorn

# # uncomment the following lines for logging
# # create a log.ini with `mapproxy-util create -t log-ini`
#from logging.config import fileConfig
#import os.path
#fileConfig(r'/usr/local/mapproxy/log.ini', {'here': os.path.dirname(__file__)})

from mapproxy.wsgiapp import make_wsgi_app
import os

def application(environ, start_response):
    config_file = os.path.join(os.path.dirname(__file__), 'mapproxy-mapnik.yaml')
    app = make_wsgi_app(config_file)
    return app(environ, start_response)
