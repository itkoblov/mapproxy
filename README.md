# Docker container with Mapproxy on apache2

This container runs Apache 2 with Mapproxy configured to working together.

This container has the following parameters:

* Port "80", where Apache 2 listens on.
* Folder "mapproxy/cache_data/", where cahed tiles are placed.

The following URLs are available:

* Mapproxy interface http://container-ip/mapproxy/
* WMS service URL: http://container-ip/mapproxy/service

# Create a container with my proxy

```sh
git clone https://github.com/itkoblov/mapproxy.git
cd mapproxy
docker build -t mapproxy-test . --build-arg HTTP_PROXY="http://10.33.46.5:8080"
```

# Starting the container

```sh
cd mapproxy
docker compose up -d
```
